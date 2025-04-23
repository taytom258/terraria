#!/bin/bash

if $(lsof -i:$SERVER_PORT -t); then
	exit 0
else
	exit 1
fi