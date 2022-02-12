#! /usr/bin/with-contenv bash

#检查自定义config位置文件
if [ ! -e "/config/config.php" ]; then
  cp /usr/local/tt-rss/app/config.php-dist /config/config.php
fi
if [ ! -L "/usr/local/tt-rss/app/config.php" ]; then
  if [ -e "/usr/local/tt-rss/app/config.php" ]; then
    rm /usr/local/tt-rss/app/config.php
  fi
  ln -s /config/config.php /usr/local/tt-rss/app/
fi

#检查cache文件夹位置
if [ ! -d "/config/cache" ]; then
  cp -rf /usr/local/tt-rss/defaults/cache /config/
fi
if [ ! -L "/usr/local/tt-rss/app/cache" ]; then
  if [ -e "/usr/local/tt-rss/app/cache" ]; then
    rm -rf /usr/local/tt-rss/app/cache
  fi
  ln -s /config/cache /usr/local/tt-rss/app/
fi

#检查feed-icons文件夹位置
if [ ! -d "/config/feed-icons" ]; then
  cp -rf /usr/local/tt-rss/defaults/feed-icons /config/
fi
if [ ! -L "/usr/local/tt-rss/app/feed-icons" ]; then
  if [ -e "/usr/local/tt-rss/app/feed-icons" ]; then
    rm -rf /usr/local/tt-rss/app/feed-icons
  fi
  ln -s /config/feed-icons /usr/local/tt-rss/app/
fi

#检查lock文件夹位置
if [ ! -d "/config/lock" ]; then
  cp -rf /usr/local/tt-rss/defaults/lock /config/
fi
if [ ! -L "/usr/local/tt-rss/app/lock" ]; then
  if [ -e "/usr/local/tt-rss/app/lock" ]; then
    rm -rf /usr/local/tt-rss/app/lock
  fi
  ln -s /config/lock /usr/local/tt-rss/app/
fi

#检查update_daemon.stamp文件
if [ ! -e "/config/lock/update_daemon.stamp" ]; then
  touch /config/lock/update_daemon.stamp
fi

#检查plugins.local文件夹位置
if [ ! -d "/config/plugins.local" ]; then
  cp -rf /usr/local/tt-rss/defaults/plugins.local /config/
fi
if [ ! -L "/usr/local/tt-rss/app/plugins.local" ]; then
  if [ -e "/usr/local/tt-rss/app/plugins.local" ]; then
    rm -rf /usr/local/tt-rss/app/plugins.local
  fi
  ln -s /config/plugins.local /usr/local/tt-rss/app/
fi
#检查feediron plugins
if [ ! -d "/config/plugins.local/feediron" ]; then
  cp -rf /usr/local/tt-rss/defaults/plugins.local/feediron /config/plugins.local/
fi
#检查fever plugins
if [ ! -d "/config/plugins.local/fever" ]; then
  cp -rf /usr/local/tt-rss/defaults/plugins.local/fever /config/plugins.local/
fi
#检查mercury_fulltext plugins
if [ ! -d "/config/plugins.local/mercury_fulltext" ]; then
  cp -rf /usr/local/tt-rss/defaults/plugins.local/mercury_fulltext /config/plugins.local/
fi

#检查templates.local文件夹位置
if [ ! -d "/config/templates.local" ]; then
  cp -rf /usr/local/tt-rss/defaults/templates.local /config/
fi
if [ ! -L "/usr/local/tt-rss/app/templates.local" ]; then
  if [ -e "/usr/local/tt-rss/app/templates.local" ]; then
    rm -rf /usr/local/tt-rss/app/templates.local
  fi
  ln -s /config/templates.local /usr/local/tt-rss/app/
fi

#检查themes.local文件夹位置
if [ ! -d "/config/themes.local" ]; then
  mkdir -p /config/themes.local
