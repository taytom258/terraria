#!/bin/bash

if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig.default /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

chmod -R g+w /config

screen -mS terra ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt $@
