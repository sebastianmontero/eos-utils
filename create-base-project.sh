#!/bin/bash

eosd="/home/sebastian/Documents/eos/eos"

if [ $# -gt 2 ] || [ $# -lt 1 ]
then
    echo "Usage:"
    echo "create-base-project <project-dir-name> [eos-base-path]"
    exit 1
fi

if [ $# -eq 2 ]
then
    if ! [ -d $2 ]
    then
        echo "EOS directory does not exist"
        exit 1
    fi

    eosd=$2
fi

if [ $# -eq 1 ]
then
    if ! [ -d $1 ]
    then
        echo "Project dir $1 does not exist, creating..."
        mkdir $1

        if [ $? -ne 0 ] 
        then
            echo "Unable to create project folder"
            exit 1
        fi
    else
        if ! [ -z "$(ls -A $1)" ]
        then
            echo "Project dir is not empty, canceling project creation"
            exit 1
        fi
    fi
fi

base_dir=$(dirname "$0")

echo "Copying files for base project folder..."
cp -r $base_dir/.vscode $1

mkdir $1/CMakeModules/

cp  $eosd/CMakeModules/FindWasm.cmake $1/CMakeModules/
cp  $eosd/CMakeModules/wasm.cmake $1/CMakeModules/
cp  $eosd/CMakeModules/FindWasm.cmake $1/CMakeModules/

mkdir $1/contracts/

cp -r $eosd/contracts/eosiolib $1/contracts/
cp -r $eosd/contracts/libc++ $1/contracts/
cp -r $eosd/contracts/musl $1/contracts/
cp $base_dir/CMakeLists-contracts.txt $1/contracts/CMakeLists.txt

cp -r $eosd/externals $1

cp -r $eosd/libraries $1

cp $base_dir/CMakeLists.txt $1


echo "Base Project created succesfully!"