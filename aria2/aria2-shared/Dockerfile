FROM alpine

ENV VERSION1 0.5.0
ENV VERSION2 1.34.0
ENV RPC_SECRET=
ENV CONFIG=/usr/local/aria2
ENV SECRETAUTO=YES
ENV TRACKERSAUTO=YES
ENV TZ=Asia/Shanghai


ADD caddy.conf /etc/caddy/
ADD aria2c/aria2-${VERSION2}-shared-musl-x86_64.zip  /usr/local/aria2/
COPY root /
COPY aria2c/aria2.conf  /usr/local/aria2/
COPY updatetrackers.sh  /usr/local/aria2/

# install bash caddy tzdata s6 overlay
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash  bash-doc  bash-completion caddy tzdata \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&& tar xvzf s6-overlay-amd64.tar.gz  \
&& rm s6-overlay-amd64.tar.gz  \
&& rm -rf /var/cache/apk/*  \
&& wget https://github.com/mayswind/AriaNg/releases/download/${VERSION1}/AriaNg-${VERSION1}.zip  \
&& mkdir -p /usr/local/aria2/AriaNg-${VERSION1} \
&& unzip -d /usr/local/aria2/AriaNg-${VERSION1}  AriaNg-${VERSION1}.zip  \
&& rm  AriaNg-${VERSION1}.zip \   
&& mv /usr/local/aria2/AriaNg-${VERSION1} /usr/local/aria2/AriaNg \ 
&& mkdir -p /usr/local/aria2/AriaNg/js/Originaljs \ 
&& cp /usr/local/aria2/AriaNg/js/aria-ng* /usr/local/aria2/AriaNg/js/Originaljs \ 
&& unzip -d /usr/local/aria2/   /usr/local/aria2/aria2-${VERSION2}-shared-musl-x86_64.zip   \ 
&& cp  /usr/local/aria2/aria2-shared-musl-x86_64/aria2c    /usr/bin/aria2c \ 
&& cp  /usr/local/aria2/aria2-shared-musl-x86_64/lib*    /usr/lib  \ 
&& rm  -rf /usr/local/aria2/aria2-shared-musl-x86_64  \ 
&& rm  -rf /usr/local/aria2/aria2-${VERSION2}-shared-musl-x86_64.zip  \ 
&& chmod a+x /usr/bin/aria2c  \  
&& chmod a+x /etc/cont-init.d/aria2c.sh \
&& chmod a+x /etc/services.d/aria2 \
&& chmod a+x /usr/local/aria2/updatetrackers.sh \
&& touch /usr/local/aria2/aria2.session \
&& touch /usr/local/aria2/dht.dat

VOLUME /Downloads /config
EXPOSE 6800  80  6881  6881/udp
ENTRYPOINT [ "/init" ]
