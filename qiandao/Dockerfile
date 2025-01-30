FROM python:3.12.8-alpine3.21

ARG CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse
ARG S6_VER=3.2.0.2
ARG QIANDAO_VER=20250129

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
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
ENV PATH=/opt/venv/bin:$PATH

COPY --chmod=755 root /

RUN  apk add --no-cache shadow bash ca-certificates tzdata sqlite git curl wget \
&& apk add --no-cache --virtual qiandaodep build-base python3-dev libffi-dev curl-dev cargo \
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
&& git clone --depth 1 -b ${QIANDAO_VER} https://github.com/qd-today/qd.git /usr/local/qiandao/app \
# add safe.directory
&& git config --global --add safe.directory /usr/local/qiandao/app \
#del ddddocr redis
&& sed -i '/redis/d' /usr/local/qiandao/app/requirements.txt \
&& sed -i '/ddddocr/d' /usr/local/qiandao/app/requirements.txt \
#
&& python3 -m venv /opt/venv \
&& pip3 install --no-cache-dir -r /usr/local/qiandao/app/requirements.txt \
&& pip3 install --no-cache-dir pycurl \
#create qiandao user
&&  useradd -u 1000 -U -d /config -s /bin/false qiandao \
&&  usermod -G users qiandao \
# clear
&&  apk del qiandaodep \
&&  rm -rf /var/cache/apk/* /tmp/*

VOLUME /config
EXPOSE 8923
ENTRYPOINT [ "/init" ]
