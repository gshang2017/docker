#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error

if [ "$ENABLE_MAX_DEFAULT_SINK_VOLUME" == "true" ]; then
  #default volume 100
  nohup bash -c 'until [ `wpctl settings >/dev/null 2>&1; echo $?` -eq 0 ];do sleep 2;done && wpctl settings device.routes.default-sink-volume 1.0' >/dev/null 2>&1 &
fi

# vim:ft=sh:ts=4:sw=4:et:sts=4
