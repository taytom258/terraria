#!/bin/bash

vlatest="1.4.4.9"

if [[ "$(git branch --show-current)" == "dev" ]]; then
	podman build -t docker.io/taytom259/terraria:vanilla-$vlatest-dev .
	podman push docker.io/taytom259/terraria:vanilla-$vlatest-dev
else
	podman build -t docker.io/taytom259/terraria:vanilla-$vlatest .
	docker image tag docker.io/taytom259/terraria:vanilla-$vlatest docker.io/taytom259/terraria:latest
	docker image tag docker.io/taytom259/terraria:vanilla-$vlatest docker.io/taytom259/terraria:vanilla-latest

	podman push docker.io/taytom259/terraria:vanilla-$vlatest
	podman push docker.io/taytom259/terraria:vanilla-latest
	podman push docker.io/taytom259/terraria:latest
fi

git add .
if [ -z "$1" ]
  then
    git commit -m "Scripted commit"
  else
    git commit -m "$1"
fi
git push

