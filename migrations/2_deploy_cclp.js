var FiatToken = artifacts.require("./FiatToken.sol");

module.exports = (deployer, network, accounts) => {

    const name="cCLP Fiat Token"
    const symbol="cCLP"
    const decimals = 18
    
    deployer.deploy(FiatToken,name,symbol,decimals);
}

