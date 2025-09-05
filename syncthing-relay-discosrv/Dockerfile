FROM syncthing/discosrv:2.0.7 AS discosrvbin
FROM syncthing/relaysrv:2.0.7 AS relaysrvbin

FROM alpine:3.22

ARG S6_VER=3.2.1.0

ENV UID=1000
ENV GID=1000
ENV ENABLE_STDISCOSRV=true
ENV ENABLE_STRELAYSRV=true
ENV GLOBAL_RATE=100000000
ENV PER_SESSION_RATE=10000000
ENV MESSAGE_TIMEOUT=1m30s
ENV NETWORK_TIMEOUT=3m0s
ENV PING_INTERVAL=1m30s
ENV PROVIDED_BY=strelaysrv
ENV POOLS=
ENV DISCO_OTHER_OPTION=
ENV RELAY_OTHER_OPTION=
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=discosrvbin --chmod=755 /bin/stdiscosrv /usr/local/bin/stdiscosrv
COPY --from=relaysrvbin --chmod=755 /bin/strelaysrv /usr/local/bin/strelaysrv

RUN apk add --no-cache bash shadow ca-certificates \
#create stsrv user
&& useradd -u 1000 -U -d /config -s /bin/false stsrv \
&& usermod -G users stsrv \
# install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /config

EXPOSE 22067 22070 8443
ENTRYPOINT [ "/init" ]
