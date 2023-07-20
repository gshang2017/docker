FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine

ARG S6_VER=3.1.5.0
ARG IMEWLCONVERTER_VER=3.0.0
ARG RIME_SOGOU_VER=2.1

ENV TZ=Asia/Shanghai
ENV SOGOU_SCEL_UPDATE_AUTO=true
ENV RIME_DICT_UPDATE_AUTO=true
ENV SOGOU_DICT_NAME=luna_pinyin_simp.sogou_pop
ENV RIME_FREQ=2000001
ENV ENGLISH_DICT_SET=True
ENV BASIC_DICT_SET=True
ENV SOGOU_TOTAL_OFFICIAL_DICT_SET=True
ENV SOGOU_UNOFFICIAL_DICT_SET=True
ENV SOGOU_SINGLE_FILE=True
ENV ORDER=True
ENV DEDUPLICATION=True
ENV LEN_NUM=0
ENV RIME_OPENCC=False
ENV RIME_OPENCC_CONFIG=s2t.json
ENV PREFIX_DICT_NAME=luna_pinyin_simp.
ENV SOGOU_ENGINEERING_APPLICATION=True
ENV SOGOU_AGRICULTURE_AND_FISHING_LIVESTOCK=True
ENV SOGOU_SOCIAL_SCIENCES=True
ENV SOGOU_NATURAL_SCIENCE=True
ENV SOGOU_CITY_INFORMATION=True
ENV SOGOU_ENTERTAINMENT_AND_LEISURE=True
ENV SOGOU_HUMANITIES=True
ENV SOGOU_SPORTS_AND_LEISURE=True
ENV SOGOU_LIFE_ENCYCLOPEDIA=True
ENV SOGOU_ART_DESIGN=True
ENV SOGOU_VIDEO_GAMES=True
ENV SOGOU_MEDICINE_AND_MEDICINE=True
ENV GITHUB_PROXY=
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN apk add --no-cache bash ca-certificates tzdata py3-requests py3-feedparser curl \
&& apk add --no-cache wqy-zenhei opencc --repository http://dl-2.alpinelinux.org/alpine/edge/testing \
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
&& TAG_NAME=$(curl --silent https://api.github.com/repos/gshang2017/rime-dict/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
&& wget -P /tmp https://github.com/gshang2017/rime-dict/releases/download/$TAG_NAME/v${IMEWLCONVERTER_VER}_imewlconverter_Linux_Mac.tar.gz \
&& mkdir -p /usr/local/imewlconverter \
&& tar -xvf /tmp/v${IMEWLCONVERTER_VER}_imewlconverter_Linux_Mac.tar.gz -C /usr/local/imewlconverter \
# clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /output /config
ENTRYPOINT [ "/init" ]
