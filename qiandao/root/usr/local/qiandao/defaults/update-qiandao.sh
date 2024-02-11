#! /bin/sh

if [ "$QIANDAO_UPDATE_AUTO" == "true" ]; then
  cd /usr/local/qiandao/app
  git checkout -- /usr/local/qiandao/app/requirements.txt
  oldver=$(git describe --abbrev=0 --tags)
  lastver=$(curl --silent https://api.github.com/repos/qd-today/qd/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -n "$lastver" ] && [ "$lastver" != "$oldver" ]; then
    git fetch origin tag $lastver --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
    git merge $lastver
  fi
  chown -R qiandao:qiandao /usr/local/qiandao
  chown -R qiandao:qiandao /config
  if [ -n "$lastver" ] && [ "$lastver" != "$oldver" ]; then
    sed -i '/redis/d' /usr/local/qiandao/app/requirements.txt
    sed -i '/ddddocr/d' /usr/local/qiandao/app/requirements.txt
    sed -i '/cryptography/d' /usr/local/qiandao/app/requirements.txt
    sed -i '/pycryptodome/d' /usr/local/qiandao/app/requirements.txt
    chown qiandao:qiandao /usr/local/qiandao/app/requirements.txt
    pip3 install --no-cache-dir --break-system-packages -r /usr/local/qiandao/app/requirements.txt
  fi
fi
