FROM alpine:latest

COPY  root /

RUN apk add --no-cache bash curl wget  \
&&  rm -rf /var/cache/apk/*  \
&&  wget   https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz  \
&&  tar xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz 

VOLUME /root/Downloads /config
EXPOSE 5299
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh


