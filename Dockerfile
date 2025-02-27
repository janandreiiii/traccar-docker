FROM debian:12-slim

ENV TRACCAR_VERSION=6.6

WORKDIR /opt/traccar

# Install dependencies
RUN set -ex; \
    apt-get update; \
    TERM=xterm DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      openjdk-17-jre-headless \
      unzip \
      wget \
      nginx \
      bash; \
    wget -q https://github.com/traccar/traccar/releases/download/v$TRACCAR_VERSION/traccar-linux-64-$TRACCAR_VERSION.zip; \
    unzip -qo traccar-linux-64-$TRACCAR_VERSION.zip; \
    rm traccar-linux-64-$TRACCAR_VERSION.zip; \
    chmod +x traccar.run; \
    ./traccar.run --quiet; \
    rm traccar.run; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Ensure conf directory exists
RUN mkdir -p /opt/traccar/conf

# Copy default config file
COPY traccar.xml /opt/traccar/conf/traccar.xml

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports for web UI and device connections
EXPOSE 8082 5055

# Start both Traccar and Nginx
CMD service nginx start && java -jar /opt/traccar/tracker-server.jar /opt/traccar/conf/traccar.xml
