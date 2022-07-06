FROM cthulhoo/ttrss-fpm-pgsql-static:22.06-b148d2f51 as ttrss-src
FROM postgres:14.1-alpine

ARG S6_VER=2.2.0.3

ENV UID=1000
ENV GID=1000
ENV POSTGRES_DB=ttrss
ENV POSTGRES_USER=ttrss
ENV POSTGRES_PASSWORD=ttrss
ENV TTRSS_DB_NAME=ttrss
ENV TTRSS_DB_USER=ttrss
ENV TTRSS_DB_PASS=ttrss
ENV TTRSS_DB_TYPE=pgsql
ENV TTRSS_DB_PORT=5432
ENV TTRSS_DB_HOST=0.0.0.0
ENV TTRSS_SELF_URL_PATH=http://localhost:80/
ENV TTRSS_PHP_EXECUTABLE=/usr/bin/php8
ENV TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext
ENV SCRIPT_ROOT=/usr/local/tt-rss/app
ENV TZ=Asia/Shanghai
ENV TTRSS_ALLOW_PORTS=80,443
ENV TTRSS_UPDATE_AUTO=true
ENV POSTGRES_DB_DUMP=false
ENV POSTGRES_DB_RESTORE=false

COPY root /
COPY --from=ttrss-src /src/tt-rss /usr/local/tt-rss/app

# install php tt-rss caddy git [npm nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow tzdata git npm nodejs ca-certificates caddy clang llvm13 build-base dumb-init postgresql-client \
	          php8 php8-fpm php8-pdo php8-gd php8-pgsql php8-pdo_pgsql php8-mbstring php8-intl php8-xml php8-curl php8-session \
						php8-tokenizer php8-dom php8-fileinfo php8-json php8-iconv php8-pcntl php8-posix php8-zip php8-exif php8-openssl php8-pecl-xdebug \
#gd-png: libpng warning
&& apk add --no-cache php8-gd=8.0.13-r0 --repository https://dl-cdn.alpinelinux.org/alpine/v3.14/community \
# install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget --no-check-certificate https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.gz \
&& tar -xvzf s6-overlay-${s6_arch}.tar.gz \
# install mercury-parser-api
&& npm install --prefix /usr/local/mercury-parser-api git+https://github.com/HenryQW/mercury-parser-api.git \
# install zhparser
&& wget http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2 \
&& tar -xf scws-1.2.3.tar.bz2 \
&& cd scws-1.2.3 \
&& ./configure \
&& make install \
&& git clone --depth 1 https://github.com/amutu/zhparser.git \
&& cd zhparser \
&& make install \
#create ttrss user
&& useradd -u 1000 -U -d /config -s /bin/false ttrss \
&& usermod -G users ttrss \
# php
&& sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php8/php.ini \
&& sed -i -e 's/;\(clear_env\) = .*/\1 = no/i' /etc/php8/php-fpm.d/www.conf \
&& sed -i -e 's/^\(user\|group\) = .*/\1 = postgres/i' /etc/php8/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_value\[error_log\]\) = .*/\1 = \/var\/log\/php8\/error.log/' /etc/php8/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_flag\[log_errors\]\) = .*/\1 = on/' /etc/php8/php-fpm.d/www.conf \
# install  plugins
&& mkdir -p /usr/local/tt-rss/defaults \
&& mv /usr/local/tt-rss/app/cache /usr/local/tt-rss/defaults/cache \
&& mv /usr/local/tt-rss/app/feed-icons /usr/local/tt-rss/defaults/feed-icons \
&& mv /usr/local/tt-rss/app/lock /usr/local/tt-rss/defaults/lock \
&& mv /usr/local/tt-rss/app/plugins.local /usr/local/tt-rss/defaults/plugins.local \
&& mv /usr/local/tt-rss/app/templates.local /usr/local/tt-rss/defaults/templates.local \
&& mv /usr/local/tt-rss/app/themes.local /usr/local/tt-rss/defaults/themes.local \
# del nginx_xaccel
&& if [ -d "/usr/local/tt-rss/defaults/plugins.local/nginx_xaccel" ];then rm -rf /usr/local/tt-rss/defaults/plugins.local/nginx_xaccel; fi \
# install mercury_fulltext
&& git clone --depth 1 https://github.com/HenryQW/mercury_fulltext.git /usr/local/tt-rss/defaults/plugins.local/mercury_fulltext \
# install feediron
&& git clone --depth 1 https://github.com/feediron/ttrss_plugin-feediron.git  /usr/local/tt-rss/defaults/plugins.local/feediron \
# install fever
&& git clone --depth 1 https://github.com/DigitalDJ/tinytinyrss-fever-plugin /usr/local/tt-rss/defaults/plugins.local/fever \
# install themes
# install tt-rss-feedly-theme
&& git clone --depth 1 https://github.com/levito/tt-rss-feedly-theme.git /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme \
# add safe.directory
&& git config --global --add safe.directory /usr/local/tt-rss/app \
&& git config --global --add safe.directory /config/plugins.local/mercury_fulltext \
&& git config --global --add safe.directory /config/plugins.local/feediron \
&& git config --global --add safe.directory /config/plugins.local/fever \
&& git config --global --add safe.directory /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme \
#clear
&& apk del clang llvm13 build-base \
&& rm -rf /var/cache/apk/* \
&& rm /s6-overlay-${s6_arch}.tar.gz \
&& rm -rf /scws* \
&& chmod a+x /usr/local/bin/initialize.sh \
&& chmod a+x /usr/local/tt-rss/defaults/updatett-rss.sh \
&& chmod a+x /usr/local/tt-rss/defaults/postgres-dump-restore.sh

VOLUME /config
EXPOSE 80 3000 5432
ENTRYPOINT [ "/init" ]
