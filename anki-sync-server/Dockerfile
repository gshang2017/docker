FROM alpine:3.11

ARG  ANKI__SYNC_SERVER=2.1.0
ARG  S6_VER=1.22.1.0

ENV USER=
ENV PASSWORD=

COPY  root  /

RUN apk add --no-cache bash  python3  expect  \
#install anki-sync-server
&&  wget -P /tmp  https://github.com/tsudoko/anki-sync-server/releases/download/${ANKI__SYNC_SERVER}/ankisyncd-${ANKI__SYNC_SERVER}.tar.gz    \
&&  tar  -zxvf  /tmp/ankisyncd-${ANKI__SYNC_SERVER}.tar.gz --strip-components 1 -C  /usr/local/anki-sync-server   \
#Anki ≥2.1.9 remove "pyaudio" from requirements.txt
&&  sed -i '/^pyaudio/d' /usr/local/anki-sync-server/anki-bundled/requirements.txt    \
&&  pip3 install  --no-cache-dir -r /usr/local/anki-sync-server/anki-bundled/requirements.txt    \
&&  pip3 install  --no-cache-dir webob    \ 
#install s6-overlay
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
#clear
&&  rm s6-overlay-amd64.tar.gz    \
&&  rm -rf /var/cache/apk/*  \ 
&&  rm -rf /tmp/*   \ 
#defaults ankisyncd.conf
&&  mkdir -p /usr/local/anki-sync-server/defaults  \ 
&&  mv /usr/local/anki-sync-server/ankisyncd.conf /usr/local/anki-sync-server/defaults/ankisyncd.conf  \ 
&&  sed -i 's/\.\//\/config\//g' /usr/local/anki-sync-server/defaults/ankisyncd.conf  \ 
# ankisyncd路径
&&  echo "/usr/local/anki-sync-server/" > /usr/lib/python3.8/site-packages/ankisyncd.pth  \ 
&&  chmod a+x /usr/local/anki-sync-server/useradd.sh

VOLUME  /config
EXPOSE 27701
ENTRYPOINT [ "/init" ]
