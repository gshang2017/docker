#! /usr/bin/with-contenv bash

#检查自定义config位置文件

if [ ! -e "/config/aria2.conf" ] ;  then
cp /usr/local/aria2/defaults/aria2.conf  /config/aria2.conf
fi

if [ ! -e "/config/aria2.session" ] ;  then
touch /config/aria2.session
fi

if [ ! -e "/config/dht.dat" ] ;  then
touch /config/dht.dat
fi



#修改AriaNg
#cp原始js
cp /usr/local/aria2/AriaNg/js/Originaljs/aria-ng* /usr/local/aria2/AriaNg/js/
#替换js字符串(修改线程等设置限制。)
sed -i 's/max:16/max:128/g' /usr/local/aria2/AriaNg/js/aria-ng*
sed -i 's/defaultValue:"20M"/defaultValue:"4k"/g' /usr/local/aria2/AriaNg/js/aria-ng*
if  [ "$SECRETAUTO" == "YES" ]; then
#替换js字符串(添加设置的token值为默认。)
secret=`echo -n  $RPC_SECRET|base64`
sed -i 's/secret:""/secret:"'"$secret"'"/g'    /usr/local/aria2/AriaNg/js/aria-ng*
fi

#设定trackers更新任务
if [ `grep  -c updatetrackers.sh /var/spool/cron/crontabs/root` -eq 0 ];then
echo "0       0       *       *       *       /usr/local/aria2/updatetrackers.sh" >> /var/spool/cron/crontabs/root
echo trackers更新任务已设定。
else
echo trackers更新任务已存在。
fi

#启动更新trackers。
if [ "$TRACKERSAUTO" == "YES" ];then
/usr/local/aria2/updatetrackers.sh
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
groupmod -o -g "$GID" aria2
usermod -o -u "$UID" aria2

#修复权限
chown -R aria2:aria2 /config
chown -R aria2:aria2 /Downloads
chown -R aria2:aria2 /usr/local/aria2
