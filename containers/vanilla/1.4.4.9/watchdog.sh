#!/bin/bash

sleep 3
terraPID=screen -ls | grep -oE "[0-9]+\.terra" | sed -e "s/\..*$//g"
trap 'touch /config/sigterm' TERM
until [ -e /config/sigterm ]; do sleep 1; done
rm /config/sigterm
screen -S terra -p 0 -X stuff "exit^M"
wait $terraPID
