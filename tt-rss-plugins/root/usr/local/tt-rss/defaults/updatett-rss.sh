#! /bin/sh

if [ "$TTRSS_UPDATE_AUTO" == "true" ]; then
  # tt-rss
  cd /usr/local/tt-rss/app
  git checkout -- /usr/local/tt-rss/app/classes/urlhelper.php
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  if [ -n "$TTRSS_ALLOW_PORTS" ] && [ "$TTRSS_ALLOW_PORTS" != "80,443" ]; then
    sed -i "s/\[80, 443, ''\]/\[80, 443, $TTRSS_ALLOW_PORTS, ''\]/" /usr/local/tt-rss/app/classes/urlhelper.php
    sed -i "/if (isset(\$parts\['path'\]))/i\ \t \tif (isset(\$parts['port'])) \$tmp .= ':' . \$parts['port'];" /usr/local/tt-rss/app/classes/urlhelper.php
  fi
  # update plugin mercury_fulltext
  cd /usr/local/tt-rss/app/plugins.local/mercury_fulltext
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  # update plugin feediron
  cd /usr/local/tt-rss/app/plugins.local/feediron
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
  # update plugin fever
  cd /usr/local/tt-rss/app/plugins.local/fever
  git pull --shallow-since=$(echo "`git show --pretty=format:"%ct" | head -1`-86400" | date -d @`bc` "+%Y-%m-%d")
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
fi
