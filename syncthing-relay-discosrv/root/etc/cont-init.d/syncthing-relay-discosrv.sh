#! /usr/bin/with-contenv bash

#检查discosrvdb及certs文件夹
if [ ! -d /config/discosrvdb ] ;  then
  mkdir -p /config/discosrvdb
fi
if [ ! -d /config/certs ] ;  then
  mkdir -p /config/certs
fi
#修改用户UID GID
groupmod -o -g "$GID" stsrv
usermod -o -u "$UID" stsrv

#修复权限
chown -R stsrv:stsrv /config
