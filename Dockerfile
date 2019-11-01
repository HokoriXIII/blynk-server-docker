FROM openjdk:11-jre

MAINTAINER Alex Hokori <13hokori@gmail.com>

ENV BLYNK_SERVER_VERSION curl --silent "https://api.github.com/repos/blynkkk/blynk-server/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/v//'

LABEL Name=blynk Version=${BLYNK_SERVER_VERSION}
RUN mkdir /blynk
RUN curl -L https://github.com/blynkkk/blynk-server/releases/download/v${BLYNK_SERVER_VERSION}/server-${BLYNK_SERVER_VERSION}.jar > /blynk/server.jar

# Create data folder. To persist data, map a volume to /data
RUN mkdir /data

# Create configuration folder. To persist data, map a file to /config/server.properties
RUN mkdir /config && touch /config/server.properties
VOLUME ["/config", "/data/backup"]

# IP port listing:
# 8080: Hardware without ssl/tls support
# 9443: Blynk app, https, web sockets, admin port
EXPOSE 8080 9443

WORKDIR /data
ENTRYPOINT ["java", "-jar", "/blynk/server.jar", "-dataFolder", "/data", "-serverConfig", "/config/server.properties"]