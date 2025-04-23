#!/bin/bash

vlatest="1.4.4.9"

podman build --format docker -t docker.io/taytom259/terraria:vanilla-$vlatest-dev .
podman push docker.io/taytom259/terraria:vanilla-$vlatest-dev

git add .
if [ -z "$1" ]
  then
    git commit -m "Scripted commit"
  else
    git commit -m "$1"
fi
git push

