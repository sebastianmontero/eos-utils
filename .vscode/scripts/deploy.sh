#!/bin/bash


function create_keys(){
    keys="$(cleos create key --to-console)"
    private_key=$(echo "${keys}" | cut -d' ' -f 3 | sed '1!d')
    public_key=$(echo "${keys}" | cut -d' ' -f 3 | sed '2!d')
}

function generate_account_name(){
    local an="$(echo $1 | sed -e 's/[^12345abcdefghijklmnopqrstuvwxyz]//g')"
    local anl=${#an}
    
    if [ $anl -gt 12 ]
    then
        local $offset = $(($anl - 12))
        an=${anl:$offset:12}
    fi
    echo $an
}

#Enable cleos command
. ~/.bash_aliases

sd="$(dirname "$0")"

. $sd/build.sh $1 $2

if [ $? -ne 0 ] 
then
    echo "Unable to build contract"
    exit 1
fi

echo "Unlocking wallet..."
cleos wallet unlock --password PW5HrRKYVzXWPqB6RcsvWRYnbYFDuJmd6Y5pheikh1CkJhgbxohcj

# exit_status=$?

# if [ $exit_status -ne 0 ] 
# then
#     echo "error:" $exit_status
#     echo "Unable to unlock wallet"
#     exit 1
# fi

account=$(generate_account_name "$d")

echo "Checking if $account account exists..."
cleos get account -j $account

if [ $? -ne 0 ] 
then
    echo "Account $account does not exist"
    echo "Creating and importing keys for $account account..."
    create_keys
    pubk1=$public_key
    cleos wallet import --private-key $private_key
    if [ $? -ne 0 ] 
    then
        echo "Unable to import owner private key"
        exit 1
    fi

    create_keys
    pubk2=$public_key
    cleos wallet import --private-key $private_key
    
    if [ $? -ne 0 ] 
    then
        echo "Unable to import active private key"
        exit 1
    fi

    echo "Creating $account account..."
    cleos create account eosio $account $pubk1 $pubk2

    if [ $? -ne 0 ] 
    then
        echo "Unable to create $account account"
        exit 1
    fi
else
    echo "Account $account exists"
fi

echo "Deploying contract $d..."
cleos set contract $account $gwd/$d $d.wasm $d.abi

if [ $? -ne 0 ] 
then
    echo "Unable to deploy contract $d"
    exit 1
fi

echo "Contract $d deployed succesfully!"