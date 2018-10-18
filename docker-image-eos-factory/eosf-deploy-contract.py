import argparse
import re
from eosf import *


def get_contract_account(contract):
    user = re.sub(r'[^12345abcdefghijklmnopqrstuvwxyz]','', contract.lower())
    return user[:12]



parser = argparse.ArgumentParser(description='Deploy contract')
parser.add_argument('contract', help='Contract name')
parser.add_argument('--reset', '-r', required=False, help='Show real values tail', dest='reset', action='store_true')

args = parser.parse_args()
print(args)

contract = ContractBuilder(args.contract)
print('Building contract: {}...'.format(args.contract))
contract.build()

if args.reset:
    print('Resetting block chain...')
    reset()
else:
    print('Starting block chain...')
    resume()

try:
    print('Creating wallet...')
    create_wallet()
except NameError:
    print('Wallet already exists')

try:
    print('Unlocking wallet ...')
    get_wallet().unlock()
except:
    print('Already unlocked')

print('Creating master account')
create_master_account('master')

contract_account = get_contract_account(args.contract)

print('Creating contract account:{}... '.format(contract_account))
create_account(contract_account, master)

contract = Contract(globals()[contract_account],contract.path())
print('Deploying contract...')
contract.deploy()

print('Contract {} successfully deployed'.format(args.contract))


