#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ "$ENABLE_MPD_TEST" == "true" ] && [ -f $HOME/mpd/state  ]; then
  nohup bash -c 'until [ `mpc >/dev/null 2>&1; echo $?` -eq 0 ];do sleep 2;done && if [ $(cat $HOME/mpd/state |grep -m1 "sw_volume"|sed 's/[^0-9]//g') -ne $(echo "`mpc volume`"|sed 's/[^0-9]//g') ];then mpc volume $(cat $HOME/mpd/state |grep -m1 "sw_volume"|sed 's/[^0-9]//g') ; fi' >/dev/null 2>&1 &
fi
