var FiatToken = artifacts.require("./FiatToken.sol");

module.exports = (deployer, network, accounts) => {

    const name="cCLP Fiat Token"
    const symbol="cCLP"
    const decimals = 18
    const masterMinterAddress = '0xad27fcf246d1a9752daf649d6391c17c1ce80d0c';
    
    deployer.deploy(FiatToken,name,symbol,decimals, masterMinterAddress);
}

