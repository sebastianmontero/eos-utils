#!/bin/bash

if [ "$#" -eq 3 ]
then
    python3 /eosfactory/utils/register_testnet.py http://jungle.cryptolions.io:18888 jungle -a $@
else
    python3 /eosfactory/utils/register_testnet.py http://jungle.cryptolions.io:18888 jungle -a sebastianmb1 5JWUuhyEKmeA3BourcsspC31BdnHmny3zHzMRr5zniiRZLGjkrL 5JK8xiP63hCn19wdjcHnmmkBp2TGcUpcvsY24Ci2VUw1e63RThh
fi



