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

#支持STARTTLS邮件发送
cd /usr/local/qiandao/app
git checkout -- /usr/local/qiandao/app/config.py
git checkout -- /usr/local/qiandao/app/libs/utils.py
if [ "$ENABLE_MAIL_STARTTLS" == "true" ]; then
   if [ "$(grep -wn "mail_starttls" /usr/local/qiandao/app/config.py |awk -F: '{print $1}'|wc -l)" -eq 0 ]; then
     h1=$(grep -wn "mail_ssl" /usr/local/qiandao/app/config.py |awk -F: '{print $1}')
     sed -i "${h1} a mail_starttls = bool\(strtobool(os.getenv\('MAIL_STARTTLS','False'\)\)\)" /usr/local/qiandao/app/config.py
   fi
   if [ "$(grep -wn "starttls" /usr/local/qiandao/app/libs/utils.py |awk -F: '{print $1}'|wc -l)" -eq 0 ]; then
     h2=$(grep -wn "smtplib.SMTP_SSL(config.mail_smtp)" /usr/local/qiandao/app/libs/utils.py |awk -F: '{print $1}')
     sed -i "${h2} a \ \ \ \ \ \ \ \ if not config.mail_starttls:" /usr/local/qiandao/app/libs/utils.py
     sed -i "`expr ${h2} + 1` a \ \ \ \ \ \ \ \ \ \ s = config.mail_ssl and smtplib.SMTP_SSL\(config.mail_smtp\) or smtplib.SMTP\(config.mail_smtp\)" /usr/local/qiandao/app/libs/utils.py
     sed -i "`expr ${h2} + 2` a \ \ \ \ \ \ \ \ \ \ s.connect\(config.mail_smtp\)" /usr/local/qiandao/app/libs/utils.py
     sed -i "`expr ${h2} + 3` a \ \ \ \ \ \ \ \ else:" /usr/local/qiandao/app/libs/utils.py
     sed -i "`expr ${h2} + 4` a \ \ \ \ \ \ \ \ \ \ s = smtplib.SMTP\(config.mail_smtp\)" /usr/local/qiandao/app/libs/utils.py
     sed -i "`expr ${h2} + 5` a \ \ \ \ \ \ \ \ \ \ s.connect\(config.mail_smtp, config.mail_port\)" /usr/local/qiandao/app/libs/utils.py
     sed -i "`expr ${h2} + 6` a \ \ \ \ \ \ \ \ \ \ s.starttls\(\)" /usr/local/qiandao/app/libs/utils.py
     sed -i ${h2}d /usr/local/qiandao/app/libs/utils.py
     sed -i `expr ${h2} + 7`d /usr/local/qiandao/app/libs/utils.py
   fi
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
