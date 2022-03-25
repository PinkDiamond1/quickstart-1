FROM docker.digitalbits.io/digitalbits-core/digitalbits-core:latest

ENV FRONTIER_VERSION 1.0.63

EXPOSE 5432
EXPOSE 8000
EXPOSE 11625
EXPOSE 11626

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y psmisc curl wget git libpq-dev \
    libsqlite3-dev libsasl2-dev postgresql-client postgresql postgresql-contrib \
    sudo vim zlib1g-dev supervisor && apt-get clean 

RUN curl -1sLf 'https://archive.digitalbits.io/public/digitalbits-frontier/setup.deb.sh' | bash
RUN apt-get install digitalbits-frontier=${FRONTIER_VERSION}



RUN ["mkdir", "-p", "/opt/digitalbits/frontier"]
RUN ["mkdir", "-p", "/opt/digitalbits/history-cache"]
RUN ["touch", "/opt/digitalbits/.docker-ephemeral"]

RUN [ "adduser", \
  "--disabled-password", \
  "--gecos", "\"\"", \
  "--uid", "10011001", \
  "digitalbits"]

RUN ["ln", "-s", "/opt/digitalbits", "/digitalbits"]
RUN ["ln", "-s", "/opt/digitalbits/core/etc/digitalbits-core.cfg", "/digitalbits-core.cfg"]
RUN ["ln", "-s", "/opt/digitalbits/frontier/etc/frontier.env", "/frontier.env"]
ADD common /opt/digitalbits-default/common
ADD pubnet /opt/digitalbits-default/pubnet
ADD testnet /opt/digitalbits-default/testnet


ADD start /
RUN ["chmod", "+x", "/start"]
RUN apt-get install rsync -y
ENTRYPOINT ["/start" ]
