FROM jlesage/baseimage-gui:debian-9 

ENV APP_NAME="Baidunetdisk"
ENV DISPLAY_WIDTH="1000"
ENV DISPLAY_HEIGHT="700"

COPY root /
COPY startapp.sh /startapp.sh

RUN apt-get update  \
&&  apt-get install -y wget libnss3	libxss1 desktop-file-utils libasound2-dev ttf-wqy-zenhei libgtk-3-0   \
&&  wget http://wppkg.baidupcs.com/issue/netdisk/LinuxGuanjia/3.0.1/baidunetdisk_linux_3.0.1.2.deb  \
&&  dpkg -i  baidunetdisk_linux_3.0.1.2.deb  \
&&  rm  baidunetdisk_linux_3.0.1.2.deb   \ 
&&  install_app_icon.sh https://raw.githubusercontent.com/gshang2017/docker/master/baidunetdisk/icon/baidunetdisk.png

