FROM debian:12-slim

ENV TRACCAR_VERSION=6.6

WORKDIR /opt/traccar

RUN set -ex; \
    apt-get update; \
    TERM=xterm DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      openjdk-17-jre-headless \
      unzip \
      wget \
      bash; \
    wget -q https://github.com/traccar/traccar/releases/download/v$TRACCAR_VERSION/traccar-linux-64-$TRACCAR_VERSION.zip; \
    unzip -qo traccar-linux-64-$TRACCAR_VERSION.zip; \
    rm traccar-linux-64-$TRACCAR_VERSION.zip; \
    chmod +x traccar.run; \
    ./traccar.run --quiet; \
    rm traccar.run; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8082 5000-5150/udp

WORKDIR /opt/traccar

ENTRYPOINT ["java", "-jar", "tracker-server.jar"]
