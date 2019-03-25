
FROM alpine:latest

COPY root /
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash curl \
&& rm -rf /var/cache/apk/*  \
&& chmod +x /entrypoint.sh \
&& wget https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz  \
&& tar xvzf s6-overlay-amd64.tar.gz  \
&& rm s6-overlay-amd64.tar.gz

RUN set -xe \
  && addgroup -g 1000 -S alpine \
  && adduser -u 1000 -G alpine -h /home/alpine -D alpine \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

EXPOSE 5299
CMD exec gosu alpine /entrypoint.sh
