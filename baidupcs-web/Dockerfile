FROM alpine

ARG BaiduPCSGo_VER=3.5.9

RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash  bash-doc  bash-completion \
&& rm -rf /var/cache/apk/*  \
&& wget http://qiniu.zoranjojo.top/BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64.zip \
&& unzip BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64.zip \
&& mv BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64/BaiduPCS-Go BaiduPCS-Go \
&& rm -rf BaiduPCS-Go-${BaiduPCSGo_VER}-linux-amd64*\
&& chmod a+x BaiduPCS-Go

VOLUME /root/Downloads
EXPOSE 5299
ENTRYPOINT ["./BaiduPCS-Go"]
