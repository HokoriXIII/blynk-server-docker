FROM openjdk:11-jre

ENV Version=latest:0.41.11
ARG BLYNK_SERVER_VERSION

RUN mkdir /blynk && cd /blynk && mkdir /data && mkdir /config && touch /config/server.properties
RUN BLYNK_SERVER_VERSION=$(curl --silent "https://api.github.com/repos/blynkkk/blynk-server/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//'); curl -L https://github.com/blynkkk/blynk-server/releases/download/v$BLYNK_SERVER_VERSION/server-$BLYNK_SERVER_VERSION.jar > /blynk/server.jar

# Create data folder. To persist data, map a volume to /data
# RUN mkdir /data

# Create configuration folder. To persist data, map a file to /config/server.properties
VOLUME ["/blynk/config", "/blynk/data/backup", "/blynk"]

# IP port listing:
# 8080: Hardware without ssl/tls support
# 9443: Blynk app, https, web sockets, admin port
EXPOSE 8080 9443

WORKDIR /blynk/data
ENTRYPOINT ["java", "-jar", "/blynk/server.jar"]