fi
if [ ! -L "/usr/local/tt-rss/app/themes.local" ]; then
  if [ -e "/usr/local/tt-rss/app/themes.local" ]; then
    rm -rf /usr/local/tt-rss/app/themes.local
  fi
  ln -s /config/themes.local /usr/local/tt-rss/app/
fi
#检查feedly themes
if [ ! -d "/config/themes.local/feedly" ]; then
  cp -rf /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly* /config/themes.local/
fi

#检查php log文件位置
if [ ! -d "/config/php/log/" ]; then
  mkdir -p /config/php/log/
fi
if [ ! -e "/config/php/log/error.log" ]; then
  touch /config/php/log/error.log
fi
if [ ! -L "/var/log/php8/error.log" ]; then
  if [ -e "/var/log/php8/error.log" ]; then
    rm /var/log/php8/error.log
  fi
  ln -s /config/php/log/error.log /var/log/php8/error.log
fi

#检查/var/run/postgresql目录
if [ ! -d /var/run/postgresql/ ]; then
  mkdir -p /var/run/postgresql/
fi

#设定tt-rss更新任务
if [ `grep -c updatett-rss.sh /var/spool/cron/crontabs/root` -eq 0 ]; then
  echo "0       0       *       *       *       /usr/local/tt-rss/defaults/updatett-rss.sh" >> /var/spool/cron/crontabs/root
  echo tt-rss更新任务已设定。
else
  echo tt-rss更新任务已存在。
fi

#添加其它订阅端口。
cd /usr/local/tt-rss/app
git checkout -- /usr/local/tt-rss/app/classes/urlhelper.php
if [ "$TTRSS_UPDATE_AUTO" != "true" ] && [ -n "$TTRSS_ALLOW_PORTS" ] && [ "$TTRSS_ALLOW_PORTS" != "80,443" ]; then
    sed -i "s/\[80, 443, ''\]/\[80, 443, $TTRSS_ALLOW_PORTS, ''\]/" /usr/local/tt-rss/app/classes/urlhelper.php
    sed -i "/if (isset(\$parts\['path'\]))/i\ \t \tif (isset(\$parts['port'])) \$tmp .= ':' . \$parts['port'];" /usr/local/tt-rss/app/classes/urlhelper.php
fi

#启动更新ttrss。
if [ "$TTRSS_UPDATE_AUTO" == "true" ]; then
  /usr/local/tt-rss/defaults/updatett-rss.sh
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
if [ $GID -ne 0 ] && [ $UID -ne 0 ]; then
  groupmod -o -g "$GID" ttrss
  usermod -o -u "$UID" ttrss
  groupmod -o -g "$GID" postgres
  usermod -o -u "$UID" postgres
else
  echo 请设定UID与GID为非0数值...
fi
if [ -n "$POSTGRES_GID" ] && [ -n "$POSTGRES_UID" ]; then
  if [ $POSTGRES_GID -ne 0 ] && [ $POSTGRES_UID -ne 0 ]; then
    groupmod -o -g "$POSTGRES_GID" postgres
    usermod -o -u "$POSTGRES_UID" postgres
    usermod -g ttrss ttrss
    sed -i -e 's/^\(user\|group\) = .*/\1 = ttrss/i' /etc/php8/php-fpm.d/www.conf
  else
    echo 请设定POSTGRES_UID与POSTGRES_GID为非0数值...
  fi
fi

#更改文件夹权限
chown -R ttrss:ttrss /config/
chown -R ttrss:ttrss /usr/local/tt-rss/
chown -R ttrss:ttrss /var/log/php8/
chown -R postgres:postgres /var/lib/postgresql/data
chown -R postgres:postgres /var/run/postgresql/

#初始化ttrss_schema_pgsql.sql
/usr/local/bin/initialize.sh &

#备份还原postgres数据库
if [ "$POSTGRES_DB_DUMP" == "true" ] || [ "$POSTGRES_DB_RESTORE" == "true" ]; then
  /usr/local/tt-rss/defaults/postgres-dump-restore.sh &
fi
