#!/bin/bash

vlatest="1.4.4.9"
rootdir=/home/ttomlin/development/terraria.container/
branch=$(git branch --show-current)


if [ "$branch" == "main" ]; then
	cd $rootdir/containers/vanilla/1.4.4.9
	podman build -t "taytom259/terraria:vanilla-1.4.4.9" .


	podman tag "taytom259/terraria:vanilla-$vlatest" \
		taytom259/terraria:vanilla-latest
	podman tag "taytom259/terraria:vanilla-$vlatest" \
		taytom259/terraria:latest

	podman push docker.io/taytom259/terraria:vanilla-$vlatest
	podman push docker.io/taytom259/terraria:vanilla-latest
	podman push docker.io/taytom259/terraria:latest
elif [ "$branch" == "dev" ]; then
	cd $rootdir/containers/vanilla/1.4.4.9
	podman build -t "taytom259/terraria:vanilla-1.4.4.9-dev" .


	podman push docker.io/taytom259/terraria:vanilla-$vlatest-dev
fi

cd $rootdir

git add .
if [ -z "$1" ]
  then
    git commit -m "Scripted commit"
  else
    git commit -m "$1"
fi
git push

