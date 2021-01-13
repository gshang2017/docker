#! /usr/bin/with-contenv bash

#检查calibre-web配置文件，并创建.

if [ ! -f /library/metadata.db ] ;  then
  cp /usr/local/calibre-web/defaults/metadata.db   /library/metadata.db
fi

if [ ! -f /config/calibre-web/app.db ] ;  then
  mkdir -p /config/calibre-web/
  cp /usr/local/calibre-web/defaults/app.db   /config/calibre-web/app.db
fi
if [ -f /usr/local/calibre-web/app.db ] ;  then
  rm /usr/local/calibre-web/app.db
fi
if [ ! -L /usr/local/calibre-web/app.db ] ;  then
  ln -s /config/calibre-web/app.db  /usr/local/calibre-web/app.db
fi


if [ ! -f /config/calibre-web/calibre-web.log ] ;  then
  mkdir -p /config/calibre-web/
  touch  /config/calibre-web/calibre-web.log
fi
if [ -f /usr/local/calibre-web/calibre-web.log ] ;  then
  rm /usr/local/calibre-web/calibre-web.log
fi
if [ ! -L /usr/local/calibre-web/calibre-web.log ] ;  then
  ln -s /config/calibre-web/calibre-web.log  /usr/local/calibre-web/calibre-web.log
fi

#检查Google drive配置文件.

if [ ! -f /config/calibre-web/client_secrets.json ] ;  then
  mkdir -p /config/calibre-web/
  echo "{}" > /config/calibre-web/client_secrets.json
fi
if [ -f /usr/local/calibre-web/client_secrets.json ] ;  then
	rm /usr/local/calibre-web/client_secrets.json
fi
if [ ! -L /usr/local/calibre-web/client_secrets.json ] ;  then
	ln -s /config/calibre-web/client_secrets.json /usr/local/calibre-web/client_secrets.json
fi

if [ ! -f /config/calibre-web/gdrive.db ] && [ -f /usr/local/calibre-web/gdrive.db ] ;  then
	mkdir -p /config/calibre-web/
  cp /usr/local/calibre-web/gdrive.db /config/calibre-web/gdrive.db
fi
if [ -f /usr/local/calibre-web/gdrive.db ] ;  then
	rm /usr/local/calibre-web/gdrive.db
fi
if [ ! -L /usr/local/calibre-web/gdrive.db ] && [ -f /config/calibre-web/gdrive.db ];  then
	ln -s /config/calibre-web/gdrive.db /usr/local/calibre-web/gdrive.db
fi


#检查calibre-server配置文件，并创建.


if [ ! -f /config/calibre-server/root/calibre/global.py ] ;  then
  mkdir -p /config/calibre-server/root/calibre
  cp /usr/local/calibre-server/defaults/global.py  /config/calibre-server/root/calibre/global.py
fi
if [  -f /config/calibre-server/root/calibre/global.pyc ] ;  then
  rm /config/calibre-server/root/calibre/global.pyc
fi
if [ ! -f /config/calibre-server/root/calibre/tweaks.py ] ;  then
  mkdir -p /config/calibre-server/root/calibre
  cp /usr/local/calibre-server/defaults/tweaks.py  /config/calibre-server/root/calibre/tweaks.py
fi
if [ ! -f /config/calibre-server/root/calibre/server-users.sqlite ] ;  then
  mkdir -p /config/calibre-server/root/calibre
  touch /config/calibre-server/root/calibre/server-users.sqlite
fi
if [ -d /root/.config/calibre ] ;  then
  rm -rf /root/.config/calibre
fi
if [ ! -L /root/.config/calibre ] ;  then
  ln -s /config/calibre-server/root/calibre  /root/.config/calibre
fi


if [ ! -f /config/calibre-server/srv/calibre/users.sqlite ] ;  then
  mkdir -p /config/calibre-server/srv/calibre
  touch /config/calibre-server/srv/calibre/users.sqlite
fi
if [ -d /srv/calibre ] ;  then
  rm -rf /srv/calibre
fi
if [ ! -L /srv/calibre ] ;  then
  ln -s /config/calibre-server/srv/calibre  /srv/calibre
fi

#fonts
if [ ! -d /usr/share/fonts ] ;  then
  mkdir -p /usr/share/fonts
fi
if [ ! -d /config/calibre-server/calibrefonts ] ;  then
  mkdir -p /config/calibre-server/calibrefonts
fi
if [ ! -L /usr/share/fonts/calibrefonts ] ;  then
  ln -s /config/calibre-server/calibrefonts  /usr/share/fonts/calibrefonts
fi
fc-cache -f


#添加user.
if [  -n "$USER" ] && [ -n "$PASSWORD" ] ;  then
  mv /root/.config/calibre/global.py /root/.config/calibre/global.py.bak
  rm /root/.config/calibre/global.pyc
  cp /usr/local/calibre-server/defaults/global.py  /root/.config/calibre/global.py
  expect /usr/local/calibre-server/useradd.sh  $USER $PASSWORD
  mv  /root/.config/calibre/global.py.bak /root/.config/calibre/global.py
  rm /root/.config/calibre/global.pyc
fi


#自动添加图书.
#检查calibre-server文件
if [ -f /opt/calibre/bin/calibre-server.bak ] ;  then
  mv /opt/calibre/bin/calibre-server.bak /opt/calibre/bin/calibre-server
fi
#添加图书.
if [ "`ls -A /autoaddbooks`" != "" ];then
  calibredb add -r "/autoaddbooks" --library-path="/library"
  rm  -r /autoaddbooks/*
fi


#calibre-server语言.
if [  -n "$WEBLANGUAGE" ] ;  then
  /usr/local/calibre-server/languagechange.sh
fi

#修复calibre-server web语言设置.
if [  -f  /root/.config/calibre/global.py.json  ] ;  then
  rm -f  /root/.config/calibre/global.py.json
fi
