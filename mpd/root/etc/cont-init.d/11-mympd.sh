#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ $USER_ID -ne 0 ]; then
  if [ ! -d $HOME/mympd/cache ] ; then
    mkdir -p $HOME/mympd/cache
  fi

  if [ ! -d $HOME/mympd/lib ] ; then
    mkdir -p $HOME/mympd/lib
    mympd -c -w $HOME/mympd/lib -a $HOME/mympd/cache
    echo 3 > $HOME/mympd/lib/config/loglevel
  fi

  echo $MYMPD_HTTP > $HOME/mympd/lib/config/http
  echo $MYMPD_HTTP_PORT > $HOME/mympd/lib/config/http_port
  echo $MYMPD_SSL > $HOME/mympd/lib/config/ssl
  echo $MYMPD_SSL_PORT > $HOME/mympd/lib/config/ssl_port
  echo $MPD_PORT > $HOME/mympd/lib/state/mpd_port
  echo $HOME/music > $HOME/mympd/lib/state/music_directory
  echo $HOME/mpd/playlists > $HOME/mympd/lib/state/playlist_directory

  chown -R app:app $HOME/mympd
fi
