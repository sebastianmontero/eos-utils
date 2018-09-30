FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y install git-core curl lbzip2 sudo nano
RUN git config --global user.name "seb-eos-dev"
RUN git config --global user.email "seb.eos.dev@gmail.com"
RUN git clone https://github.com/EOSIO/eos --recursive
WORKDIR /eos
RUN yes 1 | ./eosio_build.sh
RUN sed -i -e 's/,::1//g' $HOME/opt/mongodb/mongod.conf
RUN ./eosio_install.sh

WORKDIR /
RUN git clone --recursive https://github.com/eosio/eosio.cdt
WORKDIR /eosio.cdt
RUN ./build.sh SYS
RUN ./install.sh

