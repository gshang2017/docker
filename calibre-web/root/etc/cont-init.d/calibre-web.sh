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
#检查douban搜索文件
if [ -n "$DOUBANIP" ] ;  then
  if [ ! -f /usr/local/calibre-web/cps/metadata_provider/douban.py ] ;  then
    cp /usr/local/calibre-web/defaults/douban.py  /usr/local/calibre-web/cps/metadata_provider/douban.py
  fi
else
  if [ -f /usr/local/calibre-web/cps/metadata_provider/douban.py ] ;  then
    rm /usr/local/calibre-web/cps/metadata_provider/douban.py
  fi
fi

#修改用户UID GID
groupmod -o -g "$GID" calibre
usermod -o -u "$UID" calibre

#检查calibre-server配置文件，并创建.
if [ ! -f /config/calibre-server/calibre/global.py ] ;  then
  mkdir -p /config/calibre-server/calibre
  cp /usr/local/calibre-server/defaults/global.py  /config/calibre-server/calibre/global.py
fi
if [  -f /config/calibre-server/calibre/global.pyc ] ;  then
  rm /config/calibre-server/calibre/global.pyc
fi
if [ ! -f /config/calibre-server/calibre/tweaks.py ] ;  then
  mkdir -p /config/calibre-server/calibre
  cp /usr/local/calibre-server/defaults/tweaks.py  /config/calibre-server/calibre/tweaks.py
fi
if [ ! -f /config/calibre-server/calibre/server-users.sqlite ] ;  then
  mkdir -p /config/calibre-server/calibre
  touch /config/calibre-server/calibre/server-users.sqlite
fi
if [ ! -d /home/calibre/.config ] ;  then
  mkdir -p /home/calibre/.config
fi
if [ -d /home/calibre/.config/calibre ] ;  then
  rm -rf /home/calibre/.config/calibre
fi
if [ ! -L /home/calibre/.config/calibre ] ;  then
  ln -s /config/calibre-server/calibre  /home/calibre/.config/calibre
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
  mv /home/calibre/.config/calibre/global.py /home/calibre/.config/calibre/global.py.bak
  if [  -f /home/calibre/.config/calibre/global.pyc ] ;  then
    rm /home/calibre/.config/calibre/global.pyc
  fi
  cp /usr/local/calibre-server/defaults/global.py  /home/calibre/.config/calibre/global.py
  expect /usr/local/calibre-server/useradd.sh  $USER $PASSWORD
  mv  /home/calibre/.config/calibre/global.py.bak /home/calibre/.config/calibre/global.py
  if [  -f /home/calibre/.config/calibre/global.pyc ] ;  then
    rm /home/calibre/.config/calibre/global.pyc
  fi
fi

#calibre-server语言.
if [  -n "$WEBLANGUAGE" ] ;  then
  /usr/local/calibre-server/languagechange.sh
fi

#修复calibre-server web语言设置.
if [  -f  /home/calibre/.config/calibre/global.py.json  ] ;  then
  rm -f  /home/calibre/.config/calibre/global.py.json
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
echo $TZ > /etc/timezone

#更改文件夹权限
chown -R calibre:calibre /home/calibre
chown -R calibre:calibre /config/
chown -R calibre:calibre /usr/local/calibre-web/
chown -R calibre:calibre /usr/local/calibre-server/
chown -R calibre:calibre /library
chown -R calibre:calibre /autoaddbooks

#自动添加图书.
#检查calibre-server文件
if [ -f /opt/calibre/bin/calibre-server.bak ] ;  then
  mv /opt/calibre/bin/calibre-server.bak /opt/calibre/bin/calibre-server
fi
#添加图书.
if [ "`ls -A /autoaddbooks`" != "" ];then
  su - calibre -s /bin/bash -c "calibredb add -r /autoaddbooks $CALIBREDB_OTHER_OPTION --library-path=/library"
  rm  -r /autoaddbooks/*
fi
