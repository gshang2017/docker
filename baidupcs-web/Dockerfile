FROM alpine/alpine:3.8

ARG BaiduPCSGo_VER=3.5.9

RUN apk add --no-cache bash  \
&& rm -rf /var/cache/apk/*  \
&& wget http://qiniu.zoranjojo.top/BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64.zip \
&& unzip BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64.zip \
&& mv BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64/BaiduPCS-Go /usr/local/bin/BaiduPCS-Go \
&& rm -rf BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64*\
&& chmod a+x /usr/local/bin/BaiduPCS-Go

VOLUME /root/Downloads
EXPOSE 5299
ENTRYPOINT ["BaiduPCS-Go"]
