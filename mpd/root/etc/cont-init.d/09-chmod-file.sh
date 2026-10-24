#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

find /etc/services.d -name "*.dep" -type f -exec chmod 644 {} \;
chmod 644 /etc/services.d/bluez/respawn
chmod 644 /etc/services.d/dbus-daemon/respawn
chmod 644 /etc/services.d/dmesg/respawn
chmod 644 /etc/services.d/mpd/respawn
chmod 644 /etc/services.d/mpdidle/respawn
chmod 644 /etc/services.d/mpdris2/respawn
chmod 644 /etc/services.d/mpris/respawn
chmod 644 /etc/services.d/mympd/respawn
chmod 644 /etc/services.d/pipewire/respawn
chmod 644 /etc/services.d/pipewire-pulse/respawn
chmod 644 /etc/services.d/wireplumber/respawn
chmod 644 /etc/cont-groups.d/pipewire/id
chmod 644 /etc/cont-groups.d/messagebus/id
chmod 644 /etc/cont-users.d/messagebus/id
chmod 644 /etc/cont-users.d/messagebus/gid
chmod 644 /etc/cont-users.d/messagebus/grps
chmod 644 /etc/cont-users.d/messagebus/allow_duplicate_id
chmod -R 755 /usr/local/mpd
