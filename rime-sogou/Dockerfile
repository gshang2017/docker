FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine

ARG S6_VER=3.2.0.2
ARG IMEWLCONVERTER_VER=3.1.0
ARG RIME_SOGOU_VER=2.4

ENV TZ=Asia/Shanghai
ENV SOGOU_DICT_NAME=luna_pinyin_simp.sogou_pop
ENV RIME_FREQ=2000001
ENV RIME_OPENCC=False
ENV RIME_OPENCC_CONFIG=s2t.json
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN apk add --no-cache bash ca-certificates tzdata py3-requests curl font-wqy-zenhei opencc \
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
&& wget -P /tmp https://github.com/studyzy/imewlconverter/releases/download/v${IMEWLCONVERTER_VER}/imewlconverter_Linux.tar.gz \
&& mkdir -p /usr/local/imewlconverter \
&& tar -xvf /tmp/imewlconverter_Linux.tar.gz -C /usr/local/imewlconverter \
# clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /output
ENTRYPOINT [ "/init" ]
