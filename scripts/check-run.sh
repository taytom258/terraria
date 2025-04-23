#!/bin/bash

lsof -i:$SERVER_PORT -t

if [[ $? -eq 0 ]]; then
	exit 0
else
	exit 1
fi