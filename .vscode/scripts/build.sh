#!/bin/bash

hwd="/tmp/eosio/work/"
gwd="/work"

echo parameters $0
echo "Current working directory -" $1

d="$(basename "$1")"
pd="$(dirname "$1")"
pd="$(basename "$pd")"

echo "Parent directory name: $pd" 

if [ "contracts" = "$pd" ] 
then
    echo "Selected contract: $d"

    echo "Copying contract: $d to $hwd ..."
    echo S5b1sti1n | sudo -S cp -r $1 $hwd

    if [ $? -ne 0 ] 
    then
        echo "Unable to copy contract"
        exit 1
    fi

    if [[ $d !=  eosio* ]]
    then 
        echo "Generating ABI..."
        docker exec nodeos eosiocpp -g $gwd/$d/$d.abi $gwd/$d/$d.cpp
        #docker exec nodeos eosio-abigen $gwd/$d/$d.cpp --output=$gwd/$d/$d.abi
    
        if [ $? -ne 0 ] 
        then
            echo "Unable to generate abi"
            exit 1
        fi
    fi

    echo "Generating WAST..."
    docker exec nodeos eosio-cpp $gwd/$d/$d.cpp -o $gwd/$d/$d.wasm 

    if [ $? -ne 0 ] 
    then
        echo "Unable to generate WAST"
        exit 1
    fi

else
    echo "The selected dir does not belong to the contracts dir"
    exit 1
fi




#sudo cp -r $1 /tmp/eosio/work/
