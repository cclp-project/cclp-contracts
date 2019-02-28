# cclp-contracts
cCLP Contracts

[![Waffle.io - Columns and their card count](https://badge.waffle.io/cclp-project/cclp-contracts.png?columns=all)](https://waffle.io/cclp-project/cclp-contracts?utm_source=badge)


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


