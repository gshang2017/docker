FROM alpine:3.10

ARG  RELAYSRV_VER=1.3.1
ARG  DISCOSRV_VER=1.3.1
ARG  S6_VER=1.22.1.0

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

RUN apk add --no-cache bash  ca-certificates  \
# install relaysrv discosrv
&&  wget https://github.com/syncthing/relaysrv/releases/download/v${RELAYSRV_VER}/strelaysrv-linux-amd64-v${RELAYSRV_VER}.tar.gz  \
&&  tar -xvzf strelaysrv-linux-amd64-v${RELAYSRV_VER}.tar.gz  \
&&  mv  strelaysrv-linux-amd64-v${RELAYSRV_VER}/strelaysrv /usr/local/bin/relaysrv   \
&&  wget https://github.com/syncthing/discosrv/releases/download/v${DISCOSRV_VER}/stdiscosrv-linux-amd64-v${DISCOSRV_VER}.tar.gz  \
&&  tar -xvzf  stdiscosrv-linux-amd64-v${DISCOSRV_VER}.tar.gz  \
&&  mv  stdiscosrv-linux-amd64-v${DISCOSRV_VER}/stdiscosrv /usr/local/bin/discosrv   \
&&  chmod a+x  /usr/local/bin/relaysrv   \
&&  chmod a+x  /usr/local/bin/discosrv   \
&&  rm -rf stdiscosrv*   \
&&  rm -rf strelaysrv*   \
# install s6-overlay
&&  wget  https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&  tar -xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz  \
&&  rm -rf /var/cache/apk/* 

VOLUME discosrvdb certs

EXPOSE 22067 22070 8443
ENTRYPOINT [ "/init" ]
