FROM alpine:3.21

ARG S6_VER=3.2.0.2
ARG JOPLIN_VER=3.2.1

ENV UID=1000
ENV GID=1000
ENV TZ=Asia/Shanghai
ENV JOPLIN_SYNC_PATH=
ENV JOPLIN_SYNC_USERNAME=
ENV JOPLIN_SYNC_PASSWORD=
ENV HOME=/config
ENV SOCAT_TCP_LISTEN_PORT=41185
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN  apk add --no-cache shadow bash ca-certificates tzdata wget npm socat inotify-tools jq coreutils \
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
#create koreader user
&& useradd -u 1000 -U -d /config -s /bin/false koreader \
&& usermod -G users koreader \
&& mkdir -p /config /usr/local/joplin \
&& chown -R koreader:koreader /config /usr/local/joplin \
# install joplin
&& NPM_CONFIG_PREFIX=/usr/local/joplin npm install -g joplin@${JOPLIN_VER} \
&& npm cache clean --force \
&& ln -s /usr/local/joplin/bin/joplin /usr/local/bin/joplin \
# clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /config
EXPOSE 41185
ENTRYPOINT [ "/init" ]
