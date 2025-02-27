FROM debian:12-slim

ENV TRACCAR_VERSION=5.10

WORKDIR /opt/traccar

RUN set -ex; \
    apt-get update; \
    TERM=xterm DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      openjdk-17-jre-headless \
      unzip \
      wget; \
    wget -q https://github.com/traccar/traccar/releases/download/v5.10/traccar-linux-64.zip \
    && unzip traccar-linux-64.zip \
    && rm traccar-linux-64.zip; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8082 5000-5150/udp

ENTRYPOINT ["./traccar.run"]
