#!/bin/bash

if [[ lsof -nP -iTCP:$PORT -sTCP:LISTEN ]]; then
	exit 0
else
	exit 1
fi