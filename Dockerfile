FROM xdbfoundation/digitalbits-base:latest

ENV DIGITALBITS_CORE_VERSION 1.0.7-beta.3
ENV FRONTIER_VERSION 1.0.2

EXPOSE 5432
EXPOSE 8000
EXPOSE 11625
EXPOSE 11626

RUN apt-get update && apt-get install -y psmisc curl wget git libpq-dev libsqlite3-dev libsasl2-dev postgresql-client postgresql postgresql-contrib sudo vim zlib1g-dev supervisor && apt-get clean 

# digitalbits-core
RUN wget -O digitalbits-core.deb https://dl.cloudsmith.io/public/xdb-foundation/digitalbits-core/deb/ubuntu/pool/focal/main/d/di/digitalbits-core_${DIGITALBITS_CORE_VERSION}_amd64.deb \
  && dpkg -i digitalbits-core.deb && rm digitalbits-core.deb

# frontier
RUN wget -O frontier.deb https://dl.cloudsmith.io/public/xdb-foundation/digitalbits-frontier/deb/ubuntu/pool/focal/main/d/di/digitalbits-frontier_${FRONTIER_VERSION}_amd64.deb \
&& dpkg -i frontier.deb && rm frontier.deb

RUN echo "\nDone installing digitalbits-core and frontier...\n"

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

ENTRYPOINT ["/start" ]
