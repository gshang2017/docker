#compiling vlmcsd
FROM alpine:3.20 as compilingvlmcsd

ARG VLMCSD_VER=1113

RUN apk add --no-cache git build-base \
&& wget https://github.com/Wind4/vlmcsd/archive/svn${VLMCSD_VER}.tar.gz \
&& tar -zxf svn${VLMCSD_VER}.tar.gz \
&& cd /vlmcsd-svn${VLMCSD_VER} \
&& make

# docker vlmcsd
FROM alpine:3.20

ARG S6_VER=3.2.0.2
ARG VLMCSD_VER=1113

ENV UID=1000
ENV GID=1000
ENV KMS_README_WEB=true
ENV KMS_README_WEB_PORT=8080
ENV VLMCSD_SERVER_PORT=1688
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=compilingvlmcsd --chmod=755 /vlmcsd-svn${VLMCSD_VER}/bin/vlmcsd /usr/bin/vlmcsd

RUN apk add --no-cache darkhttpd ca-certificates bash shadow \
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
#create kms user
&& useradd -u 1000 -U -s /bin/false kms \
&& usermod -G users kms \
#
&& rm -rf /var/cache/apk/* /tmp/*

EXPOSE 1688 8080
ENTRYPOINT [ "/init" ]
