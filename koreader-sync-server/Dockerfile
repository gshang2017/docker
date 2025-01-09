FROM alpine:3.21

ARG S6_VER=3.2.0.2
ARG KOREADER_SYNC_SERVER_VER=2.0

ENV PATH=/opt/openresty/nginx/sbin:$PATH
# run gin in production mode
ENV GIN_ENV production
ENV UID=1000
ENV GID=1000
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

WORKDIR /app

COPY --chmod=755 root /

RUN apk update \
# install lua openresty
&& apk add --no-cache shadow ca-certificates tzdata openssl openresty readline lua5.1 redis luarocks bash \
&& apk add --no-cache --virtual koreader-sync-server-dep git wget build-base openssl-dev readline-dev lua5.1-dev \
&& ln -s /usr/bin/luarocks-5.1 /usr/bin/luarocks \
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
# koreader-sync-server
&& wget -O /tmp/koreader-sync-server.tar.gz https://github.com/koreader/koreader-sync-server/archive/refs/tags/v${KOREADER_SYNC_SERVER_VER}.tar.gz \
&& mkdir -p /app/koreader-sync-server \
&& tar -xvf /tmp/koreader-sync-server.tar.gz -C /app/koreader-sync-server --strip-components 1 \
&& mv /app/koreader-sync-server/config /app/koreader-sync-server/config.default \
# nginx crt
&& mkdir -p /etc/nginx/ssl \
&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/" \
# luarocks install
&& luarocks install --verbose luasocket \
&& luarocks install luasec  \
&& luarocks install redis-lua \
&& luarocks install busted \
# patch gin for https support
# https://github.com/gster/gin.git
&& git clone --depth 1 https://github.com/ostinelli/gin.git \
# luaposix 36.2.1
&& sed -i s/33.3.1/36.2.1/g gin/gin-0.2.0-1.rockspec \
&& cd gin \
&& luarocks make \
#run gin in foreground
&& echo "daemon off;" >> /app/koreader-sync-server/config.default/nginx.conf \
#create koreader user
&& useradd -u 1000 -U -d /app -s /bin/false koreader \
&& usermod -G users koreader \
#
&& apk del koreader-sync-server-dep \
&& rm -rf gin /var/cache/apk/* /tmp/*

VOLUME /var/log/redis /var/lib/redis /config
EXPOSE 7200
ENTRYPOINT [ "/init" ]
