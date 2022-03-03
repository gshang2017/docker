#! /usr/bin/with-contenv bash

#检查config文件
if [ ! -f /config/aria2.conf ]; then
  cp /usr/local/aria2/defaults/aria2.conf /config/aria2.conf
  if [ "$ARIA2_CONF_LANGUAGE" == "zh_Hant" ]; then
    sed -i 's/\#zh_Hant//g' /config/aria2.conf
    sed -i '/\#zh_Hans\#/d' /config/aria2.conf
    sed -i '/\#en\#/d' /config/aria2.conf
  elif [ "$ARIA2_CONF_LANGUAGE" == "en" ]; then
    sed -i 's/\#en//g' /config/aria2.conf
    sed -i '/\#zh_Han/d' /config/aria2.conf
  else
    sed -i 's/\#zh_Hans//g' /config/aria2.conf
    sed -i '/\#zh_Hant\#/d' /config/aria2.conf
    sed -i '/\#en\#/d' /config/aria2.conf
  fi
fi

#检查session文件
if [ ! -f /config/aria2.session ]; then
  touch /config/aria2.session
fi

#检查dht文件
if [ ! -f /config/dht.dat ]; then
  touch /config/dht.dat
fi
if [ ! -f /config/dht6.dat ]; then
  touch /config/dht6.dat
fi

#修改secret
ARIA2_RPC_SECRET_CONF_VAL=$(grep ^rpc-secret= /config/aria2.conf | sed 's/\(.*\)=//g' | sed ":a;N;s/\n//g;ta")
if [ -n "$ARIA2_RPC_SECRET" ]; then
  if [ "$ARIA2_RPC_SECRET_CONF_VAL" != "$ARIA2_RPC_SECRET" ]; then
    if [ `grep ^rpc-secret= /config/aria2.conf | wc -l` -gt 0 ]; then
      sed -i 's/^rpc-secret='"$ARIA2_RPC_SECRET_CONF_VAL"'/rpc-secret='"$ARIA2_RPC_SECRET"'/g' /config/aria2.conf
    else
      sed -i '$arpc-secret='"$ARIA2_RPC_SECRET"'' /config/aria2.conf
    fi
  fi
else
  if [ ! -n "$ARIA2_RPC_SECRET_CONF_VAL" ] && [ `grep ^rpc-secret= /config/aria2.conf | wc -l` -gt 0 ]; then
     sed -i 's/^rpc-secret=/\#rpc-secret=/g' /config/aria2.conf
  fi
fi

#修改port
#listen-port and dht-listen-port
ARIA2_LISTEN_PORT_CONF_VAL=$(grep ^listen-port= /config/aria2.conf | sed 's/\(.*\)=//g' | sed ":a;N;s/\n//g;ta")
ARIA2_DHT_LISTEN_PORT_CONF_VAL=$(grep ^dht-listen-port= /config/aria2.conf | sed 's/\(.*\)=//g' | sed ":a;N;s/\n//g;ta")
if [ -n "$ARIA2_LISTEN_PORT" ] && ([ "$ARIA2_LISTEN_PORT_CONF_VAL" != "$ARIA2_LISTEN_PORT" ] || [ "$ARIA2_DHT_LISTEN_PORT_CONF_VAL" != "$ARIA2_LISTEN_PORT" ]); then
  if [ `grep ^listen-port= /config/aria2.conf | wc -l` -gt 0 ]; then
    sed -i 's/^listen-port='"$ARIA2_LISTEN_PORT_CONF_VAL"'/listen-port='"$ARIA2_LISTEN_PORT"'/g' /config/aria2.conf
  else
    sed -i '$alisten-port='"$ARIA2_LISTEN_PORT"'' /config/aria2.conf
  fi
  if [ `grep ^dht-listen-port= /config/aria2.conf | wc -l` -gt 0 ]; then
    sed -i 's/^dht-listen-port='"$ARIA2_DHT_LISTEN_PORT_CONF_VAL"'/dht-listen-port='"$ARIA2_LISTEN_PORT"'/g' /config/aria2.conf
  else
    sed -i '$adht-listen-port='"$ARIA2_LISTEN_PORT"'' /config/aria2.conf
  fi
fi

