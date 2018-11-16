
FROM alpine

ENV  TZ=Asia/Shanghai
ENV  DBPATH=/usr/local/qiandao
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



COPY root /

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&&  apk update \
&&  apk add --no-cache bash  bash-doc  bash-completion ca-certificates  tzdata python2  py2-tornado  py2-u-msgpack   py2-chardet  py2-requests   py2-crypto  py2-jinja2   \    
&&  wget  https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz  \
&&  rm -rf /var/cache/apk/*  \
&&  wget  http://ftp5.gwdg.de/pub/linux/archlinux/community/os/x86_64/python2-pbkdf2-1.3-4-any.pkg.tar.xz  \ 
&&  tar xvJf  python2-pbkdf2-1.3-4-any.pkg.tar.xz  -C  /  \
&&  rm  python2-pbkdf2-1.3-4-any.pkg.tar.xz \
&&  wget  https://github.com/binux/qiandao/archive/master.zip \
&&  unzip   master.zip -d  /usr/local/  \
&&  cp  -rf /usr/local/qiandao-master/*  /usr/local/qiandao/  \
&&  rm  -rf  /usr/local/qiandao-master   \
&&  rm  master.zip \
&&  mkdir -p /usr/local/qiandao/defaults/  \
&&  mv /usr/local/qiandao/config.py  /usr/local/qiandao/defaults/   \
&&  mv /usr/local/qiandao/libs/utils.py  /usr/local/qiandao/defaults/   \
&&  chmod a+x /usr/local/qiandao/run.py

VOLUME  /config
EXPOSE 8923  
ENTRYPOINT [ "/init" ]
