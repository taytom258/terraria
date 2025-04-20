#!/bin/bash

podman push taytom259/terraria:vanilla-latest
#podman push taytom259:tshock-latest

git add .
git commit -m "$1"
git push

