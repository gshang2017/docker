FROM alpine:3.8

ENV USER=
ENV PASSWORD=
ENV WEBLANGUAGE=zh_CN

COPY  root  /

RUN apk add --no-cache bash ca-certificates  python2 expect libstdc++ mesa-gl libxcomposite  fontconfig  libxrender   \
&&  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub    \
&&  wget -P /tmp  https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk    \
&&  wget -P /tmp  https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk    \
&&  wget -P /tmp  https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-i18n-2.28-r0.apk   \  
&&  apk  add --no-cache /tmp/glibc-2.28-r0.apk /tmp/glibc-bin-2.28-r0.apk /tmp/glibc-i18n-2.28-r0.apk     \
&&  /usr/glibc-compat/bin/localedef  -i POSIX -f  UTF-8  C.UTF-8 || true   \
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
&&  wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | bash /dev/stdin   \
&&  rm  /etc/apk/keys/sgerrand.rsa.pub   \ 
&&  apk del glibc-i18n    \ 
&&  rm s6-overlay-amd64.tar.gz  \
&&  rm -rf /var/cache/apk/*  \ 
&&  rm -rf /tmp/*  \ 
&&  chmod a+x /usr/local/calibre-server/useradd.sh   \ 
&&  chmod a+x /usr/local/calibre-server/languagechange.sh


VOLUME /library  /config
EXPOSE 8080
ENTRYPOINT [ "/init" ]
