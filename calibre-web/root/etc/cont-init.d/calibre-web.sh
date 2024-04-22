#! /usr/bin/with-contenv bash

#检查metadata.db文件，并创建.
if [ ! -f /library/metadata.db ]; then
  if [ ! -d /library/.calnotes ]; then
    mkdir -p /library/.calnotes
  fi
  calibredb restore_database --really-do-it --with-library /library
fi

#检查calibre-web配置文件，并创建.
if [ ! -d $CALIBRE_DBPATH ]; then
  mkdir -p $CALIBRE_DBPATH
fi
if [ ! -f $CALIBRE_DBPATH/app.db ]; then
  python3 /usr/local/calibre-web/app/cps.py -d
  CALIBRE_WEB_ALL_LANGUAGE=("en" "cs" "de" "el" "es" "fi" "fr" "hu" "it" "ja" "km" "ko" "nl" "pl" "pt_BR" "ru" "sv" "tr" "uk" "zh_Hans_CN" "zh_Hant_TW")
  if [[ ${CALIBRE_WEB_ALL_LANGUAGE[@]} =~ "$CALIBRE_WEB_LANGUAGE" ]]; then
    CALIBRE_WEB_LANGUAGE_SET=$CALIBRE_WEB_LANGUAGE
  else
    CALIBRE_WEB_LANGUAGE_SET=zh_Hans_CN
  fi
  sqlite3 $CALIBRE_DBPATH/app.db  "UPDATE settings SET config_kepubifypath='/usr/local/bin/kepubify',\
          config_converterpath='/opt/calibre/ebook-convert',config_rarfile_location='/usr/bin/unrar',\
          config_calibre_dir='/library',config_default_locale='$CALIBRE_WEB_LANGUAGE_SET' WHERE ID = 1;"
  sqlite3 $CALIBRE_DBPATH/app.db  "UPDATE user SET locale='$CALIBRE_WEB_LANGUAGE_SET' WHERE ID = 1;"
fi

#检查Google drive配置文件.
if [ ! -f $CALIBRE_DBPATH/client_secrets.json ]; then
  echo "{}" > $CALIBRE_DBPATH/client_secrets.json
fi

#检查calibre-web.log文件.
if [ -f $CALIBRE_DBPATH/calibre-web.log.1 ]; then
   rm $CALIBRE_DBPATH/calibre-web.log.*
fi

#检查搜索文件
if [ ! -d /usr/local/calibre-web/defaults ]; then
  mkdir -p /usr/local/calibre-web/defaults
fi
if [ "$DISABLE_GOOGLE_SEARCH" == "true" ]; then
  if [ -f /usr/local/calibre-web/app/cps/metadata_provider/google.py ]; then
    mv /usr/local/calibre-web/app/cps/metadata_provider/google.py /usr/local/calibre-web/defaults/
  fi
else
  if [ ! -f /usr/local/calibre-web/app/cps/metadata_provider/google.py ]; then
    mv /usr/local/calibre-web/defaults/google.py /usr/local/calibre-web/app/cps/metadata_provider/
  fi
fi
if [ "$DISABLE_SCHOLAR_SEARCH" == "true" ]; then
  if [ -f /usr/local/calibre-web/app/cps/metadata_provider/scholar.py ]; then
    mv /usr/local/calibre-web/app/cps/metadata_provider/scholar.py /usr/local/calibre-web/defaults/
  fi
else
  if [ ! -f /usr/local/calibre-web/app/cps/metadata_provider/scholar.py ]; then
    mv /usr/local/calibre-web/defaults/scholar.py /usr/local/calibre-web/app/cps/metadata_provider/
  fi
fi

#fix封面颜色偏暗
if [ "$ENABLE_FIX_COVER_COLOR" == "true" ]; then
  if [ `cat /usr/local/calibre-web/app/cps/helper.py |grep -n "srgb"|wc -l` -eq 0 ]; then
    if [ ! -f /usr/local/calibre-web/app/cps/helper.py.bak ]; then
      mv /usr/local/calibre-web/app/cps/helper.py /usr/local/calibre-web/app/cps/helper.py.bak
    fi
    cp /usr/local/calibre-web/app/cps/helper.py.bak /usr/local/calibre-web/app/cps/helper.py
    sed -i s/rgb/srgb/g /usr/local/calibre-web/app/cps/helper.py
  fi
  if [ `cat /usr/local/calibre-web/app/cps/cover.py |grep -n "srgb"|wc -l` -eq 0 ]; then
    if [ ! -f /usr/local/calibre-web/app/cps/cover.py.bak ]; then
      mv /usr/local/calibre-web/app/cps/cover.py /usr/local/calibre-web/app/cps/cover.py.bak
    fi
    cp /usr/local/calibre-web/app/cps/cover.py.bak /usr/local/calibre-web/app/cps/cover.py
    sed -i s/rgb/srgb/g /usr/local/calibre-web/app/cps/cover.py
  fi
