import argparse
from eosfactory.eosf import *

parser = argparse.ArgumentParser(description='Unlock wallet')
parser.add_argument('--testnet', '-t', required=False,
                    help='The name of the remote testnet related to the wallet to unlock', dest='testnet')

parser.add_argument('--op', '-o', required=False,
                    help='The wallet app to run', dest='op', default="unlock")

args = parser.parse_args()
print(args)

print('Unlocking wallet for testnet: {}'.format(
    args.testnet if args.testnet else 'local'))

testnet = get_testnet(args.testnet, reset=False)

testnet.configure()

create_wallet()

getattr(get_wallet(), args.op)()
