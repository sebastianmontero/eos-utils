#!/bin/bash

python3 /eosfactory/utils/create_project.py $1 $2

if [ $? -ne 0 ] 
then
   echo "Unable to create project $1"
   exit 1
fi

cp /root/eosf-support-files/c_cpp_properties.json /workspace/$1/.vscode/

chmod -R a+w /workspace/$1

