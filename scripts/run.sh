#!/bin/bash

date=`date +"%Y-%m-%d-%H%M"`
serverARGS="-config /data/config/serverconfig.txt -banlist /data/config/banlist.txt"
updateURL=https://terraria.org/api/get/dedicated-servers-names
serverURL=https://terraria.org/api/download/pc-dedicated-server

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
	
	HTTPCODE=$(curl -sI https://terraria.org | awk '/HTTP\/[0-9.]+/{print $2}')
	if [[ "$VERSION" == "latest" && $HTTPCODE -eq 200 ]]; then
		VERSION=$(curl -s $updateURL | grep -Po -e '\d+' | head -1)
	elif [[ $HTTPCODE -ne 200 ]]; then
		echo Terraria.org is unreachable, is it down?
		exit 2
	fi
	
	serverURL="$serverURL/terraria-server-$VERSION.zip"
	
	if [[ ! -e /opt/terraria/$VERSION.ver ]]; then
		rm -rf /opt/terraria/server/*
		curl -so /tmp/terraria/server.zip $serverURL
		unzip -q -d /tmp/terraria/ /tmp/terraria/server.zip && \
		cp -r /tmp/terraria/$VERSION/Linux/* /opt/terraria/server/ && \
		cp /tmp/terraria/$VERSION/Windows/serverconfig.txt /opt/terraria/server/serverconfig.default && \
		sed -in '/#maxplayers=.*/c\maxplayers=16' /opt/terraria/server/serverconfig.default && \
		sed -in '/#port=.*/c\port='$SERVER_PORT'' /opt/terraria/server/serverconfig.default && \
		sed -in '/#worldpath=.*/c\worldpath=/data/worlds/' /opt/terraria/server/serverconfig.default && \
		rm -rf /tmp/* /opt/terraria/server/*.defaultn
		touch /opt/terraria/$VERSION.ver
	fi

	if [ ! -f "/data/config/serverconfig.txt" ]; then
		if [ -f "/data/serverconfig.txt" ]; then
			mv /data/serverconfig.txt /data/config/serverconfig.txt
		else
			cp ./serverconfig.default /data/config/serverconfig.txt
		fi
	fi

	if [ ! -f "/data/config/banlist.txt" ]; then
		if [ -f "/data/banlist.txt" ]; then
			mv /data/banlist.txt /data/config/banlist.txt
		else
			touch /data/config/banlist.txt
		fi
	fi
	
	if [ -f "/data/*.log" ]; then
		mv /data/*.log /data/logs/
	fi
	
	if [ -f "/data/*.wld" ]; then
		mv /data/*.wld /data/worlds/
	fi

	if [ -n "$WORLD" ]; then
		serverARGS="$serverARGS -world $WORLD $@"
	else
		serverARGS="$serverARGS $@"
	fi

	chown -R ${runAsUser}:${runAsGroup} /data /opt/terraria
	chmod +x /opt/terraria/server/TerrariaServer*
	chmod -R g+w /data

	if [ -z "$WORLD" ]; then
		su -c "screen -mUS terra -L -Logfile /data/logs/server.'$date'.log ./TerrariaServer -x64 '$serverARGS'" ${runAsUser}
	else
		su -c "screen -dmUS terra -L -Logfile /data/logs/server.'$date'.log ./TerrariaServer -x64 '$serverARGS'" ${runAsUser}

		sleep 5
		if ! screen -list | grep -q "terra"; then
			echo -e 'Server started [TerrariaServer -x64 '$serverARGS']'
			if [[ $TEST ]]; then
				exit 0
			fi
		else
			echo -e 'Server failed to start'
			exit 3
		fi
		
		trap "touch /root/sigterm" SIGTERM
		while [ ! -e /root/sigterm ]; do sleep 1; done
		su -c 'screen -S terra -p 0 -X stuff 'exit^M'' terraria
		echo -e 'SIGTERM Caught'
		rm -f /root/sigterm
		sleep 2
	fi
	exit 0

else
	echo "Setup permission not root! Please utilize ENV variables to set UID/GID."
	exit 1
fi