FROM ubuntu:latest as builder
RUN \
  apt-get update && \
  apt-get install -y wget

FROM alpine:latest

COPY --from=builder  /usr/bin/wget  /usr/bin/wget
COPY root /
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash curl \
&& rm -rf /var/cache/apk/*  \
&& chmod +x /usr/bin/wget  \
&& chmod +x /entrypoint.sh \
&& wget https://github.com/just-containers/s6-overlay/releases/download/v1.21.7.0/s6-overlay-amd64.tar.gz  \
&& tar xvzf s6-overlay-amd64.tar.gz  \
&& rm s6-overlay-amd64.tar.gz 

VOLUME /root/Downloads /config
EXPOSE 5299
CMD /entrypoint.sh
