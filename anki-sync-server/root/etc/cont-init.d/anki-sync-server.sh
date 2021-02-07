#! /usr/bin/with-contenv bash

#检查配置文件位置
if [ ! -f /config/ankisyncd.conf ] ;  then
  cp /usr/local/anki-sync-server/defaults/ankisyncd.conf /config
fi
if [  -f /usr/local/anki-sync-server/ankisyncd.conf ] ;  then
  rm  /usr/local/anki-sync-server/ankisyncd.conf
fi
if [ ! -L /usr/local/anki-sync-server/ankisyncd.conf ] ;  then
  ln -s /config/ankisyncd.conf  /usr/local/anki-sync-server/ankisyncd.conf
fi


#添加user.
if [  -n "$USER" ] && [ -n "$PASSWORD" ] ;  then
  if [ ! -d  /config/collections/$USER ] ;  then
    expect  /usr/local/anki-sync-server/useradd.sh  $USER $PASSWORD
  fi
fi
