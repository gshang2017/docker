FROM alpine:3.9

ARG  TTRSS_VER=19.2 

COPY  root  /

# install php tt-rss caddy
RUN apk add --no-cache bash shadow  ca-certificates caddy  php7-pcntl php7-cli php7-curl php7-ldap php7-mcrypt php7-mysqli php7-mysqlnd php7-pdo_mysql php7-mbstring php7-json php7-gd php7-pgsql php7-xml php7-opcache php7-posix php7-apcu php7-fpm  php7-pdo  php7-fileinfo  php7-iconv php7-dom php7-intl  php7-pdo_pgsql php7-session  \
&&  wget -P /tmp  https://gitlab.com/gothfox/tt-rss/-/archive/${TTRSS_VER}/tt-rss-${TTRSS_VER}.zip   \
&&  unzip -d /usr/local/    /tmp/tt-rss-${TTRSS_VER}.zip   \
&&  mv /usr/local/tt-rss-${TTRSS_VER} /usr/local/tt-rss  \
&&  rm -rf /tmp/tt-rss-${TTRSS_VER}.zip    \
&&  rm -rf /var/cache/apk/*   \
# install s6-overlay
&&  wget  https://github.com/just-containers/s6-overlay/releases/download/v1.22.0.0/s6-overlay-amd64.tar.gz  \
&&  tar -xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz  \
&&  mkdir -p  /usr/local/tt-rss/defaults \
&&  mv /usr/local/tt-rss/cache /usr/local/tt-rss/defaults/cache \
&&  mv /usr/local/tt-rss/feed-icons /usr/local/tt-rss/defaults/feed-icons \
&&  mv /usr/local/tt-rss/lock /usr/local/tt-rss/defaults/lock \
&&  mv /usr/local/tt-rss/plugins.local /usr/local/tt-rss/defaults/plugins.local \
&&  mv /usr/local/tt-rss/themes.local /usr/local/tt-rss/defaults/themes.local \
#create ttrss user
&&  groupmod -g 1000 users \
&&  useradd -u 1001 -U  -s /bin/bash  ttrss  \
&&  usermod -G users ttrss 
 
VOLUME  /config
EXPOSE 80
ENTRYPOINT [ "/init" ]
