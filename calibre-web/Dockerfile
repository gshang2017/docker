FROM alpine:3.12

ARG  GLIBC_VER=2.32
ARG  S6_VER=2.1.0.0
ARG  CALIBRE_WEB_VER=0.6.9
ARG  CALIBRE_VER=4.23.0
ARG  KEPUBIFY_VER=3.1.4

ENV USER=
ENV PASSWORD=
ENV WEBLANGUAGE=zh_CN
ENV LANG=C.UTF-8
ENV QTWEBENGINE_CHROMIUM_FLAGS=--no-sandbox

COPY  root  /

RUN apk add --no-cache bash ca-certificates  python3 py3-pip  unrar expect libstdc++ mesa-gl libxcomposite  fontconfig  libxrender  imagemagick6  bash-completion  zstd ttf-dejavu eudev-libs inotify-tools \
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
#fix PDF libuuid.so libstdc++.so.6 libbsd.so nss nspr
&&  wget https://www.archlinux.org/packages/core/x86_64/util-linux-libs/download/ -O /tmp/util-linux-libs.pkg.tar.zst  \
&&  wget https://www.archlinux.org/packages/community/x86_64/gcc8-libs/download/ -O /tmp/gcc8-libs.pkg.tar.zst  \
&&  wget https://www.archlinux.org/packages/extra/x86_64/libbsd/download/ -O /tmp/libbsd.pkg.tar.zst  \
&&  wget https://www.archlinux.org/packages/core/x86_64/nss/download/  -O /tmp/nss.pkg.tar.zst  \
&&  wget https://www.archlinux.org/packages/core/x86_64/nspr/download/ -O /tmp/nspr.pkg.tar.zst  \
&&  mkdir -p /tmp/util-linux-libs /tmp/gcc8-libs /tmp/libbsd /tmp/nss /tmp/nspr \
&&  zstd -cdf /tmp/util-linux-libs.pkg.tar.zst | tar -xf -  -C /tmp/util-linux-libs  \
&&  zstd -cdf /tmp/gcc8-libs.pkg.tar.zst | tar -xf -  -C /tmp/gcc8-libs  \
&&  zstd -cdf /tmp/libbsd.pkg.tar.zst | tar -xf -  -C /tmp/libbsd  \
&&  zstd -cdf /tmp/nss.pkg.tar.zst | tar -xf -  -C /tmp/nss  \
&&  zstd -cdf /tmp/nspr.pkg.tar.zst | tar -xf -  -C /tmp/nspr  \
&&  cp /tmp/util-linux-libs/usr/lib/libuuid.so.1.3.0 /usr/glibc-compat/lib  \
&&  cp /tmp/gcc8-libs/usr/lib/gcc/x86_64-pc-linux-gnu/8.4.0/libstdc++.so.6.0.25  /usr/glibc-compat/lib  \
&&  cp /tmp/libbsd/usr/lib/libbsd.so.0.10.0  /usr/glibc-compat/lib  \
&&  cp -rP /tmp/nss/usr/lib/*  /usr/glibc-compat/lib  \
&&  cp -rP /tmp/nspr/usr/lib/* /usr/glibc-compat/lib  \
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

VOLUME /library  /config /autoaddbooks
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