else
  if [ `cat /usr/local/calibre-web/app/cps/helper.py |grep -n "srgb"|wc -l` -ne 0 ]; then
    if [ -f /usr/local/calibre-web/app/cps/helper.py.bak ]; then
      mv /usr/local/calibre-web/app/cps/helper.py.bak /usr/local/calibre-web/app/cps/helper.py
    fi
  fi
  if [ `cat /usr/local/calibre-web/app/cps/cover.py |grep -n "srgb"|wc -l` -ne 0 ]; then
    if [ -f /usr/local/calibre-web/app/cps/cover.py.bak ]; then
      mv /usr/local/calibre-web/app/cps/cover.py.bak /usr/local/calibre-web/app/cps/cover.py
    fi
  fi
fi

#修改用户UID GID
groupmod -o -g "$GID" calibre
usermod -o -u "$UID" calibre

#fonts
if [ ! -d /usr/share/fonts ]; then
  mkdir -p /usr/share/fonts
fi
if [ ! -d /config/fonts ]; then
  mkdir -p /config/fonts
fi
if [ ! -L /usr/share/fonts/calibrefonts ]; then
  ln -s /config/fonts /usr/share/fonts/calibrefonts
fi
fc-cache -f

#检查server-users.sqlite文件，并创建.
if [ ! -d $CALIBRE_CONFIG_DIRECTORY ]; then
  mkdir -p $CALIBRE_CONFIG_DIRECTORY
fi
if [ ! -f $CALIBRE_CONFIG_DIRECTORY/server-users.sqlite ]; then
  touch $CALIBRE_CONFIG_DIRECTORY/server-users.sqlite
fi

#检查global.py.json并设置语言为en
if [ ! -f $CALIBRE_CONFIG_DIRECTORY/global.py.json ]; then
  calibre-server --version
fi
sde language en $CALIBRE_CONFIG_DIRECTORY/global.py.json

#添加user.
if [ "$ENABLE_CALIBRE_SERVER" == "true" ] && [ -n "$CALIBRE_SERVER_USER" ] && [ -n "$CALIBRE_SERVER_PASSWORD" ]; then
  /usr/bin/expect <<-EOF
  spawn calibre-server --userdb $CALIBRE_CONFIG_DIRECTORY/server-users.sqlite --manage-users
  expect "What do you want to do"
  send "1\r"
  expect "Enter the username:"
  send "$CALIBRE_SERVER_USER\r"
  expect {
  -re "already exists" { exit }
  -re "Enter the username:" { exit }
  -re "Enter the new password for" { exp_send "$CALIBRE_SERVER_PASSWORD\r"; exp_continue}
  -re "to verify:" { exp_send "$CALIBRE_SERVER_PASSWORD\r"; exp_continue}
  -re "successfully!" { exit }
}
  expect eof
EOF
fi

#calibre-server语言.
if [ "$ENABLE_CALIBRE_SERVER" == "true" ] && [ -n "$CALIBRE_SERVER_WEB_LANGUAGE" ]; then
  CALIBRE_SERVER_WEB_ALL_LANGUAGE=("en" "af" "am" "ar" "ast" "az" "be" "bg" "bn" "bn_BD" "bn_IN" "br" "bs" "ca" "crh" "cs" "cy" "da" "de" "el" "en_AU" "en_CA" "en_GB" "eo" "es" "es_MX" "et" "eu" "fa" "fi" "fil" "fo" "fr" "fr_CA" "fur" "ga" "gl" "gu" "he" "hi" "hr" "hu" "hy" "id" "is" "it" "ja" "jv" "ka" "km" "kn" "ko" "ku" "lt" "ltg" "lv" "mi" "mk" "ml" "mn" "mr" "ms" "mt" "my" "nb" "nds" "nl" "nn" "nso" "oc" "or" "pa" "pl" "ps" "pt" "pt_BR" "ro" "ru" "rw" "sc" "si" "sk" "sl" "sq" "sr" "sr@latin" "sv" "ta" "te" "th" "ti" "tr" "tt" "ug" "uk" "ur" "uz@Latn" "ve" "vi" "wa" "xh" "yi" "zh_CN" "zh_HK" "zh_TW" "zu")
  if [[ ${CALIBRE_SERVER_WEB_ALL_LANGUAGE[@]} =~ "$CALIBRE_SERVER_WEB_LANGUAGE" ]]; then
    sde language $CALIBRE_SERVER_WEB_LANGUAGE $CALIBRE_CONFIG_DIRECTORY/global.py.json
  fi
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#更改文件夹权限
chown -R calibre:calibre /home/calibre
chown -R calibre:calibre /config/
chown -R calibre:calibre /usr/local/calibre-web/
if [ "$ENABLE_CHOWN_LIBRARY" == "true" ]; then
  chown -R calibre:calibre /library
fi
chown -R calibre:calibre /autoaddbooks

#自动添加图书.
#检查calibre-server文件
if [ -f /opt/calibre/bin/calibre-server.bak ]; then
  mv /opt/calibre/bin/calibre-server.bak /opt/calibre/bin/calibre-server
fi
#添加图书.
if [ "`ls -A /autoaddbooks`" != "" ];then
  su -p calibre -s /bin/bash -c "calibredb add -r /autoaddbooks $CALIBREDB_OTHER_OPTION --library-path=/library"
  rm -r /autoaddbooks/*
fi
