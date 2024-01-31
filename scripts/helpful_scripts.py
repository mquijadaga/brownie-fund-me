from brownie import accounts,config, network, MockV3Aggregator
from web3 import Web3

DECIMALS = 8
STARTING_PRICE = 2000 #USD->ETHER
LOCAL_BLOCKCHAIN_ENVIRONTMENTS = ["development", "ganache-local"]
FORKED_LOCAL_ENVIRONTMENTS = ["mainnet-fork", "mainnet-fork-dev"]

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONTMENTS or network.show_active() in FORKED_LOCAL_ENVIRONTMENTS :
        return accounts[0]
    else :
        return accounts.add(config["wallets"]["from_key"])
    
def deploy_mocks():
        print(f"The active network is {network.show_active()}")
        print(f"Deploying the mocks!")
        MockV3Aggregator.deploy(DECIMALS, Web3.toWei(number=STARTING_PRICE, unit="ether"), {"from": get_account()})
        print(f"Mocks Deployed")