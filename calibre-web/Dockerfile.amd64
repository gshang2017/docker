FROM alpine:3.12

ARG  S6_VER=2.1.0.2
ARG  CALIBRE_WEB_VER=0.6.9
ARG  CALIBRE_VER=5.2.0
ARG  KEPUBIFY_VER=3.1.6

ENV USER=
ENV PASSWORD=
ENV WEBLANGUAGE=zh_CN
ENV LANG=C.UTF-8
ENV QTWEBENGINE_CHROMIUM_FLAGS=--no-sandbox

COPY  root  /
RUN apk add --no-cache bash ca-certificates  python3 py3-pip unrar expect imagemagick6 	libintl libstdc++ libxcb mesa-gl bash-completion libxi libxcomposite freetype fontconfig libidn nss eudev ttf-dejavu inotify-tools \
&&  apk add --no-cache --virtual  calibrewebdep build-base libffi-dev git python3-dev openldap-dev libxml2-dev libxslt-dev libjpeg-turbo-dev libevent-dev file cython py3-greenlet \
#install s6-overlay
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
#install  calibre-ebook
&&  wget -P /tmp  https://github.com/gshang2017/bypy/releases/download/v${CALIBRE_VER}/calibre-${CALIBRE_VER}-x86_64.musl.txz \
&&  mkdir -p /opt/calibre && rm -rf /opt/calibre/* && tar xvf /tmp/calibre-${CALIBRE_VER}-x86_64.musl.txz -C /opt/calibre && /opt/calibre/calibre_postinstall \
#install  calibre-web
&&  wget -P /tmp  https://github.com/janeczku/calibre-web/archive/${CALIBRE_WEB_VER}.zip  \
&&  unzip -d /tmp      /tmp/${CALIBRE_WEB_VER}.zip   \
&&  cp -rf  /tmp/calibre-web-${CALIBRE_WEB_VER}/*  /usr/local/calibre-web/  \
#install calibre-web dep
&&  apk add --no-cache py3-lxml  \
&&  apk add --no-cache 'py3-six<1.15.0' --repository http://dl-4.alpinelinux.org/alpine/v3.11/main  \
&&  pip3  install  --no-cache-dir  -r /usr/local/calibre-web/requirements.txt  \
&&  pip3  install  --no-cache-dir  -r /usr/local/calibre-web/optional-requirements.txt  \
#install kepubify
&&  wget https://github.com/geek1011/kepubify/releases/download/v${KEPUBIFY_VER}/kepubify-linux-64bit -O /usr/local/bin/kepubify   \
#clean
&&  apk del  calibrewebdep  \
&&  rm s6-overlay-amd64.tar.gz  \
&&  rm -rf /var/cache/apk/*  \
&&  rm -rf /tmp/*  \
&&  chmod a+x /usr/local/calibre-server/useradd.sh   \
&&  chmod a+x /usr/local/calibre-server/languagechange.sh   \
&&  chmod a+x /usr/local/bin/kepubify

VOLUME /library  /config /autoaddbooks
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
