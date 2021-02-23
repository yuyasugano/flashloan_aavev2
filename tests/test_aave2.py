import pytest
import click

configurations = {
    'dai': {'token': '0x6b175474e89094c44da98b954eedeac495271d0f', 'whale': '0x70178102AA04C5f0E54315aA958601eC9B7a4E08'},
    'usdt': {'token': '0xdac17f958d2ee523a2206206994597c13d831ec7', 'whale': '0x1062a747393198f70f71ec65a582423dba7e5ab3'},
    'usdc': {'token': '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48', 'whale': '0xa191e578a6736167326d05c119ce0c90849e84b7'},
}

# isolation fixture for each function, takes a snapshot of the chain
@pytest.fixture(scope='function', autouse=True)
def isolation(fn_isolation):
    pass

def test_flashloan_aave2(accounts, interface, chain, Flashloan):
    # prepare accounts
    user = accounts[0]
    # Accounts.at with force=True make sending transactions without having that
    # address private key possible
    accounts.at('0x<the address holds specific amount of the tokens>', force=True)

    initialization = accounts[-1]
    aave = interface.Aave('0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9', owner=user)

    # instatiate a flashloan contract
    aave_lending_pool_v2 = '0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5'
    flashloan = Flashloan.deploy(aave_lending_pool_v2, {'from': user})
    tokens = [interface.ERC20(configurations[i]['token']) for i in configurations]
    for token in tokens:
        token.transfer(flashloan.address, 5 * 10 ** token.decimals(), {'from': initialization})

    amounts = [1000 * 10 ** token.decimals() for token in tokens]
    modes = [0 for _ in tokens] # reverts if the flash loaned amounts and fee were not returned

    tx = aave.flashLoan(flashloan, tokens, amounts, modes, flashloan, b'', 0)
    tx.info()
    for token in tokens:
        balance = token.balanceOf(flashloan.address) / 10 ** token.decimals()
        assert balance > 0, 'Aave V2 Flashloan did not run correctly'

