FROM mcr.microsoft.com/dotnet/runtime:3.1-alpine

ARG S6_VER=3.1.2.1
ARG IMEWLCONVERTER_VER=2.9.0

ENV TZ=Asia/Shanghai
ENV SOGOU_DICT_NAME=luna_pinyin.sogou
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN apk add --no-cache bash ca-certificates tzdata py3-requests \
&& apk add --no-cache wqy-zenhei --repository http://dl-2.alpinelinux.org/alpine/edge/testing \
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
# install imewlconverter
&& wget -P /tmp https://github.com/studyzy/imewlconverter/releases/download/v${IMEWLCONVERTER_VER}/imewlconverter_Linux_Mac.tar.gz \
&& mkdir -p /usr/local/imewlconverter \
&& tar -xvf /tmp/imewlconverter_Linux_Mac.tar.gz -C /usr/local/imewlconverter \
# clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /output
ENTRYPOINT [ "/init" ]
