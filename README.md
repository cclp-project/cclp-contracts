# cclp-contracts
cCLP Contracts

[![CircleCI](https://circleci.com/gh/cclp-project/cclp-contracts.svg?style=svg)](https://circleci.com/gh/cclp-project/cclp-contracts)
[![codecov.io](https://codecov.io/gh/cclp-project/cclp-contracts/branch/master/graphs/badge.svg?branch=master)](http://codecov.io/github/cclp-project/cclp-contracts?branch=master)


## Install

```
npm i
```

## Create secret
Create a `.secret` file with the mnemonic
Create a `.infura-key` file with your key from infura.io

## Compile
```
npm run compile
```

## Run the tests
```
npm test
```

### Deploy to localhost
You need a running version for a node on http://localhost:8545/. You can run one with 
```
./node_modules/.bin/ganache-cli
```

To run the deployment

```
./node_modules/.bin/truffle migrate
```

Or you can test the deployment with the `in_memory` ganache provider
```
./node_modules/.bin/truffle migrate --network in_memory
```

## Roles in the contract
| Role          |                  | (addr?) | 
|---------------|------------------|---------------------|
| proxyAdmin    | Admin of the proxy contract. Can do the upgrades to new version of token | |
| masterMinter  | Can add and remove minters | |
| pauser        | Can pause the contract     | |
| blacklister   | Can blacklist addreses (block) | |
| owner         | Owner of the token. Can set/change, masterMinter, pauser, blacklister and owner ||



## Upgradeable Proxies 

### Manual deployment 

We must get **openzeppelin sdk client** and the do something like that

```bash
echo "setting roles accounts"
myDeployerAccount="0x....."
owner="0x......"
masterMinterAddress="0x....."
blackListerAddress="0x....."
pauserMasterAddress="0x...."

blacklistable=$(openzeppelin create Blacklistable --network local --from $myDeployerAccount --init initialize --args "$blackListerAddress,$owner")

masterMinter=$(openzeppelin create MasterMinter --network local --from $myDeployerAccount --init initialize --args "$masterMinterAddress,$owner")

masterPauser=$(openzeppelin create MasterPauser --network local --from $myDeployerAccount --init initialize --args "$pauserMasterAddress,$owner")

fiatToken=$(openzeppelin create FiatToken --network local --from $myDeployerAccount --init initialize --args "\"cCLP Fiat Token\",\"cCLP\",18,$masterMinter,$blacklistable,$masterPauser,$owner")
```