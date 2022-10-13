FROM ubuntu

WORKDIR /app/

ADD * /app/

RUN apt-get update

RUN apt-get install -y \
    sudo \
    wget

## dart install
RUN apt-get install apt-transport-https -y
RUN wget -qO /etc/apt/trusted.gpg.d/dart_linux_signing_key.asc https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN wget -qO /etc/apt/sources.list.d/dart_stable.list https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list
RUN apt-get update
RUN apt-get install dart -y

## download tdlib

RUN wget --quiet --show-progress -O libtdjson.so https://github.com/azkadev/telegram_client/releases/download/v2022.09.01.12.01.27/libtdjson.so.1.8.5


CMD ["dart", "run"]