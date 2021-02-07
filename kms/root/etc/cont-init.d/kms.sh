#! /usr/bin/with-contenv bash

if [ "$WEB" == "YES" ];then
  cp -rf /etc/darkhttpd   /etc/services.d/
  chmod a+x /etc/services.d/darkhttpd/run
elif [ -n "/etc/services.d/darkhttpd/run" ] ;  then
  rm -rf  /etc/services.d/darkhttpd
fi
