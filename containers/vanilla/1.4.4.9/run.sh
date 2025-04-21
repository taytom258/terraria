#!/bin/bash

serverARGS="$@"

if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig.default /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

if [ -n $WORLD  ]; then
	serverARGS="-world /config/$WORLD $@"
fi

screen -mS terra ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt "$serverARGS"
