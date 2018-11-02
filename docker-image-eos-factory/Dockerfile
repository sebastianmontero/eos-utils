FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]
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
RUN pwd
RUN pwd
RUN git clone https://github.com/sebastianmontero/eosfactory.git eosfactory
RUN apt-get -y install python3-pip
RUN python3 -m pip install termcolor ipython setuptools wheel
WORKDIR /eosfactory
RUN mkdir /workspace
RUN mkdir ~/eosio-wallet
COPY eosfactory-config.ini /eosfactory/config.json
RUN ./install.sh
COPY eosf-create-project.sh eosf-test.sh eosf-deploy-contract.sh /usr/local/bin/
COPY eosf-deploy-contract.py /usr/local/bin/
COPY eos-config.ini /eosfactory/build/daemon/data-dir/config.ini
RUN chmod u+x /usr/local/bin/eosf-*.sh
RUN mkdir /root/eosf-support-files
COPY c_cpp_properties.json /root/eosf-support-files/
WORKDIR /workspace
CMD ["/bin/bash"]
