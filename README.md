# Terraria Containerized
Containerized Terraria Server (Vanilla &amp; TShock(WIP))

## Links

Docker/Podman images available on [Docker Hub](https://hub.docker.com/r/taytom259/terraria)

Github Repository - [Github](https://github.com/taytom258/terraria-container)

## Usage

Your initial start of the server you will have to create a world. Follow the prompts.
```
docker run --rm -it \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -v $HOME/terraria/config:/config \
    --name=terraria \
    docker.io/taytom259/terraria:latest
```

After the initial world generation you can specify the world by specifying the .wld file within an environment variable.
> [!NOTE]
> Make sure you have set your settings within your serverconfig.txt located within the /config bind mount.
```
docker run --rm -it \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e WORLD=world.wld \
    -v $HOME/terraria/config:/config \
    --name=terraria \
    docker.io/taytom259/terraria:latest
```

## Supported tags [taytom259/terraria:###](https://hub.docker.com/r/taytom259/terraria)
[vanilla-1.4.4.9] [vanilla-latest] [latest] - Vanilla 1.4.4.9

## Environment variables

> [!WARNING]
> The first non-root user within most linux distros is set to 1000 as the UID. This will typically allow you to edit the files produced by this container without issue.
>
> If you however change the default UID or GID using these environment variables, make sure your user, and also the owner of the bind mount files, are able to access the files.

* `PUID` - User ID of account running server within the container
* `PGID` - Group ID of account running server within the container
* `WORLD` - World file name as located within /config

## Additional Features

### Attaching to server to run commands interactively
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
