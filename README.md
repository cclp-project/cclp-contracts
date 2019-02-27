# cclp-contracts
cCLP Contracts

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

### Deploy to localhost
You need a running version for a node on http://localhost:8545/. You can run one with 
```
./node_modules/.bin/ganache-cli
```

To run the deployment

```
./node_modules/.bin/truffle migrate
```
