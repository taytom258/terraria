#!/bin/bash

date=`date +"%Y-%m-%d-%H%M"`
serverARGS="$@"
serverURL="https://terraria.org/api/download/pc-dedicated-server/terraria-server-'$VERSION'.zip"

if [ "$(id -u)" = 0 ]; then
	runAsUser=terraria
	runAsGroup=terraria

	if [[ -v PUID ]]; then
		if [[ $PUID != 0 ]]; then
			if [[ $PUID != $(id -u terraria) ]]; then
				usermod -u $PUID terraria
			fi
		else
			runAsUser=root
		fi
	fi

	if [[ -v PGID ]]; then
		if [[ $PGID != 0 ]]; then
			if [[ $PGID != $(id -g terraria) ]]; then
				groupmod -o -g "$PGID" terraria
			fi
		else
			runAsGroup=root
		fi
	fi
	
	if [[ ! -e /opt/terraria/$VERSION.ver ]]; then
		if [[ '$VERSION' == '1061' || '$VERSION' == '112' ]]; then
			serverURL="https://terraria.org/extra/terraria-server-'$VERSION'.zip"
		fi
		rm -rf /opt/terraria/server/*
		wget -O /tmp/terraria/server.zip $serverURL
		unzip -q -d /tmp/terraria/ /tmp/terraria/server.zip && \
		cp -r /tmp/terraria/$VERSION/Linux/* /opt/terraria/server/ && \
		cp /tmp/terraria/$VERSION/Windows/serverconfig.txt /opt/terraria/server/serverconfig.default && \
		sed -in '/#maxplayers=.*/c\maxplayers=16' /opt/terraria/server/serverconfig.default && \
		sed -in '/#port=.*/c\port=7777' /opt/terraria/server/serverconfig.default && \
		sed -in '/#worldpath=.*/c\worldpath=/config/' /opt/terraria/server/serverconfig.default && \
		rm -rf /tmp/* /opt/terraria/server/*.defaultn
		touch /opt/terraria/$VERSION.ver
	fi

	if [ ! -f "/config/serverconfig.txt" ]; then
		cp ./serverconfig.default /config/serverconfig.txt
	fi

	if [ ! -f "/config/banlist.txt" ]; then
		touch /config/banlist.txt
	fi

	if [ -n "$WORLD" ]; then
		serverARGS="-world /config/$WORLD $@"
	fi

	chown -R ${runAsUser}:${runAsGroup} /config /opt/terraria
	chmod +x /opt/terraria/server/TerrariaServer*
	chmod -R g+w /config

	if [ -z "$WORLD" ]; then
		su -c "screen -mS terra -L -Logfile /config/server.'$date'.log ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt '$serverARGS'" ${runAsUser}
	else
		su -c "screen -dmS terra -L -Logfile /config/server.'$date'.log ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt '$serverARGS'" ${runAsUser}

		trap "touch /root/sigterm" SIGTERM
		while [ ! -e /root/sigterm ]; do sleep 1; done
		su -c 'screen -S terra -p 0 -X stuff 'exit^M'' terraria
		echo 'SIGTERM Caught'
		rm -f /root/sigterm
		sleep 2
	fi
	exit 0

else
	echo "Setup permission not root! Please utilize ENV variables to set UID/GID."
	exit 1
fi