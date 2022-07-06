#! /usr/bin/with-contenv bash

#检查配置文件位置
#ankisyncd.conf
if [ ! -f /config/ankisyncd.conf ]; then
  cp /usr/local/anki-sync-server/defaults/ankisyncd.conf /config
fi
if [ ! -L /usr/local/anki-sync-server/src/ankisyncd.conf ]; then
  if [ -e /usr/local/anki-sync-server/src/ankisyncd.conf ]; then
    rm  /usr/local/anki-sync-server/src/ankisyncd.conf
  fi
  ln -s /config/ankisyncd.conf /usr/local/anki-sync-server/src/ankisyncd.conf
fi
#nginx.conf
if [ ! -f /config/nginx.conf ]; then
  cp /usr/local/anki-sync-server/defaults/nginx.conf /config
fi
if [ ! -L /etc/nginx/nginx.conf ]; then
  if [ -e /etc/nginx/nginx.conf ]; then
    rm  /etc/nginx/nginx.conf
  fi
  ln -s /config/nginx.conf /etc/nginx/nginx.conf
fi

#修改ankisyncd.conf
if [ "$ENABLE_NGINX_PROXY_SERVER" == "true"  ]; then
  sed -i 's/^port =.*/port = 27702/g' /config/ankisyncd.conf
else
  sed -i 's/^port =.*/port = 27701/g' /config/ankisyncd.conf
fi

#更新数据库
python3 /usr/local/anki-sync-server/src/ankisyncd_cli/migrate_user_tables.py

#添加user.
if [ -n "$ANKI_SYNC_SERVER_USER" ] && [ -n "$ANKI_SYNC_SERVER_PASSWORD" ]; then
  if [ ! -f /config/auth.db ]; then
    /usr/bin/expect <<-EOF
    spawn python3 /usr/local/anki-sync-server/src/ankisyncd_cli/ankisyncctl.py adduser $ANKI_SYNC_SERVER_USER
    expect "Enter password for $ANKI_SYNC_SERVER_USER:" {send "$ANKI_SYNC_SERVER_PASSWORD\r"}
    expect eof
EOF
  else
    if [ ! -d /config/collections/$ANKI_SYNC_SERVER_USER ]; then
      mkdir -p /config/collections/$ANKI_SYNC_SERVER_USER
    fi
  fi
fi

#修改用户UID GID
groupmod -o -g "$GID" ankisync
usermod -o -u "$UID" ankisync

#修复权限
chown -R ankisync:ankisync /config
chown -R ankisync:ankisync /usr/local/anki-sync-server/
