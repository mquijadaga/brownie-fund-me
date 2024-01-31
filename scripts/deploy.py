from brownie import FundMe, MockV3Aggregator, config, network
from scripts.helpful_scripts import get_account, deploy_mocks, LOCAL_BLOCKCHAIN_ENVIRONTMENTS
from web3 import Web3

def deploy_fund_me():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONTMENTS:
        price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address
    account = get_account()
    fund_me = FundMe.deploy(price_feed_address, {"from":account}, publish_source=config["networks"][network.show_active()].get("verify"))
    print(f"Contract deployed to{fund_me.address}")
    return fund_me

def main():
    deploy_fund_me()