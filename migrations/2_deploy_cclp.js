var FiatToken = artifacts.require("./FiatToken.sol");

module.exports = (deployer, network, accounts) => {

    const name="cCLP Fiat Token"
    const symbol="cCLP"
    const decimal = 18

    deployer.deploy(FiatToken,name,symbol,decimal);
}