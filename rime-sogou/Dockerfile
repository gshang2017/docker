FROM mcr.microsoft.com/dotnet/runtime:3.1-alpine

ARG S6_VER=2.2.0.3
ARG IMEWLCONVERTER_VER=2.9.0

ENV TZ=Asia/Shanghai
ENV SOGOU_DICT_NAME=luna_pinyin.sogou

COPY root /

RUN apk add --no-cache bash ca-certificates tzdata py3-requests \
&& apk add --no-cache wqy-zenhei --repository http://dl-2.alpinelinux.org/alpine/edge/testing \
# install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz \
&& tar -xvzf s6-overlay-${s6_arch}.tar.gz \
# install imewlconverter
&& wget -P / https://github.com/studyzy/imewlconverter/releases/download/v${IMEWLCONVERTER_VER}/imewlconverter_Linux_Mac.tar.gz \
&& tar -xvf /imewlconverter_Linux_Mac.tar.gz -C /usr/local/bin \
# clear
&& rm -rf /var/cache/apk/* \
&& rm /s6-overlay-${s6_arch}.tar.gz \
&& rm /imewlconverter_Linux_Mac.tar.gz

VOLUME /output
ENTRYPOINT [ "/init" ]
