#! /usr/bin/with-contenv bash

#检查配置文件位置
#ankisyncd.conf
if [ ! -f /config/ankisyncd.conf ] ;  then
  cp /usr/local/anki-sync-server/defaults/ankisyncd.conf /config
fi
if [  -f /usr/local/anki-sync-server/src/ankisyncd.conf ] ;  then
  rm  /usr/local/anki-sync-server/src/ankisyncd.conf
fi
if [ ! -L /usr/local/anki-sync-server/src/ankisyncd.conf ] ;  then
  ln -s /config/ankisyncd.conf  /usr/local/anki-sync-server/src/ankisyncd.conf
fi

#nginx.conf
if [ ! -f /config/nginx.conf ] ;  then
  cp /usr/local/anki-sync-server/defaults/nginx.conf /config
fi
if [  -f /etc/nginx/nginx.conf ] ;  then
  rm  /etc/nginx/nginx.conf
fi
if [ ! -L /etc/nginx/nginx.conf ] ;  then
  ln -s /config/nginx.conf  /etc/nginx/nginx.conf
fi

#添加user.
if [  -n "$USER" ] && [ -n "$PASSWORD" ] ;  then
  if [ ! -d  /config/collections/$USER ] ;  then
    expect  /usr/local/anki-sync-server/useradd.sh  $USER $PASSWORD
  fi
fi
