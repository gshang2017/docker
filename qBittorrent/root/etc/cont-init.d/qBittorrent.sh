#! /usr/bin/with-contenv bash

#检查config配置文件，并创建.
if [ ! -d /config/qBittorrent/config ]; then
  mkdir -p /config/qBittorrent/config
fi
if [ ! -e /config/qBittorrent/config/qBittorrent.conf ]; then
  cp /usr/local/qbittorrent/defaults/qBittorrent.conf /config/qBittorrent/config/qBittorrent.conf
fi

#检查Search文件，并创建.
if [ ! -d /config/qBittorrent/data/nova3/engines ]; then
  mkdir -p /config/qBittorrent/data/nova3/engines
fi
cp -ru /usr/local/qbittorrent/defaults/Search/* /config/qBittorrent/data/nova3/engines

#设定trackers更新任务
if [ `grep  -c updatetrackers.sh /var/spool/cron/crontabs/root` -eq 0 ]; then
  echo "0       0       *       *       *       /usr/local/qbittorrent/updatetrackers.sh" >> /var/spool/cron/crontabs/root
  echo trackers更新任务已设定。
else
  echo trackers更新任务已存在。
fi

#启动时更新trackers。
if [ "$QB_TRACKERS_UPDATE_AUTO" == "true" ]; then
  /usr/local/qbittorrent/updatetrackers.sh
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
groupmod -o -g "$GID" qbittorrent
usermod -o -u "$UID" qbittorrent

#修复权限
chown -R qbittorrent:qbittorrent /config
chown -R qbittorrent:qbittorrent /Downloads
