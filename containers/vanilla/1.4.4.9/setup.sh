#!/bin/bash

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

  chown -R ${runAsUser}:${runAsGroup} /config /opt/terraria
  chmod -R g+w /config

  gosu ${runAsUser}:${runAsGroup} /bin/bash -c '/opt/terraria/run.sh'
else
  echo "Setup permission not root! Please utilize ENV variables to set UID/GID."
  exit 1
fi
