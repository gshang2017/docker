#compiling qB
FROM ghcr.io/gshang2017/qbittorrent-nox:latest AS compilingqb

#compiling qB2
FROM ghcr.io/gshang2017/qbittorrentee-nox:latest AS compilingqb2

# docker qB
FROM alpine:3.22

ARG S6_VER=3.2.1.0

ENV UID=1000
ENV GID=1000
ENV UMASK=022
ENV TZ=Asia/Shanghai
ENV QB_WEBUI_PORT=8989
ENV QB_EE_BIN=false
ENV LIBTORRENT2=false
ENV QB_TRACKERS_UPDATE_AUTO=true
ENV QB_TRACKERS_LIST_URL=https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt
ENV ENABLE_CHOWN_DOWNLOADS=true
ENV ENABLE_CHOWN_R_DOWNLOADS=true
ENV QB_DOWNLOADS_DIRECTORY=/Downloads
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=compilingqb --chmod=755 /qbittorrent /
COPY --from=compilingqb2 --chmod=755 /qbittorrent /

#install bash curl tzdata python3 shadow qt6
RUN apk add --no-cache bash curl ca-certificates tzdata python3 shadow qt6-qtbase-sqlite qt6-qtbase wget \
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
