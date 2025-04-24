#!/bin/bash

git add .
if [ -z "$1" ]
  then
    git commit -m "Scripted commit"
  else
    git commit -m "$1"
fi
git push

