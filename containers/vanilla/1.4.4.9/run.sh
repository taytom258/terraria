#!/bin/bash

EffUID="$(id -u)"

if [ $EffUID -eq 0 ]; then
	useradd -m -s /bin/bash -k /etc/ske1/ -u $PUID terraria
	chown -R terraria:terraria /opt/terraria /config
	exec su terraria "$0" -- "$@"
else
	echo "Effective startup permissions are not root. Unable to setup proper permissions."
	exit 1
fi

if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig.default /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

screen -mS terra ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt $@
