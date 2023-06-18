#! /bin/sh

version=20230601

if [ "$(grep -wn "mail_starttls" /usr/local/qiandao/app/config.py |awk -F: '{print $1}'|wc -l)" -eq 0 ]; then
  h1=$(grep -wn "mail_ssl" /usr/local/qiandao/app/config.py |awk -F: '{print $1}')
  sed -i "${h1} a mail_starttls = bool\(strtobool(os.getenv\('MAIL_STARTTLS','False'\)\)\)" /usr/local/qiandao/app/config.py
fi
if [ "$(grep -wn "starttls" /usr/local/qiandao/app/libs/utils.py |awk -F: '{print $1}'|wc -l)" -eq 0 ]; then
  h2=$(grep -wn "s = smtplib.SMTP_SSL(config.mail_smtp, config.mail_port)" /usr/local/qiandao/app/libs/utils.py |awk -F: '{print $1}')
  sed -i "${h2} a  \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ if not config.mail_starttls:" /usr/local/qiandao/app/libs/utils.py
  sed -i "`expr ${h2} + 1` a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ s = smtplib.SMTP_SSL\(config.mail_smtp, config.mail_port\)" /usr/local/qiandao/app/libs/utils.py
  sed -i "`expr ${h2} + 2` a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ else:" /usr/local/qiandao/app/libs/utils.py
  sed -i "`expr ${h2} + 3` a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ s = smtplib.SMTP\(config.mail_smtp, config.mail_port\)" /usr/local/qiandao/app/libs/utils.py
  sed -i ${h2}d /usr/local/qiandao/app/libs/utils.py
  h3=$(grep -wn "s.connect(config.mail_smtp, config.mail_port)" /usr/local/qiandao/app/libs/utils.py |awk -F: '{print $1}')
  sed -i "${h3} a \ \ \ \ \ \ \ \ \ \ \ \ if config.mail_starttls:" /usr/local/qiandao/app/libs/utils.py
  sed -i "`expr ${h3} + 1` a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ s.starttls\(\)" /usr/local/qiandao/app/libs/utils.py
fi
