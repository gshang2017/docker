#! /usr/bin/with-contenv bash

#检查config配置文件，并创建.
if [ ! -e "$CONFIG/qBittorrent/config/qBittorrent.conf" ] ;  then 
mkdir -p $CONFIG/qBittorrent/config/
cp /usr/local/qbittorrent/defaults/qBittorrent.conf  $CONFIG/qBittorrent/config/qBittorrent.conf
fi



#设定trackers更新任务
if [ `grep  -c updatetrackers.sh /var/spool/cron/crontabs/root` -eq 0 ];then
echo "0       0       *       *       *       /usr/local/qbittorrent/updatetrackers.sh" >> /var/spool/cron/crontabs/root
echo trackers更新任务已设定。
else
echo trackers更新任务已存在。
fi

#启动时更新trackers。
if [ "$TRACKERSAUTO" == "YES" ];then
/usr/local/qbittorrent/updatetrackers.sh
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime 
echo $TZ > /etc/timezone
