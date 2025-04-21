#!/bin/bash

vlatest="1.4.4.9"
rootdir=/home/ttomlin/development/terraria.container/

cd $rootdir/containers/vanilla/1.4.4.9
podman build -t "taytom259/terraria:vanilla-1.4.4.9" .

podman tag "taytom259/terraria:vanilla-$vlatest" taytom259/terraria:vanilla-latest
podman tag "taytom259/terraria:vanilla-$vlatest" taytom259/terraria:latest
podman push taytom259/terraria:vanilla-1.4.4.9
podman push taytom259/terraria:vanilla-latest
podman push taytom259/terraria:latest

cd $rootdir

git add .
if [ -z "$1" ]
  then
    git commit -m "Scripted Commit"
  else
    git commit -m "$1"
fi
git push

