#! /usr/bin/with-contenv bash

#检查配置文件，并创建.

if [ ! -f /library/metadata.db ] ;  then 
cp /usr/local/calibre-web/defaults/metadata.db   /library/metadata.db
fi

if [ ! -f /config/app.db ] ;  then 
cp /usr/local/calibre-web/defaults/app.db   /config/app.db
fi
if [ -f /usr/local/calibre-web/app.db ] ;  then 
rm /usr/local/calibre-web/app.db
fi
if [ ! -L /usr/local/calibre-web/app.db ] ;  then 
ln -s /config/app.db  /usr/local/calibre-web/app.db
fi


if [ ! -f /config/calibre-web.log ] ;  then 
touch  /config/calibre-web.log
fi
if [ -f /usr/local/calibre-web/calibre-web.log ] ;  then 
rm /usr/local/calibre-web/calibre-web.log
fi
if [ ! -L /usr/local/calibre-web/calibre-web.log ] ;  then 
ln -s /config/calibre-web.log  /usr/local/calibre-web/calibre-web.log
fi
