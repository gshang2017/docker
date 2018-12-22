FROM alpine:3.8

ARG BaiduPCSGo_VER=3.6.1

RUN apk add --no-cache bash  \
&&  rm -rf /var/cache/apk/*  \
&&  wget --no-check-certificate https://github.com/liuzhuoling2011/baidupcs-web/releases/download/${BaiduPCSGo_VER}/BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64.zip \
&&  unzip BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64.zip \
&&  mv BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64/BaiduPCS-Go /usr/local/bin/BaiduPCS-Go \
&&  rm -rf BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64*  \
&&  chmod a+x /usr/local/bin/BaiduPCS-Go  \
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz 

VOLUME /root/Downloads
EXPOSE 5299
ENTRYPOINT ["BaiduPCS-Go"]


