FROM ubuntu:plucky

ENV PUID=1000 PGID=1000 VERSION=1449 TYPE=vanilla SERVER_PORT=7777

EXPOSE 7777/tcp
EXPOSE 7777/udp

RUN apt update && \
	apt -y upgrade && \
	apt -y install unzip tzdata screen wget lsof && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config /opt/terraria/server /tmp/terraria && \
	userdel -f ubuntu && \
	useradd -m -s /bin/bash -k /etc/ske1/ -u $PUID terraria

COPY --chown=$PUID:$PGID --chmod=750 scripts/run.sh /opt/terraria/run.sh
COPY --chown=$PUID:$PGID --chmod=750 scripts/check-run.sh /opt/terraria/check-run.sh

VOLUME ["/config"]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD lsof -i:$SERVER_PORT -t

WORKDIR /opt/terraria/server

ENTRYPOINT ["/opt/terraria/run.sh"]
