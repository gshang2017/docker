FROM cthulhoo/ttrss-fpm-pgsql-static:22.11-292ca8666 as ttrss-src
FROM ghcr.io/gshang2017/postgres:latest

ARG S6_VER=3.1.2.1

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
ENV TTRSS_PHP_EXECUTABLE=/usr/bin/php81
ENV TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext
ENV SCRIPT_ROOT=/usr/local/tt-rss/app
ENV TZ=Asia/Shanghai
ENV TTRSS_ALLOW_PORTS=80,443
ENV TTRSS_UPDATE_AUTO=true
ENV POSTGRES_DB_DUMP=false
ENV POSTGRES_DB_RESTORE=false
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=ttrss-src --chmod=755 /src/tt-rss /usr/local/tt-rss/app

# install php tt-rss caddy git [npm nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow tzdata git npm nodejs ca-certificates caddy dumb-init postgresql-client musl-locales \
	          php81 php81-fpm php81-pdo php81-gd php81-pgsql php81-pdo_pgsql php81-mbstring php81-intl php81-xml php81-curl php81-session php81-tokenizer \
						php81-dom php81-fileinfo php81-ctype php81-json php81-iconv php81-pcntl php81-posix php81-zip php81-exif php81-openssl php81-pecl-xdebug \
&& apk add --no-cache --virtual ttrssdep clang llvm13 build-base \
# install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
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
&& sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php81/php.ini \
&& sed -i -e 's/;\(clear_env\) = .*/\1 = no/i' /etc/php81/php-fpm.d/www.conf \
&& sed -i -e 's/^\(user\|group\) = .*/\1 = postgres/i' /etc/php81/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_value\[error_log\]\) = .*/\1 = \/var\/log\/php81\/error.log/' /etc/php81/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_flag\[log_errors\]\) = .*/\1 = on/' /etc/php81/php-fpm.d/www.conf \
# reset ttrss
&& cd /usr/local/tt-rss/app \
&& git reset --hard HEAD \
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
&& apk del ttrssdep \
&& rm -rf /var/cache/apk/* /tmp/* /scws*

VOLUME /config
EXPOSE 80 3000 5432
ENTRYPOINT [ "/init" ]
