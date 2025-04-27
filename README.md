# Terraria Containerized

[![AutoBuild](https://github.com/taytom258/terraria-container/actions/workflows/AutoBuild.yml/badge.svg?branch=main)](https://github.com/taytom258/terraria-container/actions/workflows/AutoBuild.yml)
![GitHub commits since tagged version](https://img.shields.io/github/commits-since/taytom258/terraria-container/v1.1.0)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/taytom259/terraria-container/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/taytom259/terraria-container)
![Docker Stars](https://img.shields.io/docker/stars/taytom259/terraria-container)



Docker Images<br/>
[Github Packages](https://github.com/taytom258/terraria-container/pkgs/container/terraria-container)<br/>
[Docker Hub](https://hub.docker.com/r/taytom259/terraria-container)

	
Github Repository<br/>
[Github](https://github.com/taytom258/terraria-container)



> [!NOTE]
> Updating from 1.0.0 to 1.1.0<br/>
> Ensure you update your /config volume to the new /data volume<br/>
> Script will copy over existing data if it exists to the proper folders.

## Usage (Interactive Mode)
With no WORLD environment variable set, interactive mode will be enabled.
Follow the prompts to generate a world with your desired configuration. 
```
docker run --rm -it \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=America/New_York \
    -e VERSION=latest \
    -e TYPE=vanilla \
    -v $HOME/terraria:/data \
    --name=terraria \
    ghcr.io/taytom258/terraria-container
```

After the initial world generation you can declare the world by specifying the path to the .wld file within the WORLD environment variable.
Remember to set your settings in the serverconfig.txt located within the /config directory.

> [!CAUTION]
> Do not run your server in interactive mode, only use the interactive mode to create your world.<br/>
> Running your server interactively disables the autosave on shutdown functionality. You have been warned!

## Usage (Non-Interactive Mode/Daemon Mode)
Logs & worlds are stored within the /config directory
```
docker run --rm \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e WORLD=/config/world.wld \
    -e TZ=America/New_York \
    -e VERSION=latest \
    -e TYPE=vanilla \
    -v $HOME/terraria:/data \
    --name=terraria \
    ghcr.io/taytom258/terraria-container
```

## Supported tags
[latest] - Latest Server Build<br/>
[1.0.0] - Server Release 1.0.0<br/>
[1.1.0] - Server Release 1.1.0<br/>
[dev] - Server Development Build - More than likely broken!

## Docker Compose Example
```
name: terraria-container

services:
  terraria:
    image: ghcr.io/taytom258/terraria-container
    ports:
      - "7777:7777"
    environment:
      - PUID=1000
      - PGID=1000
      - WORLD=/data/worlds/world.wld
      - TZ=America/New_York
      - VERSION=latest
      - TYPE=vanilla
    volumes:
      - $HOME/terraria:/data
    restart: unless-stopped
```

## Environment variables

> [!WARNING]
> The first non-root user within most linux distros is set to 1000 as the UID. This will typically allow you to edit the files produced by this container without issue.
> If you however change the default UID or GID using these environment variables, make sure your user, and also the owner of the bind mount files, are able to access the files.

* `TYPE` - Server type to run [vanilla or tshock]
* `VERSION` - Vanilla server version to run - latest or [Version](https://terraria.wiki.gg/wiki/Server#Downloads)
* `TSVERSION` - TShock server version to run - Only active with TYPE=tshock - latest or [Version](https://github.com/Pryaxis/TShock/releases)
* `WORLD` - World file name as located within /config
* `MAXPLAYERS` - Maximum amount of players allowed on the server
* `AUTOCREATE` - Size of world to autocreate if does not exist, 1-Small 2-Medium 3-Large
* `PUID` - User ID of account running server within the container
* `PGID` - Group ID of account running server within the container
* `TZ` - Timezone to set for proper log times - [TZ Table](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

## Additional Features

### Addtional command-line arguments
Command-line arguments can be passed through to the server by specifying after the run command.<br/>
Docker compose would utilize the command: instruction<br/>
```
docker run --rm ... ghcr.io/taytom258/terraria-container -noupnp
```
```
...
image: ghcr.io/taytom258/terraria-container
command: -noupnp
ports:
...
```

### Attaching to server to run commands (Only available in interactive mode)
```
docker attach terraria
```
> [!TIP]
> To detach press `CTRL-p` then `CTRL-q`

### Send commands externally to server (Only available in non-interactive mode)
```
docker exec -u terraria terraria screen -S terra -p 0 -X stuff "<command here>^M"
```
Example using the 'save' command. "^M" is the Enter character.
* `exec` - Execute command within container
* `-u terraria` - User to execute command under
* `terraria` - Container name/id
* `screen` - Supervisor application for server
* `-S terra` - Name of 'session' that server is running under
* `-p 0` - Grab the first 'screen' from session process
* `-X stuff "save^M"` - Send screen command of stuff (keyboard emulation) with command of 'save' followed by an Enter character (^M)
```
docker exec -u terraria terraria screen -S terra -p 0 -X stuff "save^M"
```

## Submitting issues/suggestions
Please submit issues or suggestions within the [issues](https://github.com/taytom258/terraria-container/issues) page.
