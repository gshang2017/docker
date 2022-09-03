FROM jlesage/baseimage-gui:debian-10-v4.0.0-pre.6

ARG BAIDUNETDISK_VER=4.12.5

ENV APP_NAME="Baidunetdisk"
ENV NOVNC_LANGUAGE="zh_Hans"

COPY --chmod=755 root /
COPY --chmod=755 startapp.sh /startapp.sh

RUN apt-get update \
&& apt-get install -y wget libnss3 libxss1 desktop-file-utils libasound2 ttf-wqy-zenhei libgtk-3-0 libgbm1 libnotify4 \
                      xdg-utils libsecret-common libsecret-1-0 libindicator3-7 libdbusmenu-glib4 libdbusmenu-gtk3-4 libappindicator3-1 procps \
&& wget https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/${BAIDUNETDISK_VER}/baidunetdisk_${BAIDUNETDISK_VER}_amd64.deb \
&& dpkg -i  baidunetdisk_${BAIDUNETDISK_VER}_amd64.deb \
&& rm  baidunetdisk_${BAIDUNETDISK_VER}_amd64.deb \
&& install_app_icon.sh https://raw.githubusercontent.com/gshang2017/docker/master/baidunetdisk/icon/baidunetdisk.png \
#fix window decorations
&& sed -i 's/normal/desktop/g' /etc/jwm/main-window-group.sh \
#fix vncpasswd not found
&& ln -s /usr/tigervnc/bin/vncpasswd /opt/tigervnc/bin/vncpasswd \
#novnc_language
&& mv /opt/noVNC/index.html /opt/noVNC/index.html.en \
#fix dpkg
&& sed -i '/messagebus/d' /var/lib/dpkg/statoverride
