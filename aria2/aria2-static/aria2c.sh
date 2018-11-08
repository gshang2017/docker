#! /bin/bash

if [ ! -n "$RPC_SECRET" ] ;  then 
#cp原始js
cp /usr/local/aria2/AriaNg/js/Originaljs/aria-ng* /usr/local/aria2/AriaNg/js/
#替换js字符串(修改线程等设置限制。)
sed -i 's/max:16/max:128/g' /usr/local/aria2/AriaNg/js/aria-ng* 
sed -i 's/defaultValue:"20M"/defaultValue:"4k"/g' /usr/local/aria2/AriaNg/js/aria-ng* 
#启动aria2
aria2c --conf-path=/usr/local/aria2/aria2.conf --enable-rpc --rpc-listen-all   -D
#启动 caddy
caddy --conf /etc/caddy/caddy.conf &
elif  [ $SECRETAUTO == YES ]; then
#cp原始js
cp /usr/local/aria2/AriaNg/js/Originaljs/aria-ng* /usr/local/aria2/AriaNg/js/
#替换js字符串(添加设置的token值为默认,修改线程等设置限制。)
secret=`echo -n  $RPC_SECRET|base64`
sed -i 's/secret:""/secret:"'"$secret"'"/g'    /usr/local/aria2/AriaNg/js/aria-ng*
sed -i 's/max:16/max:128/g' /usr/local/aria2/AriaNg/js/aria-ng* 
sed -i 's/defaultValue:"20M"/defaultValue:"4k"/g' /usr/local/aria2/AriaNg/js/aria-ng* 
#启动aria2
aria2c --conf-path=/usr/local/aria2/aria2.conf --enable-rpc --rpc-listen-all --rpc-secret="$RPC_SECRET" -D
#启动 caddy
caddy --conf /etc/caddy/caddy.conf &
else 
#cp原始js
cp /usr/local/aria2/AriaNg/js/Originaljs/aria-ng* /usr/local/aria2/AriaNg/js/
#替换js字符串(修改线程等设置限制。)
sed -i 's/max:16/max:128/g' /usr/local/aria2/AriaNg/js/aria-ng* 
sed -i 's/defaultValue:"20M"/defaultValue:"4k"/g' /usr/local/aria2/AriaNg/js/aria-ng* 
#启动aria2
aria2c --conf-path=/usr/local/aria2/aria2.conf --enable-rpc --rpc-listen-all --rpc-secret="$RPC_SECRET"  -D
#启动 caddy
caddy --conf /etc/caddy/caddy.conf &
fi

#设定trackers更新任务
if [ `grep  -c updatetrackers.sh /var/spool/cron/crontabs/root` -eq 0 ];then
echo "0       0       *       *       *       /usr/local/aria2/updatetrackers.sh" >> /var/spool/cron/crontabs/root
crond -L /dev/null
echo trackers更新任务已设定。
else
crond -L /dev/null
echo trackers更新任务已存在。
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime 
echo $TZ > /etc/timezone

#启动 /bin/sh
/bin/sh

