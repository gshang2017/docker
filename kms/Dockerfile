FROM alpine:3.13 as compilingvlmcsd

#compiling vlmcsd

ARG  SVN_VER=1113

RUN  apk add --no-cache git make build-base  \
&& wget    https://github.com/Wind4/vlmcsd/archive/svn${SVN_VER}.tar.gz  \
&& tar -zxf  svn${SVN_VER}.tar.gz  \
&& cd  /vlmcsd-svn${SVN_VER}  \
&& make



FROM alpine:3.13

ARG  S6_VER=2.2.0.1
ARG  SVN_VER=1113

ENV WEB=YES

COPY  root /
COPY --from=compilingvlmcsd /vlmcsd-svn${SVN_VER}/bin/vlmcsd  /usr/bin/vlmcsd

RUN apk add --no-cache darkhttpd  ca-certificates bash \
&& rm -rf /var/cache/apk/*  \
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&& tar -xvzf s6-overlay-${s6_arch}.tar.gz  \
&& rm s6-overlay-${s6_arch}.tar.gz  \
&& chmod a+x  /usr/bin/vlmcsd

EXPOSE 1688  80
ENTRYPOINT [ "/init" ]
