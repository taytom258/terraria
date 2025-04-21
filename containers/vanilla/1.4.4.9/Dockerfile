FROM ubuntu:plucky

ENV PUID=1000 PGID=1000

EXPOSE 7777/tcp
EXPOSE 7777/udp

RUN apt update && \
	apt -y upgrade && \
	apt -y install unzip wget screen && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config && \
	mkdir -p /opt/terraria && \
	userdel -f ubuntu

RUN mkdir -p /tmp/terraria && \
	wget -O /tmp/terraria/server-1449.zip \
	https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip && \
	unzip -q -d /tmp/terraria/ /tmp/terraria/server-1449.zip && \
	cp -r /tmp/terraria/1449/Linux/* /opt/terraria/ && \
	cp /tmp/terraria/1449/Windows/serverconfig.txt /opt/terraria/serverconfig.default && \
	sed -in '/#maxplayers=8/c\maxplayers=16' /opt/terraria/serverconfig.default && \
	sed -in '/#port=7777/c\port=7777' /opt/terraria/serverconfig.default && \
	sed -in '/#worldpath=C:\\Users\\Defaults\\My Documents\\My Games\\Terraria\\Worlds\\/c\worldpath=/config/' /opt/terraria/serverconfig.default && \
	chown -R terraria:terraria /opt/terraria /config && \
	chmod +x /opt/terraria/TerrariaServer* && \
	rm -rf /tmp/* /opt/terraria/*.defaultn

COPY --chmod=750 run.sh /opt/terraria/run.sh

VOLUME ["/config"]

WORKDIR /opt/terraria/

ENTRYPOINT ["./run.sh"]
