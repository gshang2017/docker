#! /usr/bin/with-contenv bash

if [ "$WEB" == "YES" ];then
cp -rf /etc/darkhttpd   /etc/services.d/
chmod a+x /etc/services.d/darkhttpd/run
fi 
