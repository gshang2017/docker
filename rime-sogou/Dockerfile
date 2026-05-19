FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine3.23 AS imewlconverter

ARG IMEWLCONVERTER_VER=3.4.1

RUN wget -P /tmp https://github.com/studyzy/imewlconverter/archive/refs/tags/v${IMEWLCONVERTER_VER}.tar.gz \
&& tar -C /tmp -xf /tmp/v${IMEWLCONVERTER_VER}.tar.gz \
&& cd /tmp/imewlconverter-${IMEWLCONVERTER_VER}/src/ImeWlConverterCmd \
&& dotnet build -c Release \
&& mv /tmp/imewlconverter-${IMEWLCONVERTER_VER}/src/ImeWlConverterCmd/bin/Release/net* /usr/local/imewlconverter

FROM mcr.microsoft.com/dotnet/runtime:10.0-alpine3.23

ARG S6_VER=3.2.3.0
ARG RIME_SOGOU_VER=2.5

ENV TZ=Asia/Shanghai
ENV SOGOU_DICT_NAME=luna_pinyin_simp.sogou_pop
ENV RIME_FREQ=2000001
ENV RIME_OPENCC=False
ENV RIME_OPENCC_CONFIG=s2t.json
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=imewlconverter --chmod=755 /usr/local/imewlconverter /usr/local/imewlconverter

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
# clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /output
ENTRYPOINT [ "/init" ]
