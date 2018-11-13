FROM alpine

ENV VERSION 4.1.3
ENV TRACKERSAUTO=YES
ENV TZ=Asia/Shanghai
ENV CONFIG=/usr/local/qbittorrent
ENV WEBUIPORT=8989


COPY root /
ADD  defaults/qBittorrent.conf  /usr/local/qbittorrent/defaults/
COPY updatetrackers.sh  /usr/local/qbittorrent/


# install bash caddy tzdata s6 overlay, clear app
RUN  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&&   tar xvzf s6-overlay-amd64.tar.gz  \
&&   rm s6-overlay-amd64.tar.gz   \
&&   echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&&   echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
&&   echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories\
&&   apk update \
&&   apk upgrade \
&&   apk add --no-cache bash  bash-doc  bash-completion ca-certificates  tzdata   qbittorrent-nox   \
&&   rm -rf /var/cache/apk/*   \
&&   chmod a+x  /usr/local/qbittorrent/updatetrackers.sh  \
&&   ldd /usr/bin/qbittorrent-nox   |cut -d ">" -f 2|grep lib|cut -d "(" -f 1|xargs tar -chvf qbittorrent.tar \
&&   cp /usr/bin/qbittorrent-nox  /  \
&&   apk del qbittorrent-nox  \
&&   apk add --no-cache ssl_client \
&&   mv  /qbittorrent-nox  /usr/bin/ \
&&   chmod a+x /usr/bin/qbittorrent-nox  \
&&   tar  -xvf /qbittorrent.tar  \
&&   rm  /qbittorrent.tar 


VOLUME /Downloads /config
EXPOSE 8989  6881  6881/udp
ENTRYPOINT [ "/init" ]
