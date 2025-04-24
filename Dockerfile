FROM ubuntu:noble

ENV PUID=1000 PGID=1000 VERSION=1449 TYPE=vanilla SERVER_PORT=7777

LABEL org.opencontainers.image.source=https://github.com/taytom258/terraria-container
LABEL org.opencontainers.image.title=terraria-container
LABEL org.opencontainers.image.description="Containerized Terraria Server"
LABEL org.opencontainers.image.licenses=GPL-3.0

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get -y install unzip tzdata screen wget && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config /opt/terraria/server /tmp/terraria && \
	userdel -f ubuntu && \
	useradd -m -s /bin/bash -k /etc/ske1/ -u $PUID terraria

COPY --chown=$PUID:$PGID --chmod=751 scripts/run.sh /opt/terraria/run.sh
COPY --chown=$PUID:$PGID --chmod=751 files/test.wld /opt/terraria/test.wld

VOLUME ["/config"]

WORKDIR /opt/terraria/server

ENTRYPOINT ["/opt/terraria/run.sh"]