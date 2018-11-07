FROM alpine

ENV VERSION1 0.5.0
ENV VERSION2 1.34.0
ENV RPC_SECRET=
ENV SECRETAUTO=YES
ENV TRACKERSAUTO=YES
ENV TZ=Asia/Shanghai

RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash  bash-doc  bash-completion caddy tzdata \
&& rm -rf /var/cache/apk/*  


ADD aria2c.sh /usr/local/aria2/
ADD caddy.conf /etc/caddy/
COPY aria2c/aria2c-${VERSION2} /usr/bin/
COPY aria2c/aria2.conf  /usr/local/aria2/
COPY updatetrackers.sh  /usr/local/aria2/


RUN wget https://github.com/mayswind/AriaNg/releases/download/${VERSION1}/AriaNg-${VERSION1}.zip  \
&& mkdir -p /usr/local/aria2/AriaNg-${VERSION1} \
&& unzip -d /usr/local/aria2/AriaNg-${VERSION1}  AriaNg-${VERSION1}.zip  \
&& rm  AriaNg-${VERSION1}.zip \  
&& mv /usr/bin/aria2c-${VERSION2} /usr/bin/aria2c \  
&& mv /usr/local/aria2/AriaNg-${VERSION1} /usr/local/aria2/AriaNg \ 
&& mkdir -p /usr/local/aria2/AriaNg/js/Originaljs \ 
&& cp /usr/local/aria2/AriaNg/js/aria-ng* /usr/local/aria2/AriaNg/js/Originaljs \ 
&& chmod a+x /usr/bin/aria2c  \  
&& chmod a+x /usr/local/aria2/aria2c.sh \
&& chmod a+x /usr/local/aria2/updatetrackers.sh \
&& touch /usr/local/aria2/aria2.session \
&& touch /usr/local/aria2/dht.dat

VOLUME /Downloads
EXPOSE 6800  80 
ENTRYPOINT ["/usr/local/aria2/aria2c.sh"]
