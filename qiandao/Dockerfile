FROM alpine:3.14

ARG  S6_VER=2.2.0.3

ENV  UID=1000
ENV  GID=1000
ENV  TZ=Asia/Shanghai
ENV  DOMAIN=
ENV  MAIL_STMP=
ENV  MAIL_PORT=
ENV  MAIL_SSL=
ENV  MAIL_STARTTLS=
ENV  MAIL_USER=
ENV  MAIL_PASSWORD=
ENV  MAIL_DOMAIN=
ENV  MAILGUN_KEY=
ENV  ADMINEMAIL=


RUN  apk add --no-cache shadow bash ca-certificates tzdata python2 git gcc libc-dev python2-dev \
#install pip2(alpine:3.14)
&&  wget --no-check-certificate https://bootstrap.pypa.io/pip/2.7/get-pip.py \
&&  python2 get-pip.py \
# install s6-overlay
&&  if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&&  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&&  tar -xvzf s6-overlay-${s6_arch}.tar.gz  \
&&  rm s6-overlay-${s6_arch}.tar.gz   \
# install  qiandao
&&  git clone https://github.com/binux/qiandao.git /usr/local/qiandao  \
&&  pip2 install --no-cache-dir  -r /usr/local/qiandao/requirements.txt  \
&&  mkdir -p /usr/local/qiandao/defaults/  \
&&  mv /usr/local/qiandao/config.py  /usr/local/qiandao/defaults/   \
&&  mv /usr/local/qiandao/libs/utils.py  /usr/local/qiandao/defaults/   \
&&  chmod a+x /usr/local/qiandao/run.py   \
#create qiandao user
&&  useradd -u 1000 -U -d /dbpath -s /bin/false   qiandao   \
&&  usermod -G users qiandao   \
# clean
&&  rm get-pip.py \
&&  pip2 uninstall redis -y  \
&&  apk del  git  gcc  libc-dev python2-dev   \
&&  rm -rf /var/cache/apk/*

COPY root /


VOLUME  /dbpath
EXPOSE 8923
ENTRYPOINT [ "/init" ]
