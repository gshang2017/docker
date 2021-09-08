#! /usr/bin/with-contenv bash

#检查自定义config位置文件
if [ ! -e "/config/config.php" ] ;  then
  cp  /usr/local/tt-rss/config.php-dist  /config/config.php
  if [ -e "/usr/local/tt-rss/config.php" ] ;  then
    rm  /usr/local/tt-rss/config.php
  fi
  ln -s /config/config.php /usr/local/tt-rss/
fi
if  [  -e "/config/config.php" ] ;  then
  if [ -e "/usr/local/tt-rss/config.php" ] ;  then
    rm  /usr/local/tt-rss/config.php
  fi
  ln -s /config/config.php /usr/local/tt-rss/
fi

#检查cache文件夹位置
if [  ! -d "/config/cache" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/cache  /config/
  ln -s /config/cache  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/cache" ] ;  then
  ln -s /config/cache  /usr/local/tt-rss/
fi

#检查feed-icons文件夹位置
if [  ! -d "/config/feed-icons" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/feed-icons  /config/
  ln -s /config/feed-icons  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/feed-icons" ] ;  then
  ln -s /config/feed-icons  /usr/local/tt-rss/
fi

#检查lock文件夹位置
if [  ! -d "/config/lock" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/lock  /config/
  ln -s /config/lock  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/lock" ] ;  then
  ln -s /config/lock  /usr/local/tt-rss/
fi
#检查update_daemon.stamp文件
if [  ! -e "/config/lock/update_daemon.stamp" ] ;  then
  mkdir -p /config/lock/
  touch /config/lock/update_daemon.stamp
fi

#检查plugins.local文件夹位置
if [  ! -d "/config/plugins.local" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/plugins.local  /config/
  ln -s /config/plugins.local  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/plugins.local" ] ;  then
  ln -s /config/plugins.local  /usr/local/tt-rss/
fi
#检查feediron plugins
if [  ! -d "/config/plugins.local/feediron" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/plugins.local/feediron  /config/plugins.local/
fi
#检查fever plugins
if [  ! -d "/config/plugins.local/fever" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/plugins.local/fever  /config/plugins.local/
fi
#检查mercury_fulltext plugins
if [  ! -d "/config/plugins.local/mercury_fulltext" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/plugins.local/mercury_fulltext  /config/plugins.local/
fi

#检查templates.local文件夹位置
if [  ! -d "/config/templates.local" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/templates.local  /config/
  ln -s /config/templates.local  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/templates.local" ] ;  then
  ln -s /config/templates.local  /usr/local/tt-rss/
fi

#检查themes.local文件夹位置
if [  ! -d "/config/themes.local" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/themes.local  /config/
  ln -s /config/themes.local  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/themes.local" ] ;  then
  ln -s /config/themes.local  /usr/local/tt-rss/
fi
#检查feedly themes
if [  ! -d "/config/themes.local/feedly" ] ;  then
  cp -rf /usr/local/tt-rss/defaults/themes.local/feedly*  /config/themes.local/
fi


#检查php log文件位置
if [  ! -e "/config/php/log/error.log" ] ;  then
  mkdir -p /config/php/log/
  touch /config/php/log/error.log
fi
rm /var/log/php8/error.log
ln -s /config/php/log/error.log  /var/log/php8/error.log

#修改用户UID GID
if [ $GID -ne 0 ] && [ $UID -ne 0 ] ;  then
  groupmod -o -g "$GID" ttrss
  usermod -o -u "$UID" ttrss
  groupmod -o -g "$GID" postgres
  usermod -o -u "$UID" postgres
else
  echo 请设定UID与GID为非0数值...
fi

#更改文件夹权限
chown -R ttrss:ttrss /config/
chown -R ttrss:ttrss /usr/local/tt-rss/
chown -R ttrss:ttrss /var/log/php8/
chown -R postgres:postgres /var/lib/postgresql/data
if [ ! -d /var/run/postgresql/ ] ;  then
  mkdir -p /var/run/postgresql/
fi
chown -R postgres:postgres /var/run/postgresql/

#初始化ttrss_schema_pgsql.sql
/usr/local/bin/initialize.sh &
