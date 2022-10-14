FROM ubuntu

WORKDIR /app/

ADD ./ /app/

RUN apt-get update

RUN apt-get install -y \
    sudo \
    wget \
    neofetch

## dart install
RUN apt-get install apt-transport-https -y
RUN wget -qO /etc/apt/trusted.gpg.d/dart_linux_signing_key.asc https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN wget -qO /etc/apt/sources.list.d/dart_stable.list https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list
RUN apt-get update
RUN apt-get install dart -y

RUN wget --quiet --show-progress http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

RUN sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.16_amd64.deb

## download tdlib
RUN wget --quiet --show-progress -O ./libtdjson.so https://github.com/azkadev/telegram_client/releases/download/v2022.10.13.02.09.21/libtdjson.so.1.8.7

## compile to exe
RUN dart pub get
RUN dart compile exe ./bin/specta_paas.dart -o ./index

CMD ["./index"]
