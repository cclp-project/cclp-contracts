/**
 * cCLP Truffle config
 * @dev Parameters are loaded from files: .infura-key and .secret . if they do not exist, then will be loaded from environment variables: INFURA_KEY and MNEMONIC_PRHASES
 * Environment variables secrets are more frienly with 'circleci'
 */

const HDWalletProvider = require('truffle-hdwallet-provider');
const Ganache = require("ganache-cli");
const fs = require('fs');
const path = require('path');

let infuraKey = resolveParam(".infura-key","INFURA_KEY");
let mnemonic = resolveParam(".secret","MNEMONIC_PRHASES");


module.exports = {
  networks: {
    in_memory: {
      provider: ()=> new Ganache.provider({total_accounts: 25, mnemonic: mnemonic}),
      network_id: "*"
    },

    local: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "http://127.0.0.1:8545", 0,10);
      },         // Standard Ethereum port (default: none)
      network_id: "*"    // Any network (default: none),
    },
    coverage: {
      host: "localhost",
      network_id: "*",
      port: 8555,         // <-- If you change this, also set the port option in .solcover.js.
      gas: 0xfffffffffff, // <-- Use this high gas value
      gasPrice: 0x01      // <-- Use this low gas price
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`, 0,10);
      },
      network_id: 4 
      //gas: 8000000000,
      //gasPrice: 0x01 
    },
    // Another network with more advanced options...
    // advanced: {
      // port: 8777,             // Custom port
      // network_id: 1342,       // Custom network
      // gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
      // gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
      // from: <address>,        // Account to send txs from (default: accounts[0])
      // websockets: true        // Enable EventEmitter interface for web3 (default: false)
    // },

    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    ropsten: {
      provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraKey}`,0,10),
      network_id: 3,       // Ropsten's id
      gas: 5000029,       // Ropsten has a lower block limit than mainnet
      gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei) 
 //     confirmations: 2,    // # of confs to wait between deployments. (default: 0)
 //     timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
 //     skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
     }

    // Useful for private networks
    // private: {
      // provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
      // network_id: 2111,   // This network is yours, in the cloud.
      // production: true    // Treats this network as if it was a public net. (default: false)
    // }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.2",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      optimizer: {
        enabled: true,
        runs: 1000000000000
      },
      //  evmVersion: "byzantium"
      // }
    }
  }
}


function resolveParam(fileName,variableName){
  let output = "";
  let filePath = path.resolve(__dirname, fileName);
  if(fs.existsSync(filePath)){
    try{
      output = fs.readFileSync(filePath).toString().trim(); //Get your key on infura.io
    }catch(error){
      console.log(fileName+" file doesn't exist . Reading "+variableName+" variable");
    }
  }
  if(!output || output.trim().length==0){
    output=process.env[variableName];
  }
  return output;
}