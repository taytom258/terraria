#!/bin/bash


sleep 3
terraPID=screen -ls | awk '/\.terra\t/ {print strtonum($1)}'
trap 'touch /config/sigterm' TERM
until [ -e /config/sigterm ]; do sleep 1; done
rm /config/sigterm
screen -S terra -p 0 -X stuff "exit^M"
wait $terraPID

