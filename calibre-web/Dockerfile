FROM alpine:3.23

ARG S6_VER=3.2.3.0
ARG CALIBRE_WEB_VER=0.6.26
ARG CALIBRE_VER=8.16.2
ARG KEPUBIFY_VER=4.0.4
ARG UNRAR_VERSION=7.2.2

ENV UID=1000
ENV GID=1000
ENV ENABLE_AUTOADDBOOKS=true
ENV ENABLE_CALIBRE_SERVER=false
ENV ENABLE_CALIBRE_SERVER_OPDS=false
ENV ENABLE_CALIBREDB_URLLIBRARYPATH=true
ENV CALIBRE_SERVER_RESTART_AUTO=true
ENV CALIBRE_SERVER_USER=
ENV CALIBRE_SERVER_PASSWORD=
ENV CALIBRE_SERVER_WEB_LANGUAGE=zh_CN
ENV CALIBRE_SERVER_PORT=8080
ENV CALIBRE_PORT=8083
ENV CALIBRE_ASCII_FILENAME=true
ENV CALIBRE_WEB_LANGUAGE=zh_Hans_CN
ENV TZ=Asia/Shanghai
ENV CALIBREDB_OTHER_OPTION=
ENV DISABLE_GOOGLE_SEARCH=false
ENV DISABLE_SCHOLAR_SEARCH=false
ENV DISABLE_AMAZON_SEARCH=false
ENV DISABLE_COMICVINE_SEARCH=false
ENV DISABLE_DOUBAN_SEARCH=false
ENV DISABLE_LUBIMYCZYTAC_SEARCH=false
ENV ENABLE_CHOWN_LIBRARY=true
ENV LANG=C.UTF-8
ENV HOME=/home/calibre
ENV QTWEBENGINE_CHROMIUM_FLAGS=--no-sandbox
ENV CALIBRE_DBPATH=/config/calibre-web
ENV CALIBRE_CONFIG_DIRECTORY=/config/calibre-server
ENV CALIBRE_LOCALHOST=true
ENV CALIBRE_RECONNECT=true
ENV ENABLE_FIX_COVER_COLOR=false
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY --chmod=755 root /

RUN apk upgrade \
&& apk add --no-cache \
  bash \
  ca-certificates \
  shadow \
  tzdata \
  python3 \
  expect \
  ttf-dejavu \
  inotify-tools \
  libldap \
  sqlite \
  xdg-utils \
  font-wqy-zenhei \
  poppler-data \
  jq \
  libstemmer \
  imagemagick \
  py3-gpep517 \
  py3-wheel \
  py3-pip \
  py3-cryptography \
  py3-gevent \
&& pip3 install --no-cache-dir setuptools==82.0.1 --break-system-packages \
#install calibre
&& apk add --no-cache \
  font-liberation \
  libjpeg-turbo-utils \
  libwmf \
  mtdev \
  optipng \
  poppler \
  py3-beautifulsoup4 \
  py3-css-parser \
  py3-cssselect \
  py3-dateutil \
  py3-dnspython \
  py3-feedparser \
  py3-fonttools \
  py3-html2text \
  py3-html5lib \
  py3-jeepney \
  py3-lxml \
  py3-markdown \
  py3-mechanize \
  py3-msgpack \
  py3-netifaces \
  py3-pillow \
  py3-psutil \
  py3-pycryptodome \
  py3-pygments \
  py3-pyqt6-webengine \
  py3-regex \
  py3-xxhash \
  py3-zeroconf \
  qt6-qtimageformats \
  qt6-qtsvg \
  qt6-qtwebengine \
  qt6-qtbase-private-dev \
  udisks2 \
  podofo \
  espeak-ng \
  py3-chardet \
#calibre calibre-web build dep
&& apk add --no-cache --virtual builddep \
  cmake \
  curl \
  ffmpeg-dev \
  hunspell-dev \
  hyphen-dev \
  libmtp-dev \
  libstemmer-dev \
  libusb-dev \
  py3-pyqt-builder \
  py3-pyqt6-sip \
  py3-qt6 \
  py3-sip \
  python3-dev \
  qt6-qtbase-dev \
  uchardet-dev \
  xdg-utils \
  podofo-dev \
  espeak-ng-dev \
  build-base \
  rust \
  cargo \
  libffi-dev \
  git \
  openldap-dev \
  libxml2-dev \
  libxslt-dev \
  libjpeg-turbo-dev \
  libevent-dev \
  file \
  cython \
  openssl-dev \
  linux-headers \
