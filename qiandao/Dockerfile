FROM alpine:3.10

ARG  S6_VER=1.22.1.0

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


RUN  apk add --no-cache bash  ca-certificates  tzdata python  py-pip git  gcc  libc-dev python-dev    \
# install s6-overlay
&&  wget  https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
&&  tar -xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz  \
# install  qiandao
&&  git clone https://github.com/binux/qiandao.git /usr/local/qiandao  \
&&  pip install --no-cache-dir  -r /usr/local/qiandao/requirements.txt  \ 
&&  mkdir -p /usr/local/qiandao/defaults/  \
&&  mv /usr/local/qiandao/config.py  /usr/local/qiandao/defaults/   \
&&  mv /usr/local/qiandao/libs/utils.py  /usr/local/qiandao/defaults/   \
&&  chmod a+x /usr/local/qiandao/run.py   \
# clean
&&  pip uninstall redis -y  \
&&  apk del py-pip git  gcc  libc-dev python-dev   \
&&  rm -rf /var/cache/apk/*  

COPY root /


VOLUME  /dbpath
EXPOSE 8923  
ENTRYPOINT [ "/init" ]
