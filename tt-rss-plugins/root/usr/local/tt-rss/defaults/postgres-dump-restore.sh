#!/bin/sh

if [ -n "$POSTGRES_DB" ] && [ -n "$POSTGRES_USER" ] && [ -n "$POSTGRES_PASSWORD" ]; then
    count=`ps -ef |grep /usr/local/bin/initialize.sh |grep -v "grep" |wc -l`
    while [ 0 -ne $count ]; do
    sleep 3
    count=`ps -ef |grep /usr/local/bin/initialize.sh |grep -v "grep" |wc -l`
    done
    if [ "$POSTGRES_DB_DUMP" == "true" ] && [ "$POSTGRES_DB_RESTORE" != "true" ]; then
      if [ ! -e "/config/db.sql" ]; then
         while ! pg_isready -h localhost -U $POSTGRES_USER; do
	         sleep 3
         done
         pg_dump -U $POSTGRES_USER -f /config/db.sql -d $POSTGRES_DB
         echo 已备份到/config/db.sql...
      else
         echo 存在旧的备份文件，需删除...
      fi
    elif [ "$POSTGRES_DB_RESTORE" == "true" ] && [ "$POSTGRES_DB_DUMP" != "true" ]; then
      if [ -e "/config/db.sql" ]; then
        while ! pg_isready -h localhost -U $POSTGRES_USER; do
          sleep 3
        done
        if [ -e "/var/lib/postgresql/data" ]; then
          rm -rf /var/lib/postgresql/data/*
        fi
        ps -ef |grep postgres: |grep -v grep|awk '{print $1}'|xargs kill -9
        while ! pg_isready -h localhost -U $POSTGRES_USER; do
          sleep 3
        done
        psql -d $POSTGRES_DB -f /config/db.sql -U $POSTGRES_USER
        chown -R postgres:postgres /var/lib/postgresql/data
        chown -R postgres:postgres /var/run/postgresql/
        /usr/local/bin/initialize.sh &
        mv /config/db.sql /config/db.sql.$(date +%Y-%m-%d).restore
        echo 已还原/config/db.sql并重命名为.restore文件...
      else
        echo 无备份文件...
      fi
    elif [ "$POSTGRES_DB_DUMP" == "true" ] && [ "$POSTGRES_DB_RESTORE" == "true" ]; then
        echo 请勿同时使用数据库备份和还原...
    else
        echo 未设置数据库备份或者还原...
    fi
else
       echo 环境变量POSTGRES_[DB、USER、PASSWORD]未填写完全...
fi
