#! /bin/sh

if [ "$TTRSS_UPDATE_AUTO" == "true" ]; then
  # tt-rss
  cd /usr/local/tt-rss/app
  git checkout -- /usr/local/tt-rss/app/classes/UrlHelper.php
  git checkout -- /usr/local/tt-rss/app/cache
  git checkout -- /usr/local/tt-rss/app/feed-icons
  git checkout -- /usr/local/tt-rss/app/lock
  git checkout -- /usr/local/tt-rss/app/plugins.local
  git checkout -- /usr/local/tt-rss/app/templates.local
  git checkout -- /usr/local/tt-rss/app/themes.local
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  if [ -n "$TTRSS_ALLOW_PORTS" ] && [ "$TTRSS_ALLOW_PORTS" != "80,443" ]; then
    sed -i "s/\[80, 443, ''\]/\[80, 443, $TTRSS_ALLOW_PORTS, ''\]/" /usr/local/tt-rss/app/classes/UrlHelper.php
    sed -i "/if (isset(\$parts\['path'\]))/i\ \t \tif (isset(\$parts['port'])) \$tmp .= ':' . \$parts['port'];" /usr/local/tt-rss/app/classes/UrlHelper.php
  fi
  rm -rf /usr/local/tt-rss/app/cache
  rm -rf /usr/local/tt-rss/app/feed-icons
  rm -rf /usr/local/tt-rss/app/lock
  rm -rf /usr/local/tt-rss/app/plugins.local
  rm -rf /usr/local/tt-rss/app/templates.local
  rm -rf /usr/local/tt-rss/app/themes.local
  ln -s /config/cache /usr/local/tt-rss/app/
  ln -s /config/feed-icons /usr/local/tt-rss/app/
  ln -s /config/lock /usr/local/tt-rss/app/
  ln -s /config/plugins.local /usr/local/tt-rss/app/
  ln -s /config/templates.local /usr/local/tt-rss/app/
  ln -s /config/themes.local /usr/local/tt-rss/app/
  # update plugin mercury_fulltext
  cd /usr/local/tt-rss/app/plugins.local/mercury_fulltext
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  # update plugin feediron
  cd /usr/local/tt-rss/app/plugins.local/feediron
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  # update plugin fever
  cd /usr/local/tt-rss/app/plugins.local/fever
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  # update plugin opencc
  cd /usr/local/tt-rss/app/plugins.local/opencc
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  # update plugin freshapi
  cd /usr/local/tt-rss/app/plugins.local/freshapi
  git checkout -- /usr/local/tt-rss/app/plugins.local/freshapi/api/greader.php
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  sed -i "s/dirname.*$/\"\/usr\/local\/tt-rss\/app\";/" /usr/local/tt-rss/app/plugins.local/freshapi/api/greader.php
  # update plugin feedly-theme
  cd /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme
  Oldversion="`git rev-parse HEAD`"
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  Newversion="`git rev-parse HEAD`"
  if [ $Oldversion != $Newversion ]; then
    cp -rf /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly* /usr/local/tt-rss/app/themes.local/
  fi
  if [ "$(md5sum /config/themes.local/feedly.css|cut -d ' ' -f1)" != "$(md5sum /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly.css|cut -d ' ' -f1)" ]; then
    if [ "$(stat -c %Y /config/themes.local/feedly.css)" -lt "$(stat -c %Y /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly.css)" ]; then
      cp -rf /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly* /usr/local/tt-rss/app/themes.local/
    fi
  fi
  chown -R ttrss:ttrss /config/
  chown -R ttrss:ttrss /usr/local/tt-rss/
  if [ "$1" != "skip" ]; then
    while ! pg_isready -h $TTRSS_DB_HOST -U $TTRSS_DB_USER; do
      sleep 3
    done
    su ttrss -s /bin/sh -m -c "php83 /usr/local/tt-rss/app/update.php --update-schema=force-yes"
  fi
fi
