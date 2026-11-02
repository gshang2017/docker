FROM alpine:3.24 AS mercury-parser-api-build

RUN apk update \
&& apk upgrade \
&& apk add --no-cache git python3 make gcc g++ npm nodejs \
# install mercury-parser-api
&& git clone --depth 1 https://github.com/HenryQW/mercury-parser-api.git /usr/local/mercury-parser-api \
&& cd /usr/local/mercury-parser-api \
&& npm install --omit=dev \
&& sed -i 's/env.PORT/env.MERCURY_PORT/' /usr/local/mercury-parser-api/config.js \
# install OpenCC.henry.wang
&& git clone --depth 1 https://github.com/HenryQW/OpenCC.henry.wang.git /usr/local/OpenCC.henry.wang \
&& cd /usr/local/OpenCC.henry.wang \
&& sed -i 's/1.1.3/1.2.0/' package.json \
&& npm install --omit=dev \
&& sed -i 's/env.PORT/env.OPENCC_PORT/' /usr/local/OpenCC.henry.wang/bin/www \
&& sed -i 's/3000/4000/' /usr/local/OpenCC.henry.wang/bin/www

FROM ghcr.io/gshang2017/postgres:latest

ARG S6_VER=3.2.3.2
ARG TTRSS_VER=26.10-c02520ff
ARG GIT_COMMIT_SHA=c02520ff1c26a0aab0c81ada1f42d377f02ac29c

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
ENV TTRSS_PHP_EXECUTABLE=/usr/bin/php85
ENV TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext,af_readability
ENV SCRIPT_ROOT=/usr/local/tt-rss/app
ENV TZ=Asia/Shanghai
ENV TTRSS_ALLOW_PORTS=80,443
ENV TTRSS_ALLOW_LOCAL_IP=false
ENV TTRSS_UPDATE_AUTO=true
ENV TTRSS_CADDY_PORT=80
ENV ENABLE_MERCURY=true
ENV MERCURY_PORT=3000
ENV ENABLE_OPENCC=false
ENV OPENCC_PORT=4000
ENV PGPORT=5432
ENV PHP_LISTEN_PORT=9000
ENV POSTGRES_DB_DUMP=false
ENV POSTGRES_DB_RESTORE=false
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /
COPY --from=mercury-parser-api-build --chmod=755 /usr/local/mercury-parser-api /usr/local/mercury-parser-api
COPY --from=mercury-parser-api-build --chmod=755 /usr/local/OpenCC.henry.wang /usr/local/OpenCC.henry.wang

# install php tt-rss caddy
RUN apk add --no-cache bash shadow tzdata git ca-certificates caddy dumb-init postgresql-client musl-locales \
						php85 php85-fpm php85-phar php85-sockets php85-pecl-apcu php85-pdo php85-gd php85-pgsql php85-pdo_pgsql php85-xmlwriter \
						php85-mbstring php85-intl php85-xml php85-curl php85-simplexml php85-session php85-tokenizer php85-dom php85-fileinfo php85-ctype \
						php85-json php85-iconv php85-pcntl php85-posix php85-zip php85-exif php85-openssl php85-pecl-xdebug php85-sockets php85-sodium python3 nodejs \
&& apk add --no-cache --virtual ttrssdep clang21 llvm21 build-base automake autoconf libtool \
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
# install zhparser
&& git clone --depth 1 https://github.com/hightman/scws.git \
&& cd scws \
&& sed -i '/#unison.*/d' Makefile.am \
&& touch README;aclocal;autoconf;autoheader;libtoolize;automake --add-missing \
&& ./configure \
&& make install -j $(nproc) \
&& git clone --depth 1 https://github.com/amutu/zhparser.git \
&& cd zhparser \
&& make install -j $(nproc) \
#create ttrss user
&& useradd -u 1000 -U -d /config -s /bin/false ttrss \
&& usermod -G users ttrss \
# php
&& sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php85/php.ini \
&& sed -i -e 's/;\(clear_env\) = .*/\1 = no/i' /etc/php85/php-fpm.d/www.conf \
&& sed -i -e 's/^\(user\|group\) = .*/\1 = postgres/i' /etc/php85/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_value\[error_log\]\) = .*/\1 = \/var\/log\/php85\/error.log/' /etc/php85/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_flag\[log_errors\]\) = .*/\1 = on/' /etc/php85/php-fpm.d/www.conf \
# reset ttrss
&& git clone --depth 50 https://github.com/tt-rss/tt-rss.git /usr/local/tt-rss/app \
&& cd /usr/local/tt-rss/app \
&& git reset --hard ${GIT_COMMIT_SHA} \
# install  plugins
&& mkdir -p /usr/local/tt-rss/defaults \
&& mv /usr/local/tt-rss/app/cache /usr/local/tt-rss/defaults/cache \
&& mv /usr/local/tt-rss/app/lock /usr/local/tt-rss/defaults/lock \
&& mv /usr/local/tt-rss/app/plugins.local /usr/local/tt-rss/defaults/plugins.local \
&& mv /usr/local/tt-rss/app/templates.local /usr/local/tt-rss/defaults/templates.local \
&& mv /usr/local/tt-rss/app/themes.local /usr/local/tt-rss/defaults/themes.local \
# install mercury_fulltext
&& git clone --depth 1 https://github.com/HenryQW/mercury_fulltext.git /usr/local/tt-rss/defaults/plugins.local/mercury_fulltext \
# install feediron
&& git clone --depth 1 https://github.com/feediron/ttrss_plugin-feediron.git  /usr/local/tt-rss/defaults/plugins.local/feediron \
# install fever
&& git clone --depth 1 https://github.com/DigitalDJ/tinytinyrss-fever-plugin /usr/local/tt-rss/defaults/plugins.local/fever \
# install af-readability
&& git clone --depth 1 https://github.com/tt-rss/tt-rss-plugin-af-readability.git /usr/local/tt-rss/defaults/plugins.local/af_readability \
# install opencc
&& git clone --depth 1 https://github.com/HenryQW/ttrss_opencc.git /usr/local/tt-rss/defaults/plugins.local/opencc \
# install freshapi
&& git clone --depth 1 https://github.com/eric-pierce/freshapi.git /usr/local/tt-rss/defaults/plugins.local/freshapi \
# add safe.directory
&& git config --global --add safe.directory /usr/local/tt-rss/app \
&& git config --global --add safe.directory /config/plugins.local/mercury_fulltext \
&& git config --global --add safe.directory /config/plugins.local/feediron \
&& git config --global --add safe.directory /config/plugins.local/fever \
&& git config --global --add safe.directory /config/plugins.local/af_readability \
&& git config --global --add safe.directory /config/plugins.local/opencc \
&& git config --global --add safe.directory /config/plugins.local/freshapi \
#clear
&& apk del ttrssdep \
&& rm -rf /var/cache/apk/* /tmp/* /scws*

VOLUME /config
EXPOSE 80 3000 4000 5432
ENTRYPOINT [ "/init" ]
