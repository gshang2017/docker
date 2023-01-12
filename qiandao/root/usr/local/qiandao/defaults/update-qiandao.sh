#! /bin/sh

if [ "$QIANDAO_UPDATE_AUTO" == "true" ]; then
  cd /usr/local/qiandao/app
  git checkout -- /usr/local/qiandao/app/config.py
  git checkout -- /usr/local/qiandao/app/libs/utils.py
  git checkout -- /usr/local/qiandao/app/requirements.txt
  oldver=$(git describe --abbrev=0 --tags)
  lastver=$(curl --silent https://api.github.com/repos/qiandao-today/qiandao/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -n "$lastver" ] && [ "$lastver" != "$oldver" ]; then
    git fetch origin tag $lastver --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
    git merge $lastver
  fi
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
  chown -R qiandao:qiandao /usr/local/qiandao
  chown -R qiandao:qiandao /config
  if [ -n "$lastver" ] && [ "$lastver" != "$oldver" ]; then
    sed -i '/redis/d' /usr/local/qiandao/app/requirements.txt
    sed -i '/ddddocr/d' /usr/local/qiandao/app/requirements.txt
    sed -i '/cryptography/d' /usr/local/qiandao/app/requirements.txt
    sed -i '/pycryptodome/d' /usr/local/qiandao/app/requirements.txt
    chown qiandao:qiandao /usr/local/qiandao/app/requirements.txt
    pip3 install --no-cache-dir -r /usr/local/qiandao/app/requirements.txt
  fi
fi
