FROM ubuntu:20.04  as compilinganki

ARG BAZELISK_VER=1.10.1
ARG ANKI_VER=2.1.43

RUN apt-get update -q -y \
&&  ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&&  echo Asia/Shanghai > /etc/timezone \
&&  apt-get install -q -y curl wget apt-utils git rsync findutils curl gcc g++ rustc cargo nodejs python3 python3-pip python3-pyqt5 pyqt5-dev-tools python-is-python3 \
#Build Anki
&&  if [ "$(uname -m)" = "x86_64" ];then bazelisk_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then bazelisk_arch=arm64;fi \
&&  curl -L https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VER}/bazelisk-linux-${bazelisk_arch} -o /usr/local/bin/bazel \
&&  chmod +x /usr/local/bin/bazel \
&&  mkdir /anki \
&&  wget -P /anki https://github.com/ankitects/anki/archive/refs/tags/${ANKI_VER}.tar.gz \
&&  tar -zxvf /anki/${ANKI_VER}.tar.gz --strip-components 1 -C /anki \
&&  cd anki \
&&  echo "build --action_env=PYTHON_SITE_PACKAGES=/usr/lib/python3/dist-packages" >> user.bazelrc \
&&  bazel build -k -c opt dist \
&&  cd /anki/bazel-bin \
&&  tar -xvf dist.tar

# docker anki-sync-server

FROM ubuntu:20.04

ARG ANKI__SYNC_SERVER=2.1.0
ARG S6_VER=2.2.0.3

ENV USER=
ENV PASSWORD=

COPY root /
COPY --from=compilinganki  /anki/bazel-bin/bazel-dist  /

RUN apt-get update -q -y \
&&  ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&&  echo Asia/Shanghai > /etc/timezone \
&&  apt-get install -q -y expect python3 python3-pip wget unzip nginx \
&&  pip install --no-cache-dir /anki*.whl \
#install anki-sync-server
&&  wget -P /tmp https://github.com/ankicommunity/anki-sync-server/archive/refs/heads/develop.zip \
&&  unzip -d /tmp /tmp/develop.zip \
&&  cp -rf /tmp/anki-sync-server-develop/*  /usr/local/anki-sync-server \
&&  sed -i 's/anki==*.*.*;/anki;/g'  /usr/local/anki-sync-server/src/requirements.txt \
&&  pip install --no-cache-dir -r /usr/local/anki-sync-server/src/requirements.txt \
#install s6-overlay
&&  if [ "$(uname -m)" = "x86_64" ];then s6_arch=amd64;elif [ "$(uname -m)" = "aarch64" ];then s6_arch=aarch64;fi \
&&  wget -P /tmp https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-${s6_arch}-installer \
&&  chmod +x /tmp/s6-overlay-${s6_arch}-installer \
&&  /tmp/s6-overlay-${s6_arch}-installer / \
#defaults ankisyncd.conf
&&  mkdir -p /usr/local/anki-sync-server/defaults \
&&  mv /usr/local/anki-sync-server/src/ankisyncd.conf /usr/local/anki-sync-server/defaults/ankisyncd.conf \
&&  sed -i 's/\.\//\/config\//g' /usr/local/anki-sync-server/defaults/ankisyncd.conf \
&&  sed -i 's/27701/27702/g' /usr/local/anki-sync-server/defaults/ankisyncd.conf \
#defaults nginx.conf
&&  cp -rf /usr/local/anki-sync-server/docs/nginx.conf /usr/local/anki-sync-server/defaults/nginx.conf \
&&  sed -i 's/2048m/0/g' /usr/local/anki-sync-server/defaults/nginx.conf \
&&  sed -i 's/default;/localhost;/g' /usr/local/anki-sync-server/defaults/nginx.conf \
#ankisyncd路径
&&  echo "/usr/local/anki-sync-server/src/" >  /usr/local/lib/python3.8/dist-packages/ankisyncd.pth \
#
&&  chmod a+x /usr/local/anki-sync-server/useradd.sh \
#clear
&&  apt-get clean \
&&  rm -rf /*.whl \
&&  rm -rf /tmp/*

VOLUME  /config
EXPOSE 27701
ENTRYPOINT [ "/init" ]
