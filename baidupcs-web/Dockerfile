FROM alpine

ENV VERSION 3.5.8

RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash  bash-doc  bash-completion \
&& rm -rf /var/cache/apk/*  \
&& wget http://qiniu.zoranjojo.top/BaiduPCS-Go-${VERSION}-linux-amd64.zip \
&& unzip BaiduPCS-Go-${VERSION}-linux-amd64.zip \
&& mv BaiduPCS-Go-${VERSION}-linux-amd64/BaiduPCS-Go BaiduPCS-Go \
&& rm -rf BaiduPCS-Go-${VERSION}-linux-amd64*\
&& chmod a+x BaiduPCS-Go

VOLUME /root/Downloads
EXPOSE 5299
ENTRYPOINT ["./BaiduPCS-Go"]
