import argparse
import re
import os
from eosfactory.eosf import *


INITIAL_RAM_KBYTES = 8
INITIAL_STAKE_NET = 3
INITIAL_STAKE_CPU = 3


def _create_account(account, master):
    print('Creating {} account...'.format(account))
    create_account(account, master)


def get_account_details(accounts):
    details = '------------------Account details----------------------------\n'
    for account in accounts:
        details += _get_single_account_details(account) + '\n\n'

    return details


def _get_single_account_details(account):
    details = 'Account object name: {}\n'.format(account.account_object_name)
    details += 'Account name: {}\n'.format(account.name)
    if not isinstance(account.active_key, str):
        details += 'Active private key: {} public key: {}\n'.format(
            account.active_key.key_private, account.active_key.key_public)
    if not isinstance(account.owner_key, str):
        details += 'Owner private key: {} public key: {}\n'.format(
            account.owner_key.key_private, account.owner_key.key_public)
    return details


def get_contract_account(contract):
    user = re.sub(r'[^12345abcdefghijklmnopqrstuvwxyz]', '', contract.lower())
    return user[:12]


def stats():
    print_stats(
        [master, host, alice, carol, bob],
        [
            "core_liquid_balance",
            "ram_usage",
            "ram_quota",
            "total_resources.ram_bytes",
            "self_delegated_bandwidth.net_weight",
            "self_delegated_bandwidth.cpu_weight",
            "total_resources.net_weight",
            "total_resources.cpu_weight",
            "net_limit.available",
            "net_limit.max",
            "net_limit.used",
            "cpu_limit.available",
            "cpu_limit.max",
            "cpu_limit.used"
        ]
    )


parser = argparse.ArgumentParser(description='Deploy contract')
parser.add_argument('contract', help='Contract name')
parser.add_argument('--reset', '-r', required=False,
                    help='Show real values tail', dest='reset', action='store_true')
parser.add_argument('--testnet', '-t', required=False,
                    help='The name of the remote testnet to use', dest='testnet')

args = parser.parse_args()
print(args)

print('Getting testnet: {}'.format(args.testnet if args.testnet else 'local'))

testnet = get_testnet(args.testnet, reset=args.reset)

print('Configuring testnet...')
testnet.configure()

if args.reset and not testnet.is_local():
    print('Clearing account cache...')
    testnet.clear_cache()

print('Verifying testnet is running...')
testnet.verify_production()

print('Configuring master account...')
create_master_account("master", testnet)

print('Creating host account...')
create_account("host", master,
               buy_ram_kbytes=INITIAL_RAM_KBYTES, stake_net=INITIAL_STAKE_NET, stake_cpu=INITIAL_STAKE_CPU)

print('Creating test accounts...')
create_account("alice", master,
               buy_ram_kbytes=INITIAL_RAM_KBYTES, stake_net=INITIAL_STAKE_NET, stake_cpu=INITIAL_STAKE_CPU)
create_account("carol", master,
               buy_ram_kbytes=INITIAL_RAM_KBYTES, stake_net=INITIAL_STAKE_NET, stake_cpu=INITIAL_STAKE_CPU)
create_account("bob", master,
               buy_ram_kbytes=INITIAL_RAM_KBYTES, stake_net=INITIAL_STAKE_NET, stake_cpu=INITIAL_STAKE_CPU)

if not testnet.is_local():
    stats()

contract = Contract(host, args.contract)
print('Building contract: {}...'.format(args.contract))
contract.build(force=False)

print('Deploying contract...')
contract.deploy(payer=master)

account_details = get_account_details([master, host, alice, bob, carol])

print()
print(account_details)

if not testnet.is_local():
    contract_name = os.path.basename(os.path.dirname(args.contract))
    contract_code = cleos.GetCode(host).code_hash
    with open('/root/remote-contracts/{}-{}.txt'.format(contract_name, contract_code), 'w') as account_details_file:
        account_details_file.write(account_details)
