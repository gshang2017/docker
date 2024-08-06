#! /bin/sh

if [ "$ENABLE_CALIBRE_SERVER" == "true" ] && [ "$CALIBRE_SERVER_RESTART_AUTO" == "true" ]; then
  #kill calibre-server
  if [ `ps -ef |grep /opt/calibre/bin/calibre-server |grep -v grep |wc -l` -ne 0 ]; then
    ps -ef |grep  /opt/calibre/bin/calibre-server |grep -v grep |awk '{print $1}'|xargs kill -9
  fi
fi
