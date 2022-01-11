FROM alpine:3.15

ARG  RELAYSRV_VER=1.18.6
ARG  DISCOSRV_VER=1.18.6
ARG  S6_VER=2.2.0.3

ENV UID=1000
ENV GID=1000
ENV GLOBAL_RATE=100000000
ENV PER_SESSION_RATE=10000000
ENV MESSAGE_TIMEOUT=1m30s
ENV NETWORK_TIMEOUT=3m0s
ENV PING_INTERVAL=1m30s
ENV PROVIDED_BY=strelaysrv
ENV POOLS=
ENV DISCO_OTHER_OPTION=
ENV RELAY_OTHER_OPTION=

COPY  root  /

RUN apk add --no-cache bash shadow ca-certificates  \
# install relaysrv discosrv
&&  if [ "$(uname -m)" = "x86_64" ];then srv_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then srv_arch=arm64;elif [ "$(uname -m)" = "armv7l" ];then srv_arch=arm; fi  \
&&  wget https://github.com/syncthing/relaysrv/releases/download/v${RELAYSRV_VER}/strelaysrv-linux-${srv_arch}-v${RELAYSRV_VER}.tar.gz  \
&&  tar -xvzf strelaysrv-linux-${srv_arch}-v${RELAYSRV_VER}.tar.gz  \
&&  mv  strelaysrv-linux-${srv_arch}-v${RELAYSRV_VER}/strelaysrv /usr/local/bin/relaysrv   \
&&  wget https://github.com/syncthing/discosrv/releases/download/v${DISCOSRV_VER}/stdiscosrv-linux-${srv_arch}-v${DISCOSRV_VER}.tar.gz  \
&&  tar -xvzf  stdiscosrv-linux-${srv_arch}-v${DISCOSRV_VER}.tar.gz  \
&&  mv  stdiscosrv-linux-${srv_arch}-v${DISCOSRV_VER}/stdiscosrv /usr/local/bin/discosrv   \
&&  chmod a+x  /usr/local/bin/relaysrv   \
&&  chmod a+x  /usr/local/bin/discosrv   \
&&  rm -rf stdiscosrv*   \
&&  rm -rf strelaysrv*   \
#create stsrv user
&&  useradd -u 1000 -U -d /config -s /bin/false   stsrv   \
&&  usermod -G users stsrv   \
# install s6-overlay
&&  if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&&  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&&  tar -xvzf s6-overlay-${s6_arch}.tar.gz  \
&&  rm s6-overlay-${s6_arch}.tar.gz  \
&&  rm -rf /var/cache/apk/*

VOLUME config

EXPOSE 22067 22070 8443
ENTRYPOINT [ "/init" ]
