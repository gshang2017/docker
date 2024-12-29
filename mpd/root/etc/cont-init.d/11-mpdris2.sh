#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ ! -d $HOME/mpdris2 ]; then
	mkdir -p $HOME/mpdris2
fi
if [ ! -f $HOME/mpdris2/mpDris2.conf ]; then
	cp -f /usr/share/doc/mpdris2/mpDris2.conf $HOME/mpdris2/mpDris2.conf
fi
chown -R app:app $HOME/mpdris2
