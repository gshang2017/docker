#compiling qB
FROM alpine:3.16 as compilingqB

ARG LIBTORRENT_VER=1.2.17
ARG QBITTORRENT_VER=4.4.5
ARG QBITTORRENT_EE_VER=4.4.5.10

RUN apk add --no-cache ca-certificates cmake build-base boost-dev python3-dev \
         py3-setuptools samurai qt6-qttools-dev libexecinfo-dev \
#libtorrent-rasterbar
&& mkdir /qbbuild \
&& wget -P /qbbuild https://github.com/arvidn/libtorrent/releases/download/v${LIBTORRENT_VER}/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz \
&& tar -zxf /qbbuild/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz -C /qbbuild \
&& cd /qbbuild/libtorrent-rasterbar-${LIBTORRENT_VER} \
&& cmake -B build -DCMAKE_BUILD_TYPE=None -DCMAKE_CXX_STANDARD=17 -DCMAKE_VERBOSE_MAKEFILE=ON \
         -DCMAKE_INSTALL_PREFIX=/usr -Dbuild_tests=ON -Dpython-bindings=ON -Dpython-egg-info=ON \
&& cmake --build build -- -j $(nproc) \
&& cmake --install build \
&& strip /usr/lib/libtorrent-rasterbar.so.* \
#qBittorrent-Enhanced-Edition
&& wget -P /qbbuild https://github.com/c0re100/qBittorrent-Enhanced-Edition/archive/release-${QBITTORRENT_EE_VER}.zip \
&& unzip /qbbuild/release-${QBITTORRENT_EE_VER}.zip -d /qbbuild \
&& cd /qbbuild/qBittorrent-Enhanced-Edition-release-${QBITTORRENT_EE_VER} \
&& cmake -B build-nox -G Ninja -D CMAKE_CXX_STANDARD_LIBRARIES="/usr/lib/libexecinfo.so" \
         -D CMAKE_CXX_STANDARD=17 -DCMAKE_BUILD_TYPE=Release -DQT6=ON -DGUI=OFF \
&& cmake --build build-nox -- -j $(nproc) \
&& cmake --install build-nox \
&& strip /usr/local/bin/qbittorrent-nox \
&& mv /usr/local/bin/qbittorrent-nox /usr/local/bin/qbittorrentee-nox \
#qBittorrent
&& wget -P /qbbuild https://github.com/qbittorrent/qBittorrent/archive/release-${QBITTORRENT_VER}.zip \
&& unzip /qbbuild/release-${QBITTORRENT_VER}.zip -d /qbbuild \
&& cd /qbbuild/qBittorrent-release-${QBITTORRENT_VER} \
&& cmake -B build-nox -G Ninja -D CMAKE_CXX_STANDARD_LIBRARIES="/usr/lib/libexecinfo.so" \
         -D CMAKE_CXX_STANDARD=17 -DCMAKE_BUILD_TYPE=Release -DQT6=ON -DGUI=OFF \
&& cmake --build build-nox -- -j $(nproc) \
&& cmake --install build-nox \
&& strip /usr/local/bin/qbittorrent-nox \
&& mkdir /qbittorrent \
&& cp --parents /usr/local/bin/qbittorrent-nox /qbittorrent \
&& cp --parents /usr/local/bin/qbittorrentee-nox /qbittorrent \
&& cp --parents /usr/lib/libtorrent-rasterbar.so.* /qbittorrent

# docker qB
FROM alpine:3.16

ARG S6_VER=3.1.2.1

ENV UID=1000
ENV GID=1000
ENV UMASK=022
ENV TZ=Asia/Shanghai
ENV QB_WEBUI_PORT=8989
ENV QB_EE_BIN=false
ENV QB_TRACKERS_UPDATE_AUTO=true
ENV QB_TRACKERS_LIST_URL=https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=compilingqB --chmod=755 /qbittorrent /

#install bash curl tzdata python3 shadow qt6
RUN apk add --no-cache bash curl ca-certificates tzdata python3 shadow qt6-qtbase-sqlite qt6-qtbase libexecinfo \
#install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
#create qbittorrent user
&& useradd -u 1000 -U -d /config -s /bin/false qbittorrent \
&& usermod -G users qbittorrent \
#install Search
&& wget -P /tmp https://github.com/qbittorrent/search-plugins/archive/refs/heads/master.zip \
&& unzip /tmp/master.zip -d /tmp \
&& mkdir -p /usr/local/qbittorrent/defaults/Search \
&& cp /tmp/search-plugins-master/nova3/engines/*.py /usr/local/qbittorrent/defaults/Search \
#conf trackers
&& curl -so /tmp/trackers_all.txt $QB_TRACKERS_LIST_URL \
&& Newtrackers="Session\AdditionalTrackers=$(awk '{if(!NF){next}}1' /tmp/trackers_all.txt|sed ':a;N;s/\n/\\n/g;ta' )" \
&& echo $Newtrackers >/tmp/Newtrackers.txt \
&& sed -i '/Session\\AdditionalTrackers=/r /tmp/Newtrackers.txt' /usr/local/qbittorrent/defaults/qBittorrent.conf \
&& sed -i '1,/^Session\\AdditionalTrackers=.*/{//d;}' /usr/local/qbittorrent/defaults/qBittorrent.conf \
#clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /Downloads /config
EXPOSE 8989 6881 6881/udp
ENTRYPOINT [ "/init" ]
