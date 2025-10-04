FROM jlesage/baseimage-gui:debian-12-v4.9.0

ARG BAIDUNETDISK_VER=4.17.7
ARG BAIDUNETDISK_VER_ARM64=4.17.7

ENV APP_NAME="Baidunetdisk"
ENV NOVNC_LANGUAGE="zh_Hans"
ENV TZ=Asia/Shanghai
ENV HOME=/config
ENV LC_ALL=C
ENV ENABLE_DISABLE_GPU=false

COPY --chmod=755 root /
COPY --chmod=755 startapp.sh /startapp.sh

RUN apt-get update \
&& apt-get install -y --no-install-recommends ca-certificates wget libnss3 libxss1 desktop-file-utils libasound2 ttf-wqy-zenhei libgtk-3-0 libgbm1 libnotify4 \
                      xdg-utils libsecret-common libsecret-1-0 libdbusmenu-glib4 libdbusmenu-gtk3-4 procps \
                      libayatana-indicator3-7 libayatana-appindicator3-1 libayatana-ido3-0.4-0 libxtst6 libx11-xcb1 x11-xserver-utils \
&& if [ "$(uname -m)" = "x86_64" ];then baidunetdisk_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then baidunetdisk_arch=arm64; fi \
&& if [ "$(uname -m)" = "x86_64" ];then baidunetdisk_ver=${BAIDUNETDISK_VER};elif [ "$(uname -m)" = "aarch64" ];then baidunetdisk_ver=${BAIDUNETDISK_VER_ARM64}; fi \
&& wget https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/${baidunetdisk_ver}/baidunetdisk_${baidunetdisk_ver}_${baidunetdisk_arch}.deb \
&& dpkg -i  baidunetdisk_${baidunetdisk_ver}_${baidunetdisk_arch}.deb \
&& rm  baidunetdisk_${baidunetdisk_ver}_${baidunetdisk_arch}.deb \
&& install_app_icon.sh https://raw.githubusercontent.com/gshang2017/docker/master/baidunetdisk/icon/baidunetdisk.png \
#fix window decorations
&& sed -i 's@<decor>no<\/decor>@<decor>yes<\/decor>@g' /opt/base/etc/openbox/rc.xml.template \
#novnc_language
&& mv /opt/noVNC/index.html /opt/noVNC/index.html.en \
#fix dpkg
&& sed -i '/messagebus/d' /var/lib/dpkg/statoverride
