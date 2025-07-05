FROM rust:alpine3.22 AS builder

ARG ANKI_VER=25.07.1

RUN apk update \
&& apk add --no-cache build-base protobuf \
&& cargo install --git https://github.com/ankitects/anki.git \
    --tag ${ANKI_VER} \
    --root /anki-server  \
    --locked  \
    anki-sync-server

FROM alpine:3.22

ARG S6_VER=3.2.1.0

ENV TZ=Asia/Shanghai
ENV SYNC_USER1=user:pass
ENV SYNC_BASE=/ankisyncdir
ENV UID=1000
ENV GID=1000
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
ENV SYNC_PORT=8080
ENV SYNC_HOST=0.0.0.0
ENV MAX_SYNC_PAYLOAD_MEGS=100

COPY --chmod=755 root /
COPY --from=builder /anki-server/bin/anki-sync-server /usr/local/bin/anki-sync-server

RUN apk update \
&& apk add --no-cache wget xz bash shadow tzdata \
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
#create ankisync user
&& mkdir /ankisyncdir \
&& useradd -u 1000 -U -d /ankisyncdir -s /bin/false ankisync \
&& usermod -G users ankisync \
#
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /ankisyncdir
EXPOSE 8080
ENTRYPOINT [ "/init" ]
