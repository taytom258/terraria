FROM ubuntu:plucky

ENV PUID=1000 PGID=1000

EXPOSE 7777/tcp
EXPOSE 7777/udp

RUN apt update && \
	apt -y upgrade && \
	apt -y install unzip gosu screen && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config /opt/terraria /tmp/terraria && \
	userdel -f ubuntu && \
	useradd -m -s /bin/bash -k /etc/ske1/ -u $PUID terraria

ADD https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip /tmp/terraria/server-1449.zip

RUN unzip -q -d /tmp/terraria/ /tmp/terraria/server-1449.zip && \
	cp -r /tmp/terraria/1449/Linux/* /opt/terraria/ && \
	cp /tmp/terraria/1449/Windows/serverconfig.txt /opt/terraria/serverconfig.default && \
	sed -in '/#maxplayers=8/c\maxplayers=16' /opt/terraria/serverconfig.default && \
	sed -in '/#port=7777/c\port=7777' /opt/terraria/serverconfig.default && \
	sed -in '/#worldpath=C:\\Users\\Defaults\\My Documents\\My Games\\Terraria\\Worlds\\/c\worldpath=/config/' /opt/terraria/serverconfig.default && \
	chmod +x /opt/terraria/TerrariaServer* && \
	chown -R terraria:terraria /opt/terraria /config && \
	rm -rf /tmp/* /opt/terraria/*.defaultn

COPY --chown=$PUID:$PGID --chmod=750 run.sh /opt/terraria/run.sh
COPY --chown=$PUID:$PGID --chmod=750 setup.sh /opt/terraria/setup.sh

VOLUME ["/config"]

USER $PUID:$PGID

WORKDIR /opt/terraria/

ENTRYPOINT ["./setup.sh"]
