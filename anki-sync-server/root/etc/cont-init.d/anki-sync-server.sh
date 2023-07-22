#! /usr/bin/with-contenv bash

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
groupmod -o -g "$GID" ankisync
usermod -o -u "$UID" ankisync

#修复权限
chown -R ankisync:ankisync /ankisyncdir
