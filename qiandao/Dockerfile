FROM alpine:3.17

ARG S6_VER=3.1.4.1
ARG QIANDAO_VER=20230228

ENV UID=1000
ENV GID=1000
ENV TZ=Asia/Shanghai
ENV DOMAIN=
ENV MAIL_SMTP=
ENV MAIL_PORT=
ENV MAIL_SSL=True
ENV MAIL_STARTTLS=False
ENV MAIL_USER=
ENV MAIL_PASSWORD=
ENV MAIL_FROM=
ENV MAIL_DOMAIN=
ENV ADMIN_MAIL=
ENV QIANDAO_UPDATE_AUTO=false
ENV ENABLE_MAIL_STARTTLS=false
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN  apk add --no-cache shadow bash ca-certificates tzdata python3 py3-pip py3-wheel py3-curl sqlite git curl wget py3-cryptography py3-pycryptodome \
&& apk add --no-cache --virtual qiandaodep build-base python3-dev libffi-dev \
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
# install qiandao
&& mkdir -p /usr/local/qiandao/app \
&& git config --global advice.detachedHead false \
&& git clone --depth 1 -b ${QIANDAO_VER} https://github.com/qiandao-today/qiandao.git /usr/local/qiandao/app \
# add safe.directory
&& git config --global --add safe.directory /usr/local/qiandao/app \
#del ddddocr redis
&& sed -i '/redis/d' /usr/local/qiandao/app/requirements.txt \
&& sed -i '/ddddocr/d' /usr/local/qiandao/app/requirements.txt \
# apk add py3-cryptography py3-pycryptodome
&& sed -i '/cryptography/d' /usr/local/qiandao/app/requirements.txt \
&& sed -i '/pycryptodome/d' /usr/local/qiandao/app/requirements.txt \
#
&& pip3 install --no-cache-dir -r /usr/local/qiandao/app/requirements.txt \
#create qiandao user
&&  useradd -u 1000 -U -d /config -s /bin/false qiandao \
&&  usermod -G users qiandao \
# clear
&&  apk del qiandaodep \
&&  rm -rf /var/cache/apk/* /tmp/*

VOLUME /config
EXPOSE 8923
ENTRYPOINT [ "/init" ]
