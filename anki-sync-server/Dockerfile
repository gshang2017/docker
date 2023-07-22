FROM ubuntu:22.04

ARG S6_VER=3.1.5.0
ARG ANKI_VER=2.1.65

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

RUN apt-get update -q -y \
&& ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo Asia/Shanghai > /etc/timezone \
&& apt-get install -q -y python3 python3-pip wget \
#install anki
&& pip install --no-cache-dir anki==${ANKI_VER} \
#install s6-overlay
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
&& apt-get clean \
&& rm -rf /tmp/*

VOLUME /ankisyncdir
EXPOSE 8080
ENTRYPOINT [ "/init" ]
