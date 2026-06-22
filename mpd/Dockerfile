FROM alpine:3.23 AS mympd

ARG MYMPD_VER=25.2.1

WORKDIR /myMPD
RUN wget -O /tmp/mympd.tar.gz https://github.com/jcorporation/myMPD/archive/refs/tags/v${MYMPD_VER}.tar.gz
RUN tar -xvf /tmp/mympd.tar.gz -C /myMPD --strip-components 1
RUN ./build.sh installdeps
RUN cmake -B "release" -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DCMAKE_BUILD_TYPE=Release -DMYMPD_MANPAGES=OFF -DMYMPD_DOC=OFF .
RUN make -j $(nproc) -C "release"

FROM ghcr.io/gshang2017/mpd-bin:latest AS mpd

FROM ghcr.io/gshang2017/mpd-test-bin:latest AS mpd-test

FROM jlesage/baseimage-gui:alpine-3.23-v4.11.3

ENV APP_NAME=MPD
ENV TZ=Asia/Shanghai
ENV HOME=/config
ENV LC_ALL=C
ENV WEB_AUDIO=0
ENV KEEP_APP_RUNNING=1
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV MPD_PORT=6600
ENV ENABLE_MYMPD=true
ENV MYMPD_HTTP=true
ENV MYMPD_HTTP_PORT=80
ENV MYMPD_SSL=false
ENV MYMPD_SSL_PORT=443
ENV ENABLE_MPC_IDLE=true
ENV BLUETOOTHD_OPTION=
ENV ENABLE_FIX_OPENBOX_DECOR=false
ENV NOVNC_LANGUAGE=en
ENV BLUEMAN_LOGLEVEL=error
ENV DISABLE_RTKIT=1
ENV ENABLE_BLUETOOTH_CUSTOM_CONFIG=false
ENV ENABLE_PIPEWIRE_CUSTOM_CONFIG=false
ENV ENABLE_WIREPLUMBER_CUSTOM_CONFIG=false
ENV ENABLE_MAX_DEFAULT_SINK_VOLUME=true
ENV ENABLE_VOLUME_LIMIT=false
ENV ENABLE_MPD_TEST=false
ENV ENABLE_DMESG=false

COPY --chmod=755 root /
COPY --chmod=755 startapp.sh /startapp.sh
COPY --from=mympd --chmod=755 /myMPD/release/bin/mympd /usr/local/bin/
COPY --from=mympd --chmod=755 /myMPD/release/bin/mympd-script /usr/local/bin/
COPY --from=mympd --chmod=755 /myMPD/cli_tools/mympd-config/mympd-config /usr/local/bin/
COPY --from=mpd --chmod=755 /usr/bin/mpd /usr/local/bin/mpd
COPY --from=mpd --chmod=755 /usr/local/mpd/mpd.conf /usr/local/mpd/mpd.conf
COPY --from=mpd-test --chmod=755 /mpd /

RUN apk update \
&& apk add --no-cache bash \
 bluez \
 bluez-deprecated \
 blueman \
 blueman-lang \
 pipewire \
 wireplumber \
 pipewire-spa-bluez \
 libpulse-mainloop-glib \
 pipewire-pulse \
 pipewire-tools \
 wireplumber-doc \
 dbus-x11 \
 upower \
 adwaita-icon-theme \
 font-wqy-zenhei \
 networkmanager \
 py3-mpd2 \
 py3-dbus \
 py3-gobject3 \
 py3-mutagen \
 libao \
 ffmpeg-libavcodec \
 ffmpeg-libavfilter \
 ffmpeg-libavformat \
 ffmpeg-libavutil \
 libcdio \
 libcdio-paranoia \
 faad2-libs \
 fmt \
 icu-libs \
 libid3tag \
 pipewire-jack \
 libmad \
 libmodplug \
 libnfs \
 libsamplerate \
 libshout \
 libsmbclient \
 wavpack-libs \
 dmesg \
#mpdris2
&& apk add --no-cache --virtual mpdris2builddep git \
 build-base \
 autoconf \
 automake \
 intltool \
 gettext-dev \
&& git clone --depth 1 https://github.com/eonpatapon/mpDris2.git /tmp/mpDris2 \
&& cd /tmp/mpDris2 \
&& ./autogen.sh --sysconfdir=/etc \
&& make install \
#myMPD
&& apk add --no-cache openssl \
 flac \
 lua5.4 \
 pcre2 \
 newt \
 ca-certificates \
 utf8proc \
#app_icon
&& install_app_icon.sh https://raw.githubusercontent.com/gshang2017/docker/master/mpd/icon/mpd.png \
#novnc_language
&& mv /opt/noVNC/index.html /opt/noVNC/index.html.en \
#copy file
&& cp -f /etc/passwd /etc/bak.passwd \
&& cp -f /etc/group /etc/bak.group \
&& cp -f /etc/shadow /etc/bak.shadow \
&& cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bak \
#clear
&& apk del mpdris2builddep \
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /config /var/lib/bluetooth
EXPOSE 6600 80
