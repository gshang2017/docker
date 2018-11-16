FROM alpine

ENV WEB=YES

COPY  root /

RUN apk add --no-cache darkhttpd  ca-certificates bash \
&& rm -rf /var/cache/apk/*  \
&& wget   https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&& tar xvzf s6-overlay-amd64.tar.gz  \
&& rm s6-overlay-amd64.tar.gz  \
&& wget    https://github.com/Wind4/vlmcsd/releases/download/svn1112/binaries.tar.gz  \
&& tar -zxvf  binaries.tar.gz  \
&& cp  /binaries/Linux/intel/static/vlmcsdmulti-x64-musl-static   /usr/bin/kms    \
&& rm -rf  binaries*  \
&& chmod a+x  /usr/bin/kms 

EXPOSE 1688  80  
ENTRYPOINT [ "/init" ]
