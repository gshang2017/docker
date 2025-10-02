FROM alpine:3.22 AS mympd

ARG MYMPD_VER=22.1.0

WORKDIR /myMPD
RUN wget -O /tmp/mympd.tar.gz https://github.com/jcorporation/myMPD/archive/refs/tags/v${MYMPD_VER}.tar.gz
RUN tar -xvf /tmp/mympd.tar.gz -C /myMPD --strip-components 1
RUN ./build.sh installdeps
RUN cmake -B "release" -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=Release -DMYMPD_MANPAGES=OFF -DMYMPD_DOC=OFF .
RUN make -j $(nproc) -C "release"


FROM ghcr.io/gshang2017/mpd-bin:latest AS mpd


FROM jlesage/baseimage-gui:alpine-3.22-v4.8.2

ENV APP_NAME=MPD
ENV TZ=Asia/Shanghai
ENV HOME=/config
ENV LC_ALL=C
ENV WEB_AUDIO=1
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

COPY --chmod=755 root /
COPY --chmod=755 startapp.sh /startapp.sh
COPY --from=mympd --chmod=755 /myMPD/release/bin/mympd /usr/bin/
COPY --from=mympd --chmod=755 /myMPD/release/bin/mympd-script /usr/bin/
COPY --from=mympd --chmod=755 /myMPD/cli_tools/mympd-config/mympd-config /usr/bin/
COPY --from=mpd --chmod=755 /usr/bin/mpd /usr/local/bin/mpd
COPY --from=mpd --chmod=755 /usr/local/mpd/mpd.conf /usr/local/mpd/mpd.conf

RUN apk update \
&& apk add --no-cache pulseaudio \
&& apk fix --no-cache pulseaudio \
&& apk add --no-cache bash libpulse-mainloop-glib bluez blueman blueman-lang pulseaudio-bluez \
          bluez-deprecated dbus-x11 mpd upower mpc adwaita-icon-theme font-wqy-zenhei gst-plugins-bad \
#mpdris2
&& apk add --no-cache py3-mpd2 --repository https://dl-cdn.alpinelinux.org/alpine/edge/community \
&& apk add --no-cache mpdris2 mpdris2-doc mpdris2-lang --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing \
#myMPD
&& apk add --no-cache openssl libid3tag flac lua5.4 pcre2 newt ca-certificates \
#pulse
&& sed -i 's/^load-module module-console-kit/#load-module module-console-kit/' /etc/pulse/default.pa \
&& mkdir -p /etc/pulse/default.pa.d \
#app_icon
&& install_app_icon.sh https://raw.githubusercontent.com/gshang2017/docker/master/mpd/icon/mpd.png \
#novnc_language
&& mv /opt/noVNC/index.html /opt/noVNC/index.html.en \
#copy file
&& cp -f /etc/passwd /etc/bak.passwd \
&& cp -f /etc/group /etc/bak.group \
&& cp -f /etc/shadow /etc/bak.shadow \
#clear
&& rm -rf /var/cache/apk/* /tmp/*

VOLUME /config /var/lib/bluetooth
EXPOSE 6600 80
