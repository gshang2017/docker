FROM alpine:3.16

ARG S6_VER=2.2.0.3
ARG CALIBRE_WEB_VER=0.6.19
ARG CALIBRE_VER=5.35.0
ARG KEPUBIFY_VER=4.0.4

ENV UID=1000
ENV GID=1000
ENV ENABLE_CALIBRE_SERVER=true
ENV ENABLE_CALIBRE_SERVER_OPDS=false
ENV CALIBRE_SERVER_USER=
ENV CALIBRE_SERVER_PASSWORD=
ENV CALIBRE_SERVER_WEB_LANGUAGE=zh_CN
ENV CALIBRE_ASCII_FILENAME=true
ENV CALIBRE_WEB_LANGUAGE=zh_Hans_CN
ENV TZ=Asia/Shanghai
ENV CALIBREDB_OTHER_OPTION=
ENV DISABLE_GOOGLE_SEARCH=false
ENV DISABLE_SCHOLAR_SEARCH=false
ENV LANG=C.UTF-8
ENV HOME=/home/calibre
ENV QTWEBENGINE_CHROMIUM_FLAGS=--no-sandbox
ENV CALIBRE_DBPATH=/config/calibre-web
ENV CALIBRE_CONFIG_DIRECTORY=/config/calibre-server

COPY root /

RUN apk add --no-cache bash ca-certificates shadow tzdata python3 py3-pip expect imagemagick6 libintl libstdc++ libxcb mesa-gl \
            mesa-gles bash-completion libxi libxcomposite freetype fontconfig libidn nss eudev libxrender libxcursor libxtst \
            libxrandr libxkbcommon libatomic libxdamage ttf-dejavu inotify-tools libldap sqlite \
&& pip3 install --no-cache-dir sde \
&& apk add --no-cache unrar --repository https://dl-cdn.alpinelinux.org/alpine/v3.14/main \
&& apk add --no-cache wqy-zenhei --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing \
&& apk add --no-cache --virtual calibrewebdep build-base rust cargo libffi-dev git python3-dev openldap-dev libxml2-dev \
            libxslt-dev libjpeg-turbo-dev libevent-dev file cython \
#install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz \
&& tar -xvzf s6-overlay-${s6_arch}.tar.gz \
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
&& echo 'INPUT ( libldap.so )' > /usr/lib/libldap_r.so \
&& apk add --no-cache py3-lxml py3-cryptography \
&& pip3 install --no-cache-dir -r /usr/local/calibre-web/app/requirements.txt \
&& pip3 install --no-cache-dir -r /usr/local/calibre-web/app/optional-requirements.txt \
#install kepubify
&& if [ "$(uname -m)" = "x86_64" ];then kepubify_arch=64bit;elif [ "$(uname -m)" = "aarch64" ];then kepubify_arch=arm64;elif [ "$(uname -m)" = "armv7l" ];then kepubify_arch=arm;  fi \
&& wget https://github.com/geek1011/kepubify/releases/download/v${KEPUBIFY_VER}/kepubify-linux-${kepubify_arch} -O /usr/local/bin/kepubify \
#create calibre user
&& mkdir -p /home/calibre \
&& useradd -u 1000 -U -d /home/calibre -s /bin/false calibre \
&& usermod -G users calibre \
#clear
&& apk del calibrewebdep \
&& rm s6-overlay-${s6_arch}.tar.gz \
&& rm -rf /var/cache/apk/* /tmp/* /home/calibre/.c* \
&& chmod a+x /usr/local/bin/kepubify

VOLUME /library /config /autoaddbooks
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
