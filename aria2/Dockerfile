FROM alpine:3.14 as compilingaria2c

#compiling aria2c

ARG  ARIA2_VER=1.35.0


RUN  apk add --no-cache ca-certificates make g++ gcc file cppunit-dev zlib-dev openssl-dev expat-dev sqlite-dev c-ares-dev libssh2-dev  \
&&   mkdir /aria2c  \
&&   wget -P /aria2c   https://github.com/aria2/aria2/releases/download/release-${ARIA2_VER}/aria2-${ARIA2_VER}.tar.gz  \
&&   tar  -zxvf  /aria2c/aria2-${ARIA2_VER}.tar.gz  -C    /aria2c  \
&&   cd  /aria2c/aria2-${ARIA2_VER}  \
&&   sed  -i  's/"1", 1, 16/"1", 1, 128/g'          src/OptionHandlerFactory.cc    \
&&   sed  -i  's/"20M", 1_m, 1_g/"4k", 1_k, 1_g/g'  src/OptionHandlerFactory.cc    \
&&   if [ "$(uname -m)" = "x86_64" ];then host=x86_64-alpine-linux-musl;elif [ "$(uname -m)" = "aarch64" ];then host=aarch64-alpine-linux-musl;elif [ "$(uname -m)" = "armv7l" ];then host=armv7-alpine-linux-musleabihf; fi  \
&&   ./configure --without-libxml2  --without-gnutls --with-openssl  --host=$host   \
&&   make install-strip   \
&&   ldd /usr/local/bin/aria2c   |cut -d ">" -f 2|grep lib|cut -d "(" -f 1|xargs tar -chvf /aria2c/aria2c.tar  \
&&   mkdir /aria2  \
&&   tar  -xvf /aria2c/aria2c.tar  -C /aria2   \
&&   cp --parents /usr/local/bin/aria2c /aria2


# docker aria2


FROM alpine:3.14

ARG  AriaNg_VER=1.2.2
ARG  S6_VER=2.2.0.3

ENV RPC_SECRET=
ENV SECRETAUTO=YES
ENV TRACKERSAUTO=YES
ENV TZ=Asia/Shanghai
ENV UID=0
ENV GID=0
ENV UMASK=022


COPY  root /
COPY --from=compilingaria2c  /aria2  /

# install bash  darkhttpd tzdata s6 overlay AriaNg aria2 shadow
RUN apk add --no-cache bash  curl ca-certificates  darkhttpd  tzdata shadow \
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&& tar -xvzf s6-overlay-${s6_arch}.tar.gz  \
&& rm s6-overlay-${s6_arch}.tar.gz   \
&& rm -rf /var/cache/apk/*  \
#create aria2 user
&&  useradd -u 1000 -U -d /config -s /bin/false aria2   \
&&  usermod -G users aria2   \
#
&& wget https://github.com/mayswind/AriaNg/releases/download/${AriaNg_VER}/AriaNg-${AriaNg_VER}.zip  \
&& mkdir -p /usr/local/aria2/AriaNg/js/Originaljs \
&& unzip -d /usr/local/aria2/AriaNg    AriaNg-${AriaNg_VER}.zip  \
&& rm  AriaNg-${AriaNg_VER}.zip \
&& cp /usr/local/aria2/AriaNg/js/aria-ng* /usr/local/aria2/AriaNg/js/Originaljs \
&& chmod a+x /usr/local/bin/aria2c   \
&& chmod a+x /usr/local/aria2/updatetrackers.sh


VOLUME /Downloads /config
EXPOSE 6800  8080  6881  6881/udp
ENTRYPOINT [ "/init" ]
