FROM alpine:3.11

ARG  S6_VER=1.22.1.0
ARG  SVN_VER=1113

ENV WEB=YES

COPY  root /

RUN apk add --no-cache darkhttpd  ca-certificates bash \
&& rm -rf /var/cache/apk/*  \
&& wget   https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&& tar xvzf s6-overlay-amd64.tar.gz  \
&& rm s6-overlay-amd64.tar.gz  \
&& wget    https://github.com/Wind4/vlmcsd/releases/download/svn${SVN_VER}/binaries.tar.gz  \
&& tar -zxvf  binaries.tar.gz  \
&& cp  /binaries/Linux/intel/static/vlmcsdmulti-x64-musl-static   /usr/bin/kms    \
&& rm -rf  binaries*  \
&& chmod a+x  /usr/bin/kms 

EXPOSE 1688  80  
ENTRYPOINT [ "/init" ]
