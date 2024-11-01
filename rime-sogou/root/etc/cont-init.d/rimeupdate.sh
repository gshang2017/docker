#! /usr/bin/with-contenv bash

#设定sogou_pop更新任务
if [ `grep  -c sogou_pop_update.py /var/spool/cron/crontabs/root` -eq 0 ]; then
  echo "0       */8       *       *       *       python3 /usr/local/rime_update/sogou_pop_update.py" >> /var/spool/cron/crontabs/root
  echo sogou_scel_update更新任务已设定。
else
  echo sogou_scel_update更新任务已存在。
fi

#设定新值后删除scel文件
if [ -n "$SOGOU_DICT_NAME" ] && [ ! -e /usr/local/sogouscelupdate/$SOGOU_DICT_NAME.dict.yaml ] && [ -d "/usr/local/sogouscelupdate" ]; then
  if [ -n "`find /usr/local/sogouscelupdate -maxdepth 1 -name '*.scel'`" ]; then
    cd /usr/local/sogouscelupdate
    rm *.scel
  fi
fi

#启动时更新sogou_pop。
python3 /usr/local/rime_update/sogou_pop_update.py

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
