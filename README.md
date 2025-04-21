# Terraria Containerized
Containerized Terraria Server

## Links

Docker/Podman images available on [Docker Hub](https://hub.docker.com/r/taytom259/terraria)

Github Repository - [Github](https://github.com/taytom258/terraria-container)

## Usage (Initial Interactive Mode)

Your initial start of the server you will have to create a world. Follow the prompts.
```
docker run --rm -it \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=America/New_York \
    -v $HOME/terraria/config:/config \
    --name=terraria \
    docker.io/taytom259/terraria:latest
```

After the initial world generation you can specify the world by specifying the .wld file within an environment variable.
Remember to set your settings in the serverconfig.txt located within the /config directory.

> [!CAUTION]
> Try not to run your server in the interactive mode, only use the initial interactive mode to create the world.
> Running your server interactively disables the autosave on exit functionality. You have been warned!

## Usage (Headless Daemon Mode)
Logs are stored within the /config directory
```
docker run --rm \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e WORLD=world.wld \
    -e TZ=America/New_York \
    -v $HOME/terraria/config:/config \
    --name=terraria \
    docker.io/taytom259/terraria:latest
```

## Supported tags [taytom259/terraria:###](https://hub.docker.com/r/taytom259/terraria)
[vanilla-1.4.4.9] [vanilla-latest] [latest] - Vanilla 1.4.4.9<br/>
[vanilla-1.4.4.9-dev] - Vanilla 1.4.4.9 Development - Bleeding edge, more than likely broken!

## Docker Compose Example
```
name: terraria-container

services:
  terraria:
    image: docker.io/taytom259/terraria:latest
    ports:
      - "7777:7777"
    environment:
      - PUID=1000
      - PGID=1000
      - WORLD=world.wld
      - TZ=America/New_York
    volumes:
      - $HOME/terraria/config:/config
```

## Environment variables

> [!WARNING]
> The first non-root user within most linux distros is set to 1000 as the UID. This will typically allow you to edit the files produced by this container without issue.
> If you however change the default UID or GID using these environment variables, make sure your user, and also the owner of the bind mount files, are able to access the files.

* `PUID` - User ID of account running server within the container
* `PGID` - Group ID of account running server within the container
* `WORLD` - World file name as located within /config
* `TZ` - Timezone to set for proper log times - [TZ Table](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

## Additional Features

### Attaching to server to run commands (Only available in interactive mode)
```
docker attach terraria
```
> [!TIP]
> To detach press `CTRL-p` then `CTRL-q`

### Send commands externally to server
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
