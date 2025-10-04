#!/bin/sh

if [ "$(uname -m)" = "aarch64" ];then
  if [ "$ENABLE_DISABLE_GPU" = "true" ]; then
    /opt/baidunetdisk/baidunetdisk --disable-gpu-sandbox --no-sandbox --disable-gpu
  else
    /opt/baidunetdisk/baidunetdisk --disable-gpu-sandbox --no-sandbox
  fi
else
  if [ "$ENABLE_DISABLE_GPU" = "true" ]; then
    /opt/baidunetdisk/baidunetdisk --no-sandbox --disable-gpu
  else
    /opt/baidunetdisk/baidunetdisk --no-sandbox
  fi
fi
