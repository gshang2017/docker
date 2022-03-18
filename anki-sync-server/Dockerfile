FROM ubuntu:20.04

ARG ANKI_SYNC_SERVER=develop
ARG S6_VER=2.2.0.3
ARG ANKI_VER=2.1.49

ENV ANKI_SYNC_SERVER_USER=
ENV ANKI_SYNC_SERVER_PASSWORD=
ENV ENABLE_NGINX_PROXY_SERVER=true
ENV UID=1000
ENV GID=1000

COPY root /

RUN apt-get update -q -y \
&& ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo Asia/Shanghai > /etc/timezone \
&& apt-get install -q -y expect python3 python3-pip wget unzip nginx git \
&& if [ "$(uname -m)" = "x86_64" ];then anki_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then anki_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then anki_arch=armv7l; fi \
&& wget -P /tmp https://github.com/gshang2017/anki-build/releases/download/v${ANKI_VER}/anki-${ANKI_VER}-${anki_arch}.tar.gz --no-check-certificate \
&& tar xzf /tmp/anki-${ANKI_VER}-${anki_arch}.tar.gz -C /tmp \
&& pip install --no-cache-dir /tmp/anki*.whl \
#install anki-sync-server
&& mkdir -p /usr/local/anki-sync-server \
&& if [ "$ANKI_SYNC_SERVER" = "develop" ]; then git clone -b develop --depth 1 https://github.com/ankicommunity/anki-sync-server.git /usr/local/anki-sync-server; fi \
&& if [ "$ANKI_SYNC_SERVER" != "develop" ]; then wget -P /tmp https://github.com/ankicommunity/anki-sync-server/archive/refs/tags/v${ANKI_SYNC_SERVER}.tar.gz --no-check-certificate; fi \
&& if [ -f "/tmp/v${ANKI_SYNC_SERVER}.tar.gz" ]; then tar -zxf /tmp/v${ANKI_SYNC_SERVER}.tar.gz --strip-components 1 -C /usr/local/anki-sync-server; fi \
&& sed -i 's/anki==*.*.*;/anki;/g' /usr/local/anki-sync-server/src/requirements.txt \
&& pip install --no-cache-dir -r /usr/local/anki-sync-server/src/requirements.txt \
#install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}-installer --no-check-certificate \
&& chmod +x /tmp/s6-overlay-${s6_arch}-installer \
&& /tmp/s6-overlay-${s6_arch}-installer / \
#defaults ankisyncd.conf
&& mkdir -p /usr/local/anki-sync-server/defaults \
&& mv /usr/local/anki-sync-server/src/ankisyncd.conf /usr/local/anki-sync-server/defaults/ankisyncd.conf \
&& sed -i 's/\.\//\/config\//g' /usr/local/anki-sync-server/defaults/ankisyncd.conf \
#defaults nginx.conf
&& cp -rf /usr/local/anki-sync-server/docs/src/nginx/nginx.example.conf /usr/local/anki-sync-server/defaults/nginx.conf \
&& sed -i "`grep -wn proxy_pass /usr/local/anki-sync-server/defaults/nginx.conf \
          |awk -F: '{print $1}'`a\            client_max_body_size 222M;" /usr/local/anki-sync-server/defaults/nginx.conf \
&& sed -i 's/default;/localhost;/g' /usr/local/anki-sync-server/defaults/nginx.conf \
#ankisyncd路径
&& echo "/usr/local/anki-sync-server/src/" > /usr/local/lib/python3.8/dist-packages/ankisyncd.pth \
#create ankisync user
&& useradd -u 1000 -U -d /config -s /bin/false ankisync \
&& usermod -G users ankisync \
#
&& apt-get clean \
&& rm -rf /tmp/* \

VOLUME /config
EXPOSE 27701
ENTRYPOINT [ "/init" ]
