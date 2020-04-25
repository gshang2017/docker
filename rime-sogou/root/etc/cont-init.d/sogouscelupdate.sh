#! /usr/bin/with-contenv bash

#设定sogouscelupdate更新任务
if [ `grep  -c sogouscelupdate.py /var/spool/cron/crontabs/root` -eq 0 ];then
echo "0       */8       *       *       *       python3 /usr/local/sogouscelupdate/sogouscelupdate.py" >> /var/spool/cron/crontabs/root
echo sogouscelupdate更新任务已设定。
else
echo sogouscelupdate更新任务已存在。
fi

#启动时更新sogouscel。
python3 /usr/local/sogouscelupdate/sogouscelupdate.py

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime 
echo $TZ > /etc/timezone
