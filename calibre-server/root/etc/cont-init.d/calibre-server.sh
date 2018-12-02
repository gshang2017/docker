#! /usr/bin/with-contenv bash

#检查配置文件，并创建.

if [ ! -f /library/metadata.db ] ;  then 
cp /usr/local/calibre-server/defaults/metadata.db   /library/metadata.db
fi


if [ ! -f /config/root/calibre/global.py ] ;  then 
mkdir -p /config/root/calibre
cp /usr/local/calibre-server/defaults/global.py  /config/root/calibre/global.py 
fi
if [  -f /config/root/calibre/global.pyc ] ;  then 
rm /config/root/calibre/global.pyc 
fi
if [ ! -f /config/root/calibre/tweaks.py ] ;  then 
mkdir -p /config/root/calibre
cp /usr/local/calibre-server/defaults/tweaks.py  /config/root/calibre/tweaks.py 
fi
if [ ! -f /config/root/calibre/server-users.sqlite ] ;  then 
mkdir -p /config/root/calibre
touch /config/root/calibre/server-users.sqlite
fi
if [ -d /root/.config/calibre ] ;  then 
rm -rf /root/.config/calibre
fi
if [ ! -L /root/.config/calibre ] ;  then 
ln -s /config/root/calibre  /root/.config/calibre
fi


if [ ! -f /config/srv/calibre/users.sqlite ] ;  then 
mkdir -p /config/srv/calibre
touch /config/srv/calibre/users.sqlite
fi
if [ -d /srv/calibre ] ;  then 
rm -rf /srv/calibre
fi
if [ ! -L /srv/calibre ] ;  then 
ln -s /config/srv/calibre  /srv/calibre
fi



#添加user.
if [  -n "$USER" ] && [ -n "$PASSWORD" ] ;  then
mv /root/.config/calibre/global.py /root/.config/calibre/global.py.bak
rm /root/.config/calibre/global.pyc
cp /usr/local/calibre-server/defaults/global.py  /root/.config/calibre/global.py 
expect /usr/local/calibre-server/useradd.sh  $USER $PASSWORD
mv  /root/.config/calibre/global.py.bak /root/.config/calibre/global.py
rm /root/.config/calibre/global.pyc
fi


#calibre语言.
if [  -n "$WEBLANGUAGE" ] ;  then
/usr/local/calibre-server/languagechange.sh 
fi
