#!/bin/bash

if [ ! -f "/config/serverconfig.txt" ]; then
    cp ./serverconfig.default /config/serverconfig.txt
fi

if [ ! -f "/config/banlist.txt" ]; then
    touch /config/banlist.txt
fi

chmod -R g+w /config

trap 'touch /config/sigterm' SIGTERM

screen -dmS terra ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt $@

until [ -e /config/sigterm  ]; do sleep 1; done
rm /config/sigterm
screen -S terra -p 0 -X stuff "exit^M"
