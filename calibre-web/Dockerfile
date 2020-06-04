FROM alpine:3.12

ARG  GLIBC_VER=2.31
ARG  S6_VER=2.0.0.1
ARG  CALIBRE_WEB_VER=0.6.8
ARG  CALIBRE_VER=3.48.0
ARG  KEPUBIFY_VER=3.1.2

ENV USER=
ENV PASSWORD=
ENV WEBLANGUAGE=zh_CN
ENV LANG=C.UTF-8

COPY  root  /

RUN apk add --no-cache bash ca-certificates  python3 py3-pip  unrar expect libstdc++ mesa-gl libxcomposite  fontconfig  libxrender  imagemagick6  \
&&  apk add --no-cache --virtual  calibrewebdep zstd   py3-setuptools  git gcc g++ python3-dev openldap-dev  libxml2-dev libxslt-dev  libjpeg-turbo-dev  \
#install glibc
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
&&  wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | bash /dev/stdin version=${CALIBRE_VER} \
#install  calibre-web
&&  wget -P /tmp  https://github.com/janeczku/calibre-web/archive/${CALIBRE_WEB_VER}.zip  \
&&  unzip -d /tmp      /tmp/${CALIBRE_WEB_VER}.zip   \
&&  cp -rf  /tmp/calibre-web-${CALIBRE_WEB_VER}/*  /usr/local/calibre-web/  \ 
#install calibre-web dep
&&  apk add --no-cache  py3-gevent  py3-lxml  \ 
&&  apk add --no-cache 'py3-six<1.15.0' --repository http://dl-4.alpinelinux.org/alpine/v3.11/main  \ 
#&&  export C_INCLUDE_PATH=/usr/include/libxml2/   \ 
&&  pip3  install  --no-cache-dir  -r /usr/local/calibre-web/requirements.txt  \ 
&&  pip3  install  --no-cache-dir  -r /usr/local/calibre-web/optional-requirements.txt  \ 
#fix PDF libuuid.so libstdc++.so.6
&&  wget https://www.archlinux.org/packages/core/x86_64/libutil-linux/download/ -O /tmp/libutil-linux.pkg.tar.zst  \ 
&&  wget https://www.archlinux.org/packages/community/x86_64/gcc8-libs/download/ -O /tmp/gcc8.pkg.tar.xz.zst  \ 
&&  mkdir -p /tmp/lib-linux  \ 
&&  zstd -cdf /tmp/libutil-linux.pkg.tar.zst | tar -xf -  -C /tmp/lib-linux  \ 
&&  zstd -cdf /tmp/gcc8.pkg.tar.xz.zst | tar -xf -  -C /tmp/lib-linux  \ 
&&  cp /tmp/lib-linux/usr/lib/libuuid.so.1.3.0 /usr/glibc-compat/lib  \ 
&&  cp  /tmp/lib-linux/usr/lib/gcc/x86_64-pc-linux-gnu/8.4.0/libstdc++.so.6.0.25  /usr/glibc-compat/lib  \ 
&&  /usr/glibc-compat/sbin/ldconfig  \  
#install kepubify
&&  wget https://github.com/geek1011/kepubify/releases/download/v${KEPUBIFY_VER}/kepubify-linux-64bit -O /usr/local/bin/kepubify   \ 
#clean
&&  rm  /etc/apk/keys/sgerrand.rsa.pub   \ 
&&  apk del glibc-i18n calibrewebdep  \ 
&&  rm s6-overlay-amd64.tar.gz  \
&&  rm -rf /var/cache/apk/*  \ 
&&  rm -rf /tmp/*  \   
&&  chmod a+x /usr/local/calibre-server/useradd.sh   \ 
&&  chmod a+x /usr/local/calibre-server/languagechange.sh   \ 
&&  chmod a+x /usr/local/bin/kepubify

VOLUME /library  /config
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
