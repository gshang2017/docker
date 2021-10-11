#! /usr/bin/with-contenv bash

#设置配置文件
if [ "$MAIL_STARTTLS" == "True" ];then
  cp /usr/local/qiandao/mailstarttls/config.py  /usr/local/qiandao/
  cp /usr/local/qiandao/mailstarttls/utils.py  /usr/local/qiandao/libs/utils.py
  sed -i 's#./database.db#/dbpath/database.db#'  /usr/local/qiandao/config.py
  sed -i 's/mail_smtp = ""/mail_smtp = "'"$MAIL_STMP"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_port = ""/mail_port = "'"$MAIL_PORT"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_ssl = ""/mail_ssl = "'"$MAIL_SSL"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_starttls = ""/mail_starttls = "'"$MAIL_STARTTLS"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_user = ""/mail_user = "'"$MAIL_USER"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_password = ""/mail_password = "'"$MAIL_PASSWORD"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_domain = ""/mail_domain = "'"$MAIL_DOMAIN"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mailgun_key = ""/mailgun_key = "'"$MAILGUN_KEY"'"/'  /usr/local/qiandao/config.py
  sed -i 's/'qiandao.today'/'$DOMAIN'/'  /usr/local/qiandao/config.py
else
  cp /usr/local/qiandao/defaults/config.py  /usr/local/qiandao/
  cp /usr/local/qiandao/defaults/utils.py  /usr/local/qiandao/libs/utils.py
  sed -i 's#./database.db#/dbpath/database.db#'  /usr/local/qiandao/config.py
  sed -i 's/mail_smtp = ""/mail_smtp = "'"$MAIL_STMP"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_ssl = True/mail_ssl = "'"$MAIL_SSL"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_port = 465/mail_port = "'"$MAIL_PORT"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_user = ""/mail_user = "'"$MAIL_USER"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_password = ""/mail_password = "'"$MAIL_PASSWORD"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mail_domain = "mail.qiandao.today"/mail_domain = "'"$MAIL_DOMAIN"'"/'  /usr/local/qiandao/config.py
  sed -i 's/mailgun_key = ""/mailgun_key = "'"$MAILGUN_KEY"'"/'  /usr/local/qiandao/config.py
  sed -i 's/'qiandao.today'/'$DOMAIN'/'  /usr/local/qiandao/config.py
fi


#设置管理员
if [  -n "$ADMINEMAIL" ];then
  /usr/local/qiandao/chrole.py $ADMINEMAIL  admin
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
groupmod -o -g "$GID" qiandao
usermod -o -u "$UID" qiandao

#修复权限
chown -R qiandao:qiandao /usr/local/qiandao
chown -R qiandao:qiandao /dbpath
