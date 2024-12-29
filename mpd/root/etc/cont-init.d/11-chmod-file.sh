#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

find /etc/services.d -name "*.dep" -type f -exec chmod 644 {} \;
chmod 644 /etc/services.d/bluez/respawn
chmod 644 /etc/services.d/dbus/respawn
chmod 644 /etc/services.d/mpd/respawn
chmod 644 /etc/services.d/mpdidle/respawn
chmod 644 /etc/services.d/mpdris2/respawn
chmod 644 /etc/services.d/mpris/respawn
chmod 644 /etc/services.d/mympd/respawn
