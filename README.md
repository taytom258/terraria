# terraria-container
Containerized Terraria Server (Vanilla &amp; TShock)

## Links

Docker/Podman images avialable on [Docker Hub](https://hub.docker.com/r/taytom259/terraria)

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

After the initial world generation you can specify the world by passing the flag to the server as shown below to run the server without input. Make sure you have set your settings within your serverconfig.txt located within the /config bind mount.
```
docker run --rm -it \
    -p 7777:7777 \
    -e PUID=1000 \
    -e PGID=1000 \
    -v $HOME/terraria/config:/config \
    --name=terraria \
    docker.io/taytom259/terraria:latest -world <world_file_name>.wld
```

## Supported tags [taytom259/terraria:###](https://hub.docker.com/r/taytom259/terraria)
[vanilla-1.4.4.9] [vanilla-latest] [latest] - Vanilla 1.4.4.9

## Environment variables

* `PUID` - User ID of account running server within the container
* `PGID` - Group ID of account running server within the container

## Additional Features

### Attaching to server to run commands interactively
```
docker attach terraria
```
### Send commands externally to server
```
docker exec terraria screen -S terra -p 0 -X stuff "<command here>^M"
```
Example using the 'save' command. "^M" is the Enter character.
```
docker exec terraria screen -S terra -p 0 -X stuff "save^M"
```

## Submitting issues/suggestions
Please submit issues or recommendations within the [issues](https://github.com/taytom258/terraria-container/issues) page.
