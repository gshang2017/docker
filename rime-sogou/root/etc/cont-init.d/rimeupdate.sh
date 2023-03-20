#! /usr/bin/with-contenv bash

#设定sogou_scel_update更新任务
if [ "$SOGOU_SCEL_UPDATE_AUTO" == "true" ]; then
  if [ `grep  -c sogou_scel_update.py /var/spool/cron/crontabs/root` -eq 0 ]; then
    echo "0       */8       *       *       *       python3 /usr/local/rime_update/sogou_scel_update.py" >> /var/spool/cron/crontabs/root
    echo sogou_scel_update更新任务已设定。
  else
    echo sogou_scel_update更新任务已存在。
  fi
else
  if [ `grep  -c sogou_scel_update.py /var/spool/cron/crontabs/root` -gt 0 ]; then
    sed -i '/sogou_scel_update/d' /var/spool/cron/crontabs/root
    echo sogou_scel_update更新任务已删除。
  fi
fi

#设定rime_dict_update更新任务
if [ "$RIME_DICT_UPDATE_AUTO" == "true" ]; then
  if [ `grep  -c rime_dict_update.py /var/spool/cron/crontabs/root` -eq 0 ]; then
    echo "0       0      *       *       *       python3 /usr/local/rime_update/rime_dict_update.py" >> /var/spool/cron/crontabs/root
    echo rime_dict_update更新任务已设定。
  else
    echo rime_dict_update更新任务已存在。
  fi
else
  if [ `grep  -c rime_dict_update.py /var/spool/cron/crontabs/root` -gt 0 ]; then
    sed -i '/rime_dict_update/d' /var/spool/cron/crontabs/root
    echo rime_dict_update更新任务已删除。
  fi
fi

#设定新值后删除scel文件
if [ -n "$SOGOU_DICT_NAME" ] && [ ! -e /usr/local/sogouscelupdate/$SOGOU_DICT_NAME.dict.yaml ] && [ -d "/usr/local/sogouscelupdate" ]; then
  if [ -n "`find /usr/local/sogouscelupdate -maxdepth 1 -name '*.scel'`" ]; then
    cd /usr/local/sogouscelupdate
    rm *.scel
  fi
fi

#启动时更新sogou_scel_update。
if [ "$SOGOU_SCEL_UPDATE_AUTO" == "true" ]; then
  python3 /usr/local/rime_update/sogou_scel_update.py
fi

#启动时更新rime_dict_update。
if [ "$RIME_DICT_UPDATE_AUTO" == "true" ]; then
  python3 /usr/local/rime_update/rime_dict_update.py
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
