#! /bin/sh

if [ "$QIANDAO_UPDATE_AUTO" == "true" ]; then
  cd /usr/local/qiandao/app
  git checkout -- /usr/local/qiandao/app/config.py
  git checkout -- /usr/local/qiandao/app/libs/utils.py
  git checkout -- /usr/local/qiandao/app/requirements.txt
  oldver=$(git describe --abbrev=0 --tags)
  lastver=$(curl --silent https://api.github.com/repos/qd-today/qd/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -n "$lastver" ] && [ "$lastver" != "$oldver" ]; then
    git fetch origin tag $lastver --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
    git merge $lastver
  fi
  if [ "$ENABLE_MAIL_STARTTLS" == "true" ]; then
    sh_oldver=$(cat /usr/local/qiandao/defaults/mail_starttls.sh|grep "version"|cut -d "=" -f2)
    sh_lastver=$(curl --silent https://raw.githubusercontent.com/gshang2017/docker/master/qiandao/root/usr/local/qiandao/defaults/mail_starttls.sh|grep "version"|cut -d "=" -f2)
    if [ -n "$sh_lastver" ] && [ "$sh_lastver" != "$sh_oldver" ]; then
      curl  --retry 2  -o /usr/local/qiandao/defaults/mail_starttls.sh -L  https://raw.githubusercontent.com/gshang2017/docker/master/qiandao/root/usr/local/qiandao/defaults/mail_starttls.sh
      chown qiandao:qiandao /usr/local/qiandao/defaults/mail_starttls.sh
      chmod +x /usr/local/qiandao/defaults/mail_starttls.sh
    fi
    /usr/local/qiandao/defaults/mail_starttls.sh
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
