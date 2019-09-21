FROM postgres:12-alpine

ARG  TTRSS_VER=19.8
ARG  S6_VER=1.22.1.0

ENV  POSTGRES_DB=
ENV  POSTGRES_USER=
ENV  POSTGRES_PASSWORD=

COPY  root  /

# install php tt-rss caddy [git npm  nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow git npm  nodejs  ca-certificates caddy  php7-pcntl php7-cli php7-curl php7-ldap php7-mcrypt php7-mysqli php7-mysqlnd php7-pdo_mysql php7-mbstring php7-json php7-gd php7-pgsql php7-xml php7-opcache php7-posix php7-apcu php7-fpm  php7-pdo  php7-fileinfo  php7-iconv php7-dom php7-intl  php7-pdo_pgsql php7-session  \
&&  wget -P /tmp  https://gitlab.com/gothfox/tt-rss/-/archive/${TTRSS_VER}/tt-rss-${TTRSS_VER}.zip   \
&&  unzip -d /usr/local/    /tmp/tt-rss-${TTRSS_VER}.zip   \
&&  mv /usr/local/tt-rss-${TTRSS_VER} /usr/local/tt-rss  \
&&  rm -rf /tmp/tt-rss-${TTRSS_VER}.zip    \
&&  rm -rf /var/cache/apk/*   \
# install s6-overlay
&&  wget  https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz  \
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
&&  usermod -G users ttrss   \
# install mercury-parser-api 
&&  cd /usr/local/  \
&&  git clone  https://github.com/HenryQW/mercury-parser-api.git  \
&&  cd /usr/local/mercury-parser-api    \ 
&& npm install \
# install  plugins
&&  cd /usr/local/tt-rss/defaults/plugins.local     \ 
# install mercury_fulltext
&&  git clone https://github.com/HenryQW/mercury_fulltext.git mercury_fulltext     \ 
# install feediron   
&&  git clone git://github.com/m42e/ttrss_plugin-feediron.git feediron      \ 
# install fever 
&&  git clone https://github.com/DigitalDJ/tinytinyrss-fever-plugin fever     \
# install api_feedreader
&&  wget https://github.com/jangernert/FeedReader/archive/v2.10.0.zip     \
&&  unzip v2.10.0.zip     \
&&  cp -rf FeedReader-2.10.0/data/tt-rss-feedreader-plugin/api_feedreader /usr/local/tt-rss/defaults/plugins.local \
&&  rm -rf *2.10.0* \
# install themes
&&  cd /usr/local/tt-rss/defaults/themes.local     \ 
# install feedly themes
&&  wget https://github.com/levito/tt-rss-feedly-theme/archive/master.zip      \ 
&&  unzip master.zip     \ 
&&  cd tt-rss-feedly-theme-master     \ 
&&  cp -r feedly* /usr/local/tt-rss/defaults/themes.local     \ 
&&  rm -rf /usr/local/tt-rss/defaults/themes.local/*master*     \ 
&& apk del git 

 
VOLUME  /config
EXPOSE 80 3000 5432 
ENTRYPOINT [ "/init" ]
