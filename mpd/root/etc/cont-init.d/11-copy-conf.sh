#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

#bluetooth
if [ ! -d $HOME/bluetoothconf ]; then
	mkdir -p $HOME/bluetoothconf
fi
if [ "$ENABLE_BLUETOOTH_CUSTOM_CONFIG" == "true" ] && [ ! -L "/etc/bluetooth/main.conf" ]; then
  rm -f /etc/bluetooth/main.conf
	if [ ! -f $HOME/bluetoothconf/main.conf ]; then
		cp -f /etc/bluetooth/main.conf.bak $HOME/bluetoothconf/main.conf
	fi
	ln -s $HOME/bluetoothconf/main.conf /etc/bluetooth/
fi
if [ "$ENABLE_BLUETOOTH_CUSTOM_CONFIG" == "false" ]; then
	if [ -L "/etc/bluetooth/main.conf" ]; then
		cp -f /etc/bluetooth/main.conf.bak /etc/bluetooth/main.conf
	fi
fi

#pipewire
if [ "$ENABLE_PIPEWIRE_CUSTOM_CONFIG" == "true" ] && [ ! -f $HOME/.config/pipewire/pipewire.conf ]; then
	mkdir -p $HOME/.config/pipewire
	cp -f /usr/share/pipewire/*.conf $HOME/.config/pipewire
fi
if [ "$ENABLE_PIPEWIRE_CUSTOM_CONFIG" == "false" ]; then
	if [ -d $HOME/.config/pipewire ]; then
		rm -rf $HOME/.config/pipewire
	fi
fi

#wireplumber
if [ "$ENABLE_WIREPLUMBER_CUSTOM_CONFIG" == "true" ] && [ ! -f $XDG_CONFIG_HOME/wireplumber/wireplumber.conf ]; then
	mkdir -p $XDG_CONFIG_HOME/wireplumber
	cp -f /usr/share/wireplumber/wireplumber.conf $XDG_CONFIG_HOME/wireplumber
fi
if [ "$ENABLE_WIREPLUMBER_CUSTOM_CONFIG" == "true" ] && [ ! -f $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/bluetooth.conf ]; then
	mkdir -p $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d
	cp -f /usr/share/doc/wireplumber/examples/wireplumber.conf.d/bluetooth.conf $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d
fi
if [ "$ENABLE_WIREPLUMBER_CUSTOM_CONFIG" == "false" ]; then
	if [ -d $XDG_CONFIG_HOME/wireplumber ]; then
		rm -rf $XDG_CONFIG_HOME/wireplumber
	fi
fi

chown -R app:app $HOME/bluetoothconf $HOME/.config
