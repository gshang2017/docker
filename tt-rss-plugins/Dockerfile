FROM cthulhoo/ttrss-fpm-pgsql-static:20.07-376fe6271  as ttrss-src   
FROM postgres:12.0-alpine

ARG  S6_VER=2.0.0.1

ENV  POSTGRES_DB=
ENV  POSTGRES_USER=
ENV  POSTGRES_PASSWORD=

COPY  root  /
COPY --from=ttrss-src  /src/tt-rss  /usr/local/tt-rss

# install php tt-rss caddy git [npm nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow git npm  nodejs  ca-certificates caddy  php7-pcntl php7-cli php7-curl php7-ldap php7-mcrypt php7-mysqli php7-mysqlnd php7-pdo_mysql php7-mbstring php7-json php7-gd php7-pgsql php7-xml php7-opcache php7-posix php7-apcu php7-fpm  php7-pdo  php7-fileinfo  php7-iconv php7-dom php7-intl  php7-pdo_pgsql php7-session  \
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
&& npm install git+https://github.com/HenryQW/mercury-parser-api.git    \
# install  plugins
# install mercury_fulltext
&&  git clone https://github.com/HenryQW/mercury_fulltext.git /usr/local/tt-rss/defaults/plugins.local/mercury_fulltext     \
# install feediron
&&  git clone https://github.com/feediron/ttrss_plugin-feediron.git  /usr/local/tt-rss/defaults/plugins.local/feediron      \
# install fever
&&  git clone https://github.com/DigitalDJ/tinytinyrss-fever-plugin /usr/local/tt-rss/defaults/plugins.local/fever     \
# install api_feedreader
&&  mkdir -p /usr/local/tt-rss/defaults/plugins.local/api_feedreader    \
&&  wget -P /usr/local/tt-rss/defaults/plugins.local/api_feedreader https://raw.githubusercontent.com/jangernert/FeedReader/master/data/tt-rss-feedreader-plugin/api_feedreader/init.php  \
# install themes
# install tt-rss-feedly-theme
&&  git clone  https://github.com/levito/tt-rss-feedly-theme.git /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme     \
&&  cp -r /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly* /usr/local/tt-rss/defaults/themes.local     \
&&  rm -rf /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme

VOLUME  /config
EXPOSE 80 3000 5432
ENTRYPOINT [ "/init" ]
