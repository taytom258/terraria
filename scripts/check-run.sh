#!/bin/bash

if $(lsof -i:7777 -t); then
	exit 0
else
	exit 1
fi