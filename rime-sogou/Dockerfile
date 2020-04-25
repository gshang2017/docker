FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine3.11

ARG  S6_VER=1.22.1.0
ARG  IMEWLCONVERTER_VER=2.8.0

ENV TZ=Asia/Shanghai

COPY root /

# install bash tzdata s6 overlay  py3-requests wqy-zenhei imewlconverter
RUN  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&   tar -xvzf s6-overlay-amd64.tar.gz  \
&&   rm s6-overlay-amd64.tar.gz   \
&&   apk add --no-cache bash ca-certificates tzdata  py3-requests \
&&   apk add  --no-cache wqy-zenhei --repository http://dl-2.alpinelinux.org/alpine/edge/testing \
&&   rm -rf /var/cache/apk/*   \
&&   wget  -P /  https://github.com/studyzy/imewlconverter/releases/download/v${IMEWLCONVERTER_VER}/imewlconverter_Linux_Mac.tar.gz \
&&   tar  -xvf /imewlconverter_Linux_Mac.tar.gz   -C   /usr/local/bin  \
&&   rm /imewlconverter_Linux_Mac.tar.gz  

VOLUME  /output
ENTRYPOINT [ "/init" ]
