#! /usr/bin/with-contenv bash

#修改用户UID GID
groupmod -o -g "$GID" koreader
usermod -o -u "$UID" koreader

#检查log-clipper.txt文件(inotify需要)
if [ ! -e "/config/.config/joplin/log-clipper.txt" ]; then
  mkdir -p $HOME/.config/joplin/
  touch $HOME/.config/joplin/log-clipper.txt
  chown -R koreader:koreader $HOME
fi

#配置joplin同步服务器
if [ -n "$JOPLIN_SYNC_PATH" ] && [ -n "$JOPLIN_SYNC_USERNAME" ] && [ -n "$JOPLIN_SYNC_PASSWORD" ] ; then
  su -p koreader -s /bin/bash -c "joplin config sync.target 9"
  su -p koreader -s /bin/bash -c "joplin config sync.9.path $JOPLIN_SYNC_PATH"
  su -p koreader -s /bin/bash -c "joplin config sync.9.username $JOPLIN_SYNC_USERNAME"
  su -p koreader -s /bin/bash -c "joplin config sync.9.password $JOPLIN_SYNC_PASSWORD"
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#更改文件夹权限
chown -R koreader:koreader $HOME
chown -R koreader:koreader /usr/local/joplin/

#提取token到token.txt
if [ -e "/config/.config/joplin/settings.json" ]; then
  cat /config/.config/joplin/settings.json |jq -r '."api.token"' > /config/token.txt
fi
