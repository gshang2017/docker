FROM alpine:3.9

ARG  ANKI_VER=2.1.11
ARG  S6_VER=1.22.1.0

ENV USER=
ENV PASSWORD=

COPY  root  /

RUN apk add --no-cache bash  python3  expect git py3-pip    \
&&  git clone https://github.com/tsudoko/anki-sync-server.git  /tmp/anki-sync-server   \
&&  cp -rf /tmp/anki-sync-server/*  /usr/local/anki-sync-server   \
&&  wget -P /tmp  https://github.com/dae/anki/archive/${ANKI_VER}.tar.gz   \
&&  tar  -zxvf  /tmp/${ANKI_VER}.tar.gz  --strip-components 1 -C    /usr/local/anki-sync-server/anki-bundled    \
&&  git init   \
&&  git submodule update --init    \
&&  sed -i '/# Packaged commands/,$d' /usr/local/anki-sync-server/anki-bundled/anki/sound.py    \
&&  sed -i '/^pyaudio/d' /usr/local/anki-sync-server/anki-bundled/requirements.txt    \
&&  pip3 install  --no-cache-dir -r /usr/local/anki-sync-server/anki-bundled/requirements.txt    \
&&  pip3 install  --no-cache-dir webob    \ 
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz    \
&&  apk del git py3-pip   \
&&  rm -rf /var/cache/apk/*  \ 
&&  rm -rf /tmp/*   \ 
&&  mkdir -p /usr/local/anki-sync-server/defaults  \ 
&&  mv /usr/local/anki-sync-server/ankisyncd.conf /usr/local/anki-sync-server/defaults/ankisyncd.conf  \ 
&&  sed -i 's/\.\//\/config\//g' /usr/local/anki-sync-server/defaults/ankisyncd.conf  \ 
# ankisyncd路径
&&  echo "/usr/local/anki-sync-server/" > /usr/lib/python3.6/site-packages/ankisyncd.pth  \ 
&&  chmod a+x /usr/local/anki-sync-server/useradd.sh

VOLUME  /config
EXPOSE 27701
ENTRYPOINT [ "/init" ]
