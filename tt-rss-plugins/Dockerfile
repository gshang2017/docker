FROM ghcr.io/gshang2017/postgres:latest

ARG S6_VER=3.2.0.0
ARG TTRSS_VER=24.07-9d37158d
ARG GIT_COMMIT_SHA=9d37158d8c8cde3f7738b64ca7164cd5b56933c5

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
ENV TTRSS_PHP_EXECUTABLE=/usr/bin/php82
ENV TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext,af_readability
ENV SCRIPT_ROOT=/usr/local/tt-rss/app
ENV TZ=Asia/Shanghai
ENV TTRSS_ALLOW_PORTS=80,443
ENV TTRSS_UPDATE_AUTO=true
ENV POSTGRES_DB_DUMP=false
ENV POSTGRES_DB_RESTORE=false
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

# install php tt-rss caddy git [npm nodejs]-mercury-parser-api
RUN apk add --no-cache bash shadow tzdata git npm nodejs ca-certificates caddy dumb-init postgresql-client musl-locales \
	          php82 php82-fpm php82-pdo php82-gd php82-pgsql php82-pdo_pgsql php82-mbstring php82-intl php82-xml php82-curl php82-session php82-tokenizer \
						php82-dom php82-fileinfo php82-ctype php82-json php82-iconv php82-pcntl php82-posix php82-zip php82-exif php82-openssl php82-pecl-xdebug \
&& apk add --no-cache --virtual ttrssdep clang15 llvm15 build-base \
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
&& sed -i 's/\(memory_limit =\) 128M/\1 256M/' /etc/php82/php.ini \
&& sed -i -e 's/;\(clear_env\) = .*/\1 = no/i' /etc/php82/php-fpm.d/www.conf \
&& sed -i -e 's/^\(user\|group\) = .*/\1 = postgres/i' /etc/php82/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_value\[error_log\]\) = .*/\1 = \/var\/log\/php82\/error.log/' /etc/php82/php-fpm.d/www.conf \
&& sed -i -e 's/;\(php_admin_flag\[log_errors\]\) = .*/\1 = on/' /etc/php82/php-fpm.d/www.conf \
# reset ttrss
&& git clone --depth 50 https://git.tt-rss.org/fox/tt-rss.git /usr/local/tt-rss/app \
&& cd /usr/local/tt-rss/app \
&& git reset --hard ${GIT_COMMIT_SHA} \
# install  plugins
&& mkdir -p /usr/local/tt-rss/defaults \
&& mv /usr/local/tt-rss/app/cache /usr/local/tt-rss/defaults/cache \
&& mv /usr/local/tt-rss/app/feed-icons /usr/local/tt-rss/defaults/feed-icons \
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
&& git clone --depth 1 https://git.tt-rss.org/fox/ttrss-af-readability.git /usr/local/tt-rss/defaults/plugins.local/af_readability \
# install themes
# install tt-rss-feedly-theme
&& git clone -b dist --depth 1 https://github.com/levito/tt-rss-feedly-theme.git /usr/local/tt-rss/defaults/themes.local/tt-rss-feedly-theme \
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