&& pip3 install --no-cache-dir apsw html5-parser --break-system-packages \
&& mkdir /tmp/calibre \
&& wget -P /tmp https://download.calibre-ebook.com/${CALIBRE_VER}/calibre-${CALIBRE_VER}.tar.xz \
&& tar -xJf /tmp/calibre-${CALIBRE_VER}.tar.xz -C /tmp/calibre --strip-components=1 \
&& cd /tmp/calibre \
&& wget https://github.com/alpinelinux/aports/raw/refs/tags/v20251224/testing/calibre/0003-calibre-disable-piper.patch \
&& patch -p1 < 0003-calibre-disable-piper.patch \
#支持中文路径patch
&& echo -e "\nimport re\r#https://github.com/snomiao/calibre-utf8-path\r# 定义文件名转换函数\rdef re_filename(filename):\r    if len(filename) > 80:\r       filename = filename[0:80]\r# 替换为空\r    return re.sub(r\"[\/\\\\\\\\\\:\*\?\\\"\<\>\|\\\\0]\", \"\", filename)\r"   >> src/calibre/db/backend.py \
&& sed -i s/"author = ascii_filename(author"/"    author = ascii_filename(author"/g   src/calibre/db/backend.py \
&& sed -i s/"title  = ascii_filename(title"/"    title  = ascii_filename(title"/g   src/calibre/db/backend.py \
&& sed -i "/author = ascii_filename(author/i\        ascii_filename_set = os.environ.get('CALIBRE_ASCII_FILENAME', 'true')" src/calibre/db/backend.py \
&& sed -i "/author = ascii_filename(author/i\        if ascii_filename_set == 'false':" src/calibre/db/backend.py \
&& sed -i "/author = ascii_filename(author/i\            author = re_filename(author)[:l]" src/calibre/db/backend.py \
&& sed -i "/author = ascii_filename(author/i\            title  = re_filename(title.lstrip())[:l].rstrip()" src/calibre/db/backend.py \
&& sed -i "/author = ascii_filename(author/i\        else:" src/calibre/db/backend.py \
&& python3 setup.py build \
&& python3 setup.py iso639 \
&& python3 setup.py iso3166 \
&& python3 setup.py liberation_fonts --system-liberation_fonts --path-to-liberation_fonts /usr/share/fonts/liberation \
&& python3 setup.py mathjax \
&& python3 setup.py gui \
&& python3 setup.py install --prefix=/usr/local \
#install unrar
&& mkdir /tmp/unrar \
&& wget -P /tmp https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz \
&& tar xf /tmp/unrarsrc-${UNRAR_VERSION}.tar.gz -C /tmp/unrar --strip-components=1 \
&& cd /tmp/unrar \
&& sed -i 's|LDFLAGS=-pthread|LDFLAGS=-pthread -static|' makefile \
&& sed -i 's|CXXFLAGS=-march=native |CXXFLAGS=|' makefile \
&& make -j $(nproc) \
&& install -v -m755 unrar /usr/bin \
&& /usr/bin/unrar \
#install s6-overlay
&& if [ "$(uname -m)" = "x86_64" ];then s6_arch=x86_64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;elif [ "$(uname -m)" = "armv7l" ];then s6_arch=arm; fi \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-${s6_arch}.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-noarch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz \
&& wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-symlinks-arch.tar.xz \
&& tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz \
#install calibre-web
&& wget -P /tmp https://github.com/janeczku/calibre-web/archive/refs/tags/${CALIBRE_WEB_VER}.tar.gz \
&& mkdir -p /usr/local/calibre-web/app \
&& tar xf /tmp/${CALIBRE_WEB_VER}.tar.gz -C /usr/local/calibre-web/app --strip-components=1 \
#install calibre-web dep
&& sed -i '/^lxml/d' /usr/local/calibre-web/app/requirements.txt \
&& pip3 install --no-cache-dir -r /usr/local/calibre-web/app/requirements.txt --break-system-packages \
&& pip3 install --no-cache-dir selenium==4.36.0 --break-system-packages \
&& pip3 install --no-cache-dir -r /usr/local/calibre-web/app/optional-requirements.txt --break-system-packages \
#install kepubify
&& if [ "$(uname -m)" = "x86_64" ];then kepubify_arch=64bit;elif [ "$(uname -m)" = "aarch64" ];then kepubify_arch=arm64;elif [ "$(uname -m)" = "armv7l" ];then kepubify_arch=arm;  fi \
&& wget https://github.com/pgaskin/kepubify/releases/download/v${KEPUBIFY_VER}/kepubify-linux-${kepubify_arch} -O /usr/local/bin/kepubify \
&& chmod 755 /usr/local/bin/kepubify \
#create calibre user
&& mkdir -p /home/calibre \
&& useradd -u 1000 -U -d /home/calibre -s /bin/false calibre \
&& usermod -G users calibre \
&& chown -R calibre:calibre /usr/local/calibre-web \
#clear
&& apk del builddep \
&& rm -rf /var/cache/apk/* /tmp/* /home/calibre/.c*

VOLUME /library /config /autoaddbooks
EXPOSE 8080 8083
ENTRYPOINT [ "/init" ]
