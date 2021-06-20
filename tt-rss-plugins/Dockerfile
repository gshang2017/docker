FROM cthulhoo/ttrss-fpm-pgsql-static:21.05-92c78beb9  as ttrss-src
FROM postgres:12.0-alpine

ARG  S6_VER=2.2.0.3

ENV  POSTGRES_DB=ttrss
ENV  POSTGRES_USER=ttrss
ENV  POSTGRES_PASSWORD=ttrss
ENV  TTRSS_DB_NAME=ttrss
ENV  TTRSS_DB_USER=ttrss
ENV  TTRSS_DB_PASS=ttrss
ENV  TTRSS_DB_TYPE=pgsql
ENV  TTRSS_DB_PORT=5432
ENV  TTRSS_DB_HOST=0.0.0.0
ENV  TTRSS_SELF_URL_PATH=http://localhost:80/
ENV  TTRSS_PHP_EXECUTABLE=/usr/bin/php8
ENV  TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext

COPY  root  /
COPY --from=ttrss-src  /src/tt-rss  /usr/local/tt-rss

# install php tt-rss caddy git [npm nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow git npm nodejs ca-certificates caddy clang llvm10 build-base dumb-init postgresql-client \
	          php8 php8-fpm php8-pdo php8-gd php8-pgsql php8-pdo_pgsql php8-mbstring php8-intl php8-xml php8-curl php8-session \
	          php8-dom php8-fileinfo php8-json php8-iconv php8-pcntl php8-posix php8-zip php8-openssl php8-pecl-xdebug \
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
# php
&&  sed -i.bak 's/\(memory_limit =\) 128M/\1 256M/' /etc/php8/php.ini   \
&&  sed -i.bak 's/;clear_env = .*/clear_env = no/i' /etc/php8/php-fpm.d/www.conf   \
# install  plugins
&&  mkdir -p  /usr/local/tt-rss/defaults \
&&  mv /usr/local/tt-rss/cache /usr/local/tt-rss/defaults/cache \
&&  mv /usr/local/tt-rss/feed-icons /usr/local/tt-rss/defaults/feed-icons \
&&  mv /usr/local/tt-rss/lock /usr/local/tt-rss/defaults/lock \
&&  mv /usr/local/tt-rss/plugins.local /usr/local/tt-rss/defaults/plugins.local \
&&  mv /usr/local/tt-rss/templates.local /usr/local/tt-rss/defaults/templates.local \
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
&&  apk del clang llvm10 build-base  \
&&  rm -rf /var/cache/apk/*   \
&&  rm /s6-overlay-${s6_arch}.tar.gz   \
&&  rm -rf /scws*   \
&&  rm -rf /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme  \
&&  chmod a+x /usr/local/bin/initialize.sh

VOLUME  /config
EXPOSE 80 3000 5432
ENTRYPOINT [ "/init" ]
