FROM jlesage/baseimage-gui:debian-10 

ENV APP_NAME="Baidunetdisk"
ENV DISPLAY_WIDTH="1000"
ENV DISPLAY_HEIGHT="700"

COPY root /
COPY startapp.sh /startapp.sh

RUN apt-get update  \
&&  apt-get install -y wget libnss3 libxss1 desktop-file-utils libasound2 ttf-wqy-zenhei libgtk-3-0 libgbm1 libnotify4 xdg-utils libsecret-common libsecret-1-0 libindicator3-7 libdbusmenu-glib4 libdbusmenu-gtk3-4 libappindicator3-1   \
&&  wget http://issuecdn.baidupcs.com/issue/netdisk/LinuxGuanjia/3.4.1/baidunetdisk_3.4.1_amd64.deb  \
&&  dpkg -i  baidunetdisk_3.4.1_amd64.deb  \
&&  rm  baidunetdisk_3.4.1_amd64.deb   \ 
# XDAMAGE is not working well. -noxdamage
&&  sed -i 's@usr\/bin\/x11vnc  \\@usr\/bin\/x11vnc  \\\n                    -noxdamage \\@'   /etc/services.d/x11vnc/run   \ 
&&  install_app_icon.sh https://raw.githubusercontent.com/gshang2017/docker/master/baidunetdisk/icon/baidunetdisk.png
