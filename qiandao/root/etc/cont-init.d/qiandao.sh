#! /usr/bin/with-contenv bash

#检查数据库文件夹位置
if [ ! -d "/config" ]; then
  mkdir -p /config
fi
if [ ! -L "/usr/local/qiandao/app/config" ]; then
  if [ -e "/usr/local/qiandao/app/config" ]; then
    rm -rf /usr/local/qiandao/app/config
  fi
  ln -s /config /usr/local/qiandao/app/config
fi

#设定qiandao更新任务
if [ `grep -c update-qiandao.sh /var/spool/cron/crontabs/root` -eq 0 ]; then
  echo "0       0       *       *       *       /usr/local/qiandao/defaults/update-qiandao.sh" >> /var/spool/cron/crontabs/root
  echo qiandao更新任务已设定。
else
  echo qiandao更新任务已存在。
fi

#启动更新qiandao。
if [ "$QIANDAO_UPDATE_AUTO" == "true" ]; then
  /usr/local/qiandao/defaults/update-qiandao.sh
fi

#设置管理员
if [ -n "$ADMIN_MAIL" ]; then
  timeout 300 /usr/local/qiandao/defaults/change-admin-email.sh &
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
groupmod -o -g "$GID" qiandao
usermod -o -u "$UID" qiandao

#修复权限
chown -R qiandao:qiandao /usr/local/qiandao
chown -R qiandao:qiandao /config
