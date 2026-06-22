#!/bin/sh

dmesg -W | while read -r line; do
	if echo "$line" | grep "Bluetooth" | grep -q "hardware error"; then
			ps -ef |grep '/usr/lib/bluetooth/bluetoothd' |grep -v grep |awk '{print $1}'|xargs kill -9
			sleep 3
			ps -ef |grep '/usr/bin/blueman-manager' |grep -v grep |awk '{print $1}'|xargs kill -9
			sleep 3
	fi
done
