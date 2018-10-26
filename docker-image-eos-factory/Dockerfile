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
RUN git clone https://github.com/tokenika/eosfactory.git eosfactory
WORKDIR /eosfactory
RUN mkdir /workspace
RUN ./build.sh -e /eos -w /workspace
RUN mkdir ~/eosio-wallet
RUN apt-get -y install python3-pip
RUN cp -r /eosfactory/pyteos /root/eosf
WORKDIR /root/eosf
RUN mkdir eosf
RUN mv eosf.py eosf/__init__.py
COPY setup.py requirements.txt ./
RUN python3 -m pip install -r requirements.txt
RUN python3 setup.py bdist_wheel
COPY eosf-create-project.sh eosf-test.sh eosf-deploy-contract.sh /usr/local/bin/
COPY eosf-deploy-contract.py /usr/local/bin/
COPY eos-config.ini /eosfactory/build/daemon/data-dir/config.ini
COPY eosfactory-config.ini /eosfactory/config.json
RUN chmod u+x /usr/local/bin/eosf-*.sh
RUN mkdir /root/eosf-support-files
COPY c_cpp_properties.json /root/eosf-support-files/
WORKDIR /workspace
CMD ["/bin/bash"]
