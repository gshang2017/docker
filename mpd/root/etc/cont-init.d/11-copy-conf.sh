#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ ! -d $HOME/conf ]; then
	mkdir -p $HOME/conf
fi
if [ ! -f $HOME/conf/default.pa ]; then
	cp -f /etc/pulse/default.pa $HOME/conf/default.pa
fi
if [ ! -f $HOME/conf/main.conf ]; then
	cp -f /etc/bluetooth/main.conf $HOME/conf/main.conf
fi

chown -R app:app $HOME/conf
