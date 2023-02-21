#!/bin/sh

if [ "$(uname -m)" = "aarch64" ];then
  /opt/baidunetdisk/baidunetdisk --disable-gpu-sandbox --no-sandbox
else
  /opt/baidunetdisk/baidunetdisk --no-sandbox
fi
