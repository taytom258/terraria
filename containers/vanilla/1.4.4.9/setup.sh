#!/bin/bash

serverARGS="$@"

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

  if [ ! -f "/config/serverconfig.txt" ]; then
        cp ./serverconfig.default /config/serverconfig.txt
  fi

  if [ ! -f "/config/banlist.txt" ]; then
        touch /config/banlist.txt
  fi

  if [ -n $WORLD  ]; then
        serverARGS="-world /config/$WORLD $@"
  fi

  chown -R ${runAsUser}:${runAsGroup} /config /opt/terraria
  chmod -R g+w /config

  #gosu ${runAsUser}:${runAsGroup} /opt/terraria/run.sh "$@"

  date=$(date)
  su -c 'screen -dmS -L -Logfile /config/server.$date.log terra ./TerrariaServer -x64 -config /config/serverconfig.txt -banlist /config/banlist.txt $serverARGS' terraria

  trap 'touch /root/sigterm' TERM
  i=0
  while [ ! -e /root/sigterm ]; do 
	sleep 1
	((i++))
	saveTime=$((60*5))
	if [[ $i -gt $saveTime  ]]; then
		su -c 'screen -S terra -p 0 -X stuff 'save^M'' terraria
		i=0
	fi
  done
  su -c 'screen -S terra -p 0 -X stuff 'exit^M'' terraria

else
	echo "Setup permission not root! Please utilize ENV variables to set UID/GID."
	exit 1
fi
