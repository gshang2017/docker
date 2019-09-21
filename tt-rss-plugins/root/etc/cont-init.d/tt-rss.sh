#! /usr/bin/with-contenv bash

#检查自定义config位置文件
if [ ! -e "/config/config.php" ] ;  then 
if [  -L "/usr/local/tt-rss/config.php" ] ;  then 
rm  /usr/local/tt-rss/config.php
fi
if [  -e "/usr/local/tt-rss/config.php" ] ;  then 
mv  /usr/local/tt-rss/config.php  /config/config.php
ln -s /config/config.php /usr/local/tt-rss/
fi
fi
if  [  -e "/config/config.php" ] ;  then 
if [ -e "/usr/local/tt-rss/config.php" ] && [ ! -L "/usr/local/tt-rss/config.php" ] ;  then 
mv  /config/config.php /config/config.php.bak
mv  /usr/local/tt-rss/config.php  /config/config.php
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

#检查plugins.local文件夹位置
if [  ! -d "/config/plugins.local" ] ;  then 
cp -rf /usr/local/tt-rss/defaults/plugins.local  /config/
ln -s /config/plugins.local  /usr/local/tt-rss/
fi
if [  ! -L "/usr/local/tt-rss/plugins.local" ] ;  then 
ln -s /config/plugins.local  /usr/local/tt-rss/
fi
#检查api_feedreader plugins
if [  ! -d "/config/plugins.local/api_feedreader" ] ;  then 
cp -rf /usr/local/tt-rss/defaults/plugins.local/api_feedreader  /config/plugins.local/
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
rm /var/log/php7/error.log
ln -s /config/php/log/error.log  /var/log/php7/error.log

#更改用户
#PUID=${PUID:-1001}
#PGID=${PGID:-1001}
#groupmod -o -g "$PGID" ttrss
#usermod -o -u "$PUID" ttrss

#更改文件夹权限
chmod -R 777 /config/
chmod -R 777 /usr/local/tt-rss/
chmod -R 777 /var/log/
chown -R postgres:postgres /var/lib/postgresql/data
