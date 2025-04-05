#! /bin/bash

while inotifywait -e close -e move -r /autoaddbooks; do
    if [ "`ls -A /autoaddbooks`" != "" ]; then
      inotifywait -mr /autoaddbooks -t 30
      if [ "$ENABLE_CALIBRE_SERVER" == "true" ]; then
        if [ -n "$CALIBRE_SERVER_USER" ] && [ -n "$CALIBRE_SERVER_PASSWORD" ]; then
          calibredb add -r /autoaddbooks $CALIBREDB_OTHER_OPTION --username $CALIBRE_SERVER_USER --password $CALIBRE_SERVER_PASSWORD --library-path="http://localhost:$CALIBRE_SERVER_PORT/#library"
        else
          calibredb add -r /autoaddbooks $CALIBREDB_OTHER_OPTION --library-path="http://localhost:$CALIBRE_SERVER_PORT/#library"
        fi
      else
        calibredb add -r /autoaddbooks $CALIBREDB_OTHER_OPTION --library-path=/library
      fi
      rm -r /autoaddbooks/*
    fi
done
