#! /usr/bin/with-contenv bash

#检查配置文件位置

if [ ! -d /config/baidupcs-web ] ;  then 
mkdir -p /config/baidupcs-web
fi
if [ ! -d /root/.config ] ;  then 
mkdir -p /root/.config
fi
if [ -d /root/.config/BaiduPCS-Go ] ;  then 
rm -rf /root/.config/BaiduPCS-Go
fi
if [ ! -L /root/.config/BaiduPCS-Go ] ;  then 
ln -s /config/baidupcs-web   /root/.config/BaiduPCS-Go
fi
