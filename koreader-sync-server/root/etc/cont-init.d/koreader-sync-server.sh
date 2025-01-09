#! /usr/bin/with-contenv bash

#修改用户UID GID
groupmod -o -g "$GID" koreader
usermod -o -u "$UID" koreader

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#检查自定义config位置文件
if [ ! -d "/config" ]; then
  mkdir -p /config
fi
if [ ! -d "/app/koreader-sync-server/config" ]; then
  mkdir -p /app/koreader-sync-server/config
fi
for file in `ls /app/koreader-sync-server/config.default`
do
  if [ ! -e /config/$file ]; then
    cp /app/koreader-sync-server/config.default/$file /config/$file
  fi
  if [ ! -L /app/koreader-sync-server/config/$file ]; then
    ln -s /config/$file /app/koreader-sync-server/config/$file
  fi
done

#更改文件夹权限
chown -R koreader:koreader /app /config /var /etc/nginx/ssl/
