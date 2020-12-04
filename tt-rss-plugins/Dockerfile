FROM cthulhoo/ttrss-fpm-pgsql-static:20.11-81c52b4b1  as ttrss-src
FROM postgres:12.0-alpine

ARG  S6_VER=2.1.0.2

ENV  POSTGRES_DB=
ENV  POSTGRES_USER=
ENV  POSTGRES_PASSWORD=

COPY  root  /
COPY --from=ttrss-src  /src/tt-rss  /usr/local/tt-rss

# install php tt-rss caddy git [npm nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow git npm  nodejs  ca-certificates caddy  php7-pcntl php7-cli php7-curl php7-ldap php7-mcrypt php7-mysqli php7-mysqlnd php7-pdo_mysql php7-mbstring php7-json php7-gd php7-pgsql php7-xml php7-opcache php7-posix php7-apcu php7-fpm  php7-pdo  php7-fileinfo  php7-iconv php7-dom php7-intl  php7-pdo_pgsql php7-session build-base  \
# install s6-overlay
&&  if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi  \
&&  wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz  \
&&  tar -xvzf s6-overlay-${s6_arch}.tar.gz  \
# install mercury-parser-api
&& npm install git+https://github.com/HenryQW/mercury-parser-api.git    \
# install zhparser
&&  wget http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2   \
&&  tar -xf scws-1.2.3.tar.bz2   \
&&  cd scws-1.2.3   \
&&  ./configure   \
&&  make install   \
&&  git clone https://github.com/amutu/zhparser.git   \
&&  cd zhparser   \
&&  make install   \
#create ttrss user
&&  useradd -u 1000 -U -d /config -s /bin/false ttrss   \
&&  usermod -G users ttrss   \
# install  plugins
&&  mkdir -p  /usr/local/tt-rss/defaults \
&&  mv /usr/local/tt-rss/cache /usr/local/tt-rss/defaults/cache \
&&  mv /usr/local/tt-rss/feed-icons /usr/local/tt-rss/defaults/feed-icons \
&&  mv /usr/local/tt-rss/lock /usr/local/tt-rss/defaults/lock \
&&  mv /usr/local/tt-rss/plugins.local /usr/local/tt-rss/defaults/plugins.local \
&&  mv /usr/local/tt-rss/themes.local /usr/local/tt-rss/defaults/themes.local \
# install mercury_fulltext
&&  git clone https://github.com/HenryQW/mercury_fulltext.git /usr/local/tt-rss/defaults/plugins.local/mercury_fulltext     \
# install feediron
&&  git clone https://github.com/feediron/ttrss_plugin-feediron.git  /usr/local/tt-rss/defaults/plugins.local/feediron      \
# install fever
&&  git clone https://github.com/DigitalDJ/tinytinyrss-fever-plugin /usr/local/tt-rss/defaults/plugins.local/fever     \
# install themes
# install tt-rss-feedly-theme
&&  git clone  https://github.com/levito/tt-rss-feedly-theme.git /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme     \
&&  cp -r /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme/feedly* /usr/local/tt-rss/defaults/themes.local     \
#clean
&&  apk del build-base  \
&&  rm -rf /var/cache/apk/*   \
&&  rm /s6-overlay-${s6_arch}.tar.gz   \
&&  rm -rf /scws*   \
&&  rm -rf /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme

VOLUME  /config
EXPOSE 80 3000 5432
ENTRYPOINT [ "/init" ]
