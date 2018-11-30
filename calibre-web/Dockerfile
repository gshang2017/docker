FROM alpine:3.8  

COPY  root /

RUN apk add --no-cache bash  ca-certificates  py2-pip py2-lxml  imagemagick6 \
&&  wget  https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz  \
&&  tar -xvzf s6-overlay-amd64.tar.gz  \
&&  rm s6-overlay-amd64.tar.gz   \
&&  wget -P /tmp  https://github.com/janeczku/calibre-web/archive/master.zip  \
&&  unzip -d /tmp      /tmp/master.zip   \
&&  cp -rf  /tmp/calibre-web-master/*  /usr/local/calibre-web/  \ 
&&  pip  install  --no-cache-dir  -r /usr/local/calibre-web/requirements.txt  \ 
&&  mv /usr/lib/python2.7/lib2to3/tests/data/py3_test_grammar.py  /usr/lib/python2.7/lib2to3/tests/data/py3_test_grammar    \
&&  mv /usr/lib/python2.7/site-packages/jinja2/asyncsupport.py  /usr/lib/python2.7/site-packages/jinja2/asyncsupport   \
&&  mv /usr/lib/python2.7/site-packages/jinja2/asyncfilters.py /usr/lib/python2.7/site-packages/jinja2/asyncfilters   \
&&  python -m compileall /usr/lib/python2.7/    \
&&  find /usr/lib/python2.7/ -name "*.py"|xargs -i rm -rf {}    \
&&  find /usr/lib/python2.7/ -name "*.pyo"|xargs -i rm -rf {}    \
&&  mv /usr/lib/python2.7/lib2to3/tests/data/py3_test_grammar  /usr/lib/python2.7/lib2to3/tests/data/py3_test_grammar.py    \
&&  mv /usr/lib/python2.7/site-packages/jinja2/asyncsupport  /usr/lib/python2.7/site-packages/jinja2/asyncsupport.py    \
&&  mv /usr/lib/python2.7/site-packages/jinja2/asyncfilters  /usr/lib/python2.7/site-packages/jinja2/asyncfilters.py   \
&&  wget -P /tmp  http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz   \ 
&&  tar -zxvf   /tmp/kindlegen_linux_2.6_i386_v2_9.tar.gz  -C /tmp  \ 
&&  cp   /tmp/kindlegen   /usr/local/bin/  \ 
&&  rm -rf /var/cache/apk/*  \ 
&&  rm -rf /tmp/*

VOLUME /library  /config
EXPOSE 8083
ENTRYPOINT [ "/init" ]
