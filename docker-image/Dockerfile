FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y install git-core curl lbzip2 sudo
RUN git config --global user.name "seb-eos-dev"
RUN git config --global user.email "seb.eos.dev@gmail.com"
RUN git clone https://github.com/EOSIO/eos --recursive
#WORKDIR /eos
#RUN ./eosio_build.sh
#RUN ./eosio_install.sh


