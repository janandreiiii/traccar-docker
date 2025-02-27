FROM debian:bullseye-slim

# Install Java (required for Traccar)
RUN apt update && apt install -y openjdk-17-jre wget unzip

# Set working directory
WORKDIR /opt/traccar

# Download and extract Traccar
RUN wget -q https://github.com/traccar/traccar/releases/latest/download/traccar-linux-arm-64.zip \
    && unzip traccar-linux-arm-64.zip \
    && rm traccar-linux-arm-64.zip

# Expose Traccar's default Web UI port
EXPOSE 8082

# Start Traccar with limited memory usage
CMD ["java", "-Xmx256m", "-jar", "tracker-server.jar"]
