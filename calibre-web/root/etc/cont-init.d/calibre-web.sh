#! /usr/bin/with-contenv bash

#检查metadata.db文件，并创建.
if [ ! -f /library/metadata.db ]; then
  cp /usr/local/calibre-web/defaults/metadata.db /library/metadata.db
fi

#检查calibre-web配置文件，并创建.
if [ ! -d /config/calibre-web ]; then
  mkdir -p /config/calibre-web
fi
if [ ! -f /config/calibre-web/app.db ]; then
  cp /usr/local/calibre-web/defaults/app.db /config/calibre-web/app.db
fi
if [ ! -L /usr/local/calibre-web/app/app.db ]; then
  if [ -e /usr/local/calibre-web/app/app.db ]; then
    rm /usr/local/calibre-web/app/app.db
  fi
  ln -s /config/calibre-web/app.db /usr/local/calibre-web/app/app.db
fi
if [ ! -f /config/calibre-web/calibre-web.log ]; then
  touch /config/calibre-web/calibre-web.log
fi
if [ ! -L /usr/local/calibre-web/app/calibre-web.log ]; then
  if [ -e /usr/local/calibre-web/app/calibre-web.log ]; then
    rm /usr/local/calibre-web/app/calibre-web.log
  fi
  ln -s /config/calibre-web/calibre-web.log /usr/local/calibre-web/app/calibre-web.log
fi

#检查Google drive配置文件.
if [ ! -f /config/calibre-web/client_secrets.json ]; then
  echo "{}" > /config/calibre-web/client_secrets.json
fi
if [ ! -L /usr/local/calibre-web/app/client_secrets.json ]; then
  if [ -e /usr/local/calibre-web/app/client_secrets.json ]; then
  	rm /usr/local/calibre-web/app/client_secrets.json
  fi
	ln -s /config/calibre-web/client_secrets.json /usr/local/calibre-web/app/client_secrets.json
fi

if [ ! -f /config/calibre-web/gdrive.db ] && [ -f /usr/local/calibre-web/app/gdrive.db ]; then
  cp /usr/local/calibre-web/app/gdrive.db /config/calibre-web/gdrive.db
fi
if [ ! -L /usr/local/calibre-web/app/gdrive.db ] && [ -f /config/calibre-web/gdrive.db ]; then
  if [ -e /usr/local/calibre-web/app/gdrive.db ]; then
  	rm /usr/local/calibre-web/app/gdrive.db
  fi
	ln -s /config/calibre-web/gdrive.db /usr/local/calibre-web/app/gdrive.db
fi

#检查douban搜索文件
if [ -n "$DOUBANIP" ]; then
  if [ ! -f /usr/local/calibre-web/app/cps/metadata_provider/douban.py ]; then
    cp /usr/local/calibre-web/defaults/douban.py /usr/local/calibre-web/app/cps/metadata_provider/douban.py
  fi
else
  if [ -f /usr/local/calibre-web/app/cps/metadata_provider/douban.py ]; then
    rm /usr/local/calibre-web/app/cps/metadata_provider/douban.py
  fi
fi

#修改用户UID GID
groupmod -o -g "$GID" calibre
usermod -o -u "$UID" calibre

#检查calibre-server配置文件，并创建.
if [ ! -d /config/calibre-server/calibre ]; then
  mkdir -p /config/calibre-server/calibre
fi
if [ ! -f /config/calibre-server/calibre/global.py ]; then
  cp /usr/local/calibre-server/defaults/global.py /config/calibre-server/calibre/global.py
fi
if [  -f /config/calibre-server/calibre/global.pyc ]; then
  rm /config/calibre-server/calibre/global.pyc
fi
if [ ! -f /config/calibre-server/calibre/tweaks.py ]; then
  cp /usr/local/calibre-server/defaults/tweaks.py /config/calibre-server/calibre/tweaks.py
fi
if [ ! -f /config/calibre-server/calibre/server-users.sqlite ]; then
  touch /config/calibre-server/calibre/server-users.sqlite
fi
if [ ! -d /home/calibre/.config ]; then
  mkdir -p /home/calibre/.config
fi
if [ ! -L /home/calibre/.config/calibre ]; then
  if [ -d /home/calibre/.config/calibre ]; then
    rm -rf /home/calibre/.config/calibre
  fi
  ln -s /config/calibre-server/calibre /home/calibre/.config/calibre
fi

#fonts
if [ ! -d /usr/share/fonts ]; then
  mkdir -p /usr/share/fonts
fi
if [ ! -d /config/calibre-server/calibrefonts ]; then
  mkdir -p /config/calibre-server/calibrefonts
fi
if [ ! -L /usr/share/fonts/calibrefonts ]; then
  ln -s /config/calibre-server/calibrefonts /usr/share/fonts/calibrefonts
fi
fc-cache -f

#添加user.
if [ "$ENABLE_CALIBRE_SERVER" == "true" ] && [ -n "$CALIBRE_SERVER_USER" ] && [ -n "$CALIBRE_SERVER_PASSWORD" ]; then
  mv /home/calibre/.config/calibre/global.py /home/calibre/.config/calibre/global.py.bak
  if [ -f /home/calibre/.config/calibre/global.pyc ]; then
    rm /home/calibre/.config/calibre/global.pyc
  fi
  if [ -f /home/calibre/.config/calibre/global.py.json ]; then
    mv /home/calibre/.config/calibre/global.py.json /home/calibre/.config/calibre/global.py.json.bak
  fi
  cp /usr/local/calibre-server/defaults/global.py /home/calibre/.config/calibre/global.py
  expect /usr/local/calibre-server/useradd.sh $CALIBRE_SERVER_USER $CALIBRE_SERVER_PASSWORD
  mv /home/calibre/.config/calibre/global.py.bak /home/calibre/.config/calibre/global.py
  if [ -f /home/calibre/.config/calibre/global.py.json.bak ]; then
    mv /home/calibre/.config/calibre/global.py.json.bak /home/calibre/.config/calibre/global.py.json
  fi
  if [ -f /home/calibre/.config/calibre/global.pyc ]; then
    rm /home/calibre/.config/calibre/global.pyc
  fi
fi

#calibre-server语言.
if [ "$ENABLE_CALIBRE_SERVER" == "true" ] && [ -n "$CALIBRE_SERVER_WEB_LANGUAGE" ]; then
  /usr/local/calibre-server/languagechange.sh
fi

#修复calibre-server web语言设置.
if [ "$ENABLE_CALIBRE_SERVER" == "true" ] && [ -f /home/calibre/.config/calibre/global.py.json ]; then
  if [ "$(echo `grep "language =" /config/calibre-server/calibre/global.py` | cut -d "'" -f 2)" != "$(echo `grep "language" /config/calibre-server/calibre/global.py.json` | cut -d "\"" -f 4)" ]; then
     rm -f /home/calibre/.config/calibre/global.py.json
  fi
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
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
if [ -f /opt/calibre/bin/calibre-server.bak ]; then
  mv /opt/calibre/bin/calibre-server.bak /opt/calibre/bin/calibre-server
fi
#添加图书.
if [ "`ls -A /autoaddbooks`" != "" ];then
  su -p calibre -s /bin/bash -c "calibredb add -r /autoaddbooks $CALIBREDB_OTHER_OPTION --library-path=/library"
  rm -r /autoaddbooks/*
fi