#rpc-listen-port
ARIA2_RPC_LISTEN_PORT_CONF_VAL=$(grep ^rpc-listen-port= /config/aria2.conf | sed 's/\(.*\)=//g' | sed ":a;N;s/\n//g;ta")
if [ -n "$ARIA2_RPC_LISTEN_PORT" ] && [ "$ARIA2_RPC_LISTEN_PORT_CONF_VAL" != "$ARIA2_RPC_LISTEN_PORT" ]; then
  if [ `grep ^rpc-listen-port= /config/aria2.conf | wc -l` -gt 0 ]; then
    sed -i 's/^rpc-listen-port='"$ARIA2_RPC_LISTEN_PORT_CONF_VAL"'/rpc-listen-port='"$ARIA2_RPC_LISTEN_PORT"'/g' /config/aria2.conf
  else
    sed -i '$arpc-listen-port='"$ARIA2_RPC_LISTEN_PORT"'' /config/aria2.conf
  fi
fi

#修改AriaNg替换js字符串(添加设置的token和rpcPort值为默认。)
cp /usr/local/aria2/AriaNg/js/defaultsjs/aria-ng* /usr/local/aria2/AriaNg/js/
if [ "$ARIANG_RPC_SECRET_AUTO" == "true" ]; then
  if [ -n "$ARIA2_RPC_SECRET" ]; then
    ARIA2_RPC_SECRET_ARIANg_VAL=`echo -n $ARIA2_RPC_SECRET|base64`
    sed -i 's/secret:""/secret:"'"$ARIA2_RPC_SECRET_ARIANg_VAL"'"/g' /usr/local/aria2/AriaNg/js/aria-ng*
  else
    ARIA2_RPC_SECRET_CONF_VAL=$(grep ^rpc-secret= /config/aria2.conf | sed 's/\(.*\)=//g' | sed ":a;N;s/\n//g;ta")
    if [ -n "$ARIA2_RPC_SECRET_CONF_VAL" ]; then
      ARIA2_RPC_SECRET_ARIANg_VAL=`echo -n $ARIA2_RPC_SECRET_CONF_VAL|base64`
      sed -i 's/secret:""/secret:"'"$ARIA2_RPC_SECRET_ARIANg_VAL"'"/g' /usr/local/aria2/AriaNg/js/aria-ng*
    fi
  fi
fi
if [ "$ARIANG_RPC_LISTEN_PORT_AUTO" == "true" ]; then
  if [ -n "$ARIA2_RPC_LISTEN_PORT" ]; then
    if [ "$ARIA2_RPC_LISTEN_PORT" != "6800" ]; then
      sed -i 's/rpcPort:"6800"/rpcPort:"'"$ARIA2_RPC_LISTEN_PORT"'"/g' /usr/local/aria2/AriaNg/js/aria-ng*
    fi
  else
    ARIA2_RPC_LISTEN_PORT_CONF_VAL=$(grep ^rpc-listen-port= /config/aria2.conf | sed 's/\(.*\)=//g' | sed ":a;N;s/\n//g;ta")
    if [ -n "$ARIA2_RPC_LISTEN_PORT_CONF_VAL" ] && [ "$ARIA2_RPC_LISTEN_PORT_CONF_VAL" != "6800" ]; then
      sed -i 's/rpcPort:"6800"/rpcPort:"'"$ARIA2_RPC_LISTEN_PORT_CONF_VAL"'"/g' /usr/local/aria2/AriaNg/js/aria-ng*
    fi
  fi
fi

#设定trackers更新任务
if [ `grep -c updatetrackers.sh /var/spool/cron/crontabs/root` -eq 0 ]; then
  echo "0       0       *       *       *       /usr/local/aria2/updatetrackers.sh" >> /var/spool/cron/crontabs/root
  echo trackers更新任务已设定。
else
  echo trackers更新任务已存在。
fi

#启动更新trackers。
if [ "$ARIA2_TRACKERS_UPDATE_AUTO" == "true" ]; then
  /usr/local/aria2/updatetrackers.sh
fi

#设置时区
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

#修改用户UID GID
groupmod -o -g "$GID" aria2
usermod -o -u "$UID" aria2

#修复权限
chown -R aria2:aria2 /config
chown -R aria2:aria2 /Downloads
chown -R aria2:aria2 /usr/local/aria2
