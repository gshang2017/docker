#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ ! -d /var/run/dbus ]; then
	mkdir -p /var/run/dbus
fi
if [ -e /var/run/dbus/system_bus_socket ]; then
	rm -f /var/run/dbus/system_bus_socket
fi
