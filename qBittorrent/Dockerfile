
FROM alpine:3.9 as compilingqB

#compiling qB

ARG  LIBTORRENT_VER=1.1.12
ARG  QBITTORRENT_VER=4.1.5


RUN  apk add --no-cache ca-certificates make g++ gcc qt5-qtsvg-dev boost-dev qt5-qttools-dev file \
&&   mkdir /qbtorrent  \
&&   wget -P /qbtorrent https://github.com/arvidn/libtorrent/releases/download/libtorrent_`echo "$LIBTORRENT_VER"|sed 's#\.#_#g'`/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz   \
&&   tar  -zxvf  /qbtorrent/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz   -C    /qbtorrent  \
&&   cd  /qbtorrent/libtorrent-rasterbar-${LIBTORRENT_VER} \
&&   ./configure  --host=x86_64-alpine-linux-musl \
&&   make install-strip \
&&   wget  -P /qbtorrent  https://github.com/qbittorrent/qBittorrent/archive/release-${QBITTORRENT_VER}.zip  \
&&   unzip   /qbtorrent/release-${QBITTORRENT_VER}.zip  -d    /qbtorrent \
&&   cd  /qbtorrent/qBittorrent-release-${QBITTORRENT_VER} \
&&   ./configure   --disable-gui --host=x86_64-alpine-linux-musl \
&&   make install \
&&   ldd /usr/local/bin/qbittorrent-nox   |cut -d ">" -f 2|grep lib|cut -d "(" -f 1|xargs tar -chvf /qbtorrent/qbittorrent.tar  \
&&   mkdir /qbittorrent   \
&&   tar  -xvf /qbtorrent/qbittorrent.tar   -C  /qbittorrent   \
&&   cp --parents /usr/local/bin/qbittorrent-nox  /qbittorrent
 

 # docker qB


FROM alpine:3.9

ENV TRACKERSAUTO=YES
ENV TZ=Asia/Shanghai
ENV WEBUIPORT=8989

COPY root /
COPY --from=compilingqB  /qbittorrent  /

# install bash caddy tzdata s6 overlay python3
RUN  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v1.22.0.0/s6-overlay-amd64.tar.gz  \
&&   tar -xvzf s6-overlay-amd64.tar.gz  \
&&   rm s6-overlay-amd64.tar.gz   \
&&   apk add --no-cache bash  ca-certificates  tzdata  python3 \
&&   rm -rf /var/cache/apk/*   \
&&   chmod a+x  /usr/local/qbittorrent/updatetrackers.sh  \
&&   chmod a+x  /usr/local/bin/qbittorrent-nox  


VOLUME /Downloads /config
EXPOSE 8989  6881  6881/udp
ENTRYPOINT [ "/init" ]
