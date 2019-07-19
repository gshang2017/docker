FROM alpine:3.10

ARG  GLIBC_VER=2.29
ARG  S6_VER=1.22.1.0
ARG  CALIBRE_WEB_VER=0.6.4

ENV USER=
ENV PASSWORD=
ENV WEBLANGUAGE=zh_CN

COPY  root  /

RUN apk add --no-cache bash ca-certificates  python2  expect libstdc++ mesa-gl libxcomposite  fontconfig  libxrender py2-pip py2-lxml  imagemagick6  \
&&  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub    \
&&  wget -P /tmp  https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}-r0/glibc-${GLIBC_VER}-r0.apk    \
&&  wget -P /tmp  https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}-r0/glibc-bin-${GLIBC_VER}-r0.apk    \
&&  wget -P /tmp  https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}-r0/glibc-i18n-${GLIBC_VER}-r0.apk   \  
&&  apk  add --no-cache /tmp/glibc-${GLIBC_VER}-r0.apk /tmp/glibc-bin-${GLIBC_VER}-r0.apk /tmp/glibc-i18n-${GLIBC_VER}-r0.apk     \
&&  /usr/glibc-compat/bin/localedef  -i POSIX -f  UTF-8  C.UTF-8 || true   \
#install s6-overlay 
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
#install  calibre-ebook 
&&  wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | bash /dev/stdin   \
#install  calibre-web
#&&  wget -P /tmp  https://github.com/janeczku/calibre-web/archive/master.zip  \
#&&  unzip -d /tmp      /tmp/master.zip   \
#&&  cp -rf  /tmp/calibre-web-master/*  /usr/local/calibre-web/  \ 
#&&  wget -P /tmp  https://github.com/janeczku/calibre-web/archive/${CALIBRE_WEB_VER}.zip  \
#&&  unzip -d /tmp      /tmp/${CALIBRE_WEB_VER}.zip   \
&&  wget -P /tmp  https://github.com/janeczku/calibre-web/archive/V${CALIBRE_WEB_VER}.zip  \
&&  unzip -d /tmp      /tmp/V${CALIBRE_WEB_VER}.zip   \
&&  cp -rf  /tmp/calibre-web-${CALIBRE_WEB_VER}/*  /usr/local/calibre-web/  \ 
#install py2-pillow
&&  apk add --no-cache py2-pillow=5.4.1-r0 --repository http://dl-4.alpinelinux.org/alpine/v3.9/main  \ 
&&  pip  install  --no-cache-dir  -r /usr/local/calibre-web/requirements.txt  \ 
#&&  pip  install --no-cache-dir sqlalchemy==1.1.0   \ 
#clean
&&  rm  /etc/apk/keys/sgerrand.rsa.pub   \ 
&&  apk del glibc-i18n    \ 
&&  rm s6-overlay-amd64.tar.gz  \
&&  rm -rf /var/cache/apk/*  \ 
&&  rm -rf /tmp/*  \   
&&  chmod a+x /usr/local/calibre-server/useradd.sh   \ 
&&  chmod a+x /usr/local/calibre-server/languagechange.sh

VOLUME /library  /config
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
