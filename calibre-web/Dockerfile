FROM alpine:3.20

ARG S6_VER=3.2.0.2
ARG CALIBRE_WEB_VER=0.6.24
ARG CALIBRE_VER=7.9.0
ARG KEPUBIFY_VER=4.0.4
ARG UNRAR_VERSION=6.2.12

ENV UID=1000
ENV GID=1000
ENV ENABLE_CALIBRE_SERVER=false
ENV ENABLE_CALIBRE_SERVER_OPDS=false
ENV ENABLE_CALIBREDB_URLLIBRARYPATH=true
ENV CALIBRE_SERVER_RESTART_AUTO=true
ENV CALIBRE_SERVER_USER=
ENV CALIBRE_SERVER_PASSWORD=
ENV CALIBRE_SERVER_WEB_LANGUAGE=zh_CN
ENV CALIBRE_SERVER_PORT=8080
ENV CALIBRE_PORT=8083
ENV CALIBRE_ASCII_FILENAME=true
ENV CALIBRE_WEB_LANGUAGE=zh_Hans_CN
ENV TZ=Asia/Shanghai
ENV CALIBREDB_OTHER_OPTION=
ENV DISABLE_GOOGLE_SEARCH=false
ENV DISABLE_SCHOLAR_SEARCH=false
ENV ENABLE_CHOWN_LIBRARY=true
ENV LANG=C.UTF-8
ENV HOME=/home/calibre
ENV QTWEBENGINE_CHROMIUM_FLAGS=--no-sandbox
ENV CALIBRE_DBPATH=/config/calibre-web
ENV CALIBRE_CONFIG_DIRECTORY=/config/calibre-server
ENV CALIBRE_LOCALHOST=true
ENV CALIBRE_RECONNECT=true
ENV ENABLE_FIX_COVER_COLOR=false
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN apk add --no-cache bash ca-certificates shadow tzdata python3 py3-pip py3-wheel expect imagemagick libintl libstdc++ libxcb mesa-gl \
            mesa-gles bash-completion libxi libxcomposite freetype fontconfig libidn nss eudev libxrender libxcursor libxtst libxrandr \
            libxkbcommon libatomic libxdamage ttf-dejavu inotify-tools libldap sqlite xdg-utils xcb-util-wm xcb-util-image xcb-util-keysyms \
            xcb-util-renderutil libxkbcommon-x11 libevent opus alsa-lib snappy minizip libxkbfile mesa-egl libb2 krb5-libs pcre2 \
            libjpeg-turbo-utils pciutils-libs lcms2 lcms2-plugins \
&& pip3 install --no-cache-dir --break-system-package sde rapidfuzz \
&& apk add --no-cache font-wqy-zenhei --repository https://dl-cdn.alpinelinux.org/alpine/edge/community \
#libvpx.so.8
&& apk add --no-cache libvpx==1.13.1-r0 --repository https://dl-cdn.alpinelinux.org/alpine/v3.19/community \
&& apk add --no-cache --virtual calibrewebdep build-base rust cargo libffi-dev git python3-dev openldap-dev libxml2-dev \
            libxslt-dev libjpeg-turbo-dev libevent-dev file cython cmake libressl-dev linux-headers \
#install unrar
&& mkdir /tmp/unrar \
&& wget -P /tmp https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz \
&& tar xf /tmp/unrarsrc-${UNRAR_VERSION}.tar.gz -C /tmp/unrar --strip-components=1 \
&& cd /tmp/unrar \
&& sed -i 's|LDFLAGS=-pthread|LDFLAGS=-pthread -static|' makefile \
&& make \
&& install -v -m755 unrar /usr/bin \
#install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
#install calibre-ebook
&& if [ "$(uname -m)" = "x86_64" ];then calibre_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then calibre_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then calibre_arch=armv7; fi \
&& wget -P /tmp https://github.com/gshang2017/bypy/releases/download/v${CALIBRE_VER}/calibre-${CALIBRE_VER}-${calibre_arch}.modify.env.musl.txz \
&& mkdir -p /opt/calibre && rm -rf /opt/calibre/* && tar xvf /tmp/calibre-${CALIBRE_VER}-${calibre_arch}.modify.env.musl.txz -C /opt/calibre && /opt/calibre/calibre_postinstall \
#install calibre-web
&& wget -P /tmp https://github.com/janeczku/calibre-web/archive/${CALIBRE_WEB_VER}.zip \
&& unzip -d /tmp /tmp/${CALIBRE_WEB_VER}.zip \
&& mkdir -p /usr/local/calibre-web/app \
&& cp -rf /tmp/calibre-web-${CALIBRE_WEB_VER}/* /usr/local/calibre-web/app \
#install calibre-web dep
# armv7l netifaces-plu
&& if [ "$(uname -m)" = "armv7l" ];then pip install git+https://github.com/tsukumijima/netifaces-plus@release_0_12_3 --break-system-packages; fi \
#
&& echo 'INPUT ( libldap.so )' > /usr/lib/libldap_r.so \
&& apk add --no-cache py3-lxml py3-cryptography poppler-data py3-gevent \
&& pip3 install --no-cache-dir --break-system-package -r /usr/local/calibre-web/app/requirements.txt \
&& pip3 install --no-cache-dir --break-system-package -r /usr/local/calibre-web/app/optional-requirements.txt \
#install kepubify
&& if [ "$(uname -m)" = "x86_64" ];then kepubify_arch=64bit;elif [ "$(uname -m)" = "aarch64" ];then kepubify_arch=arm64;elif [ "$(uname -m)" = "armv7l" ];then kepubify_arch=arm;  fi \
&& wget https://github.com/pgaskin/kepubify/releases/download/v${KEPUBIFY_VER}/kepubify-linux-${kepubify_arch} -O /usr/local/bin/kepubify \
&& chmod 755 /usr/local/bin/kepubify \
#chmod calibre-server-restart.sh
&& chmod 755 /usr/local/calibre-server/calibre-server-restart.sh \
#create calibre user
&& mkdir -p /home/calibre \
&& useradd -u 1000 -U -d /home/calibre -s /bin/false calibre \
&& usermod -G users calibre \
#clear
&& apk del calibrewebdep \
&& rm -rf /var/cache/apk/* /tmp/* /home/calibre/.c*

VOLUME /library /config /autoaddbooks
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
