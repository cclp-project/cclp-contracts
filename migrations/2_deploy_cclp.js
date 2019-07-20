let FiatToken = artifacts.require("./FiatToken.sol");
let Proxy = artifacts.require('@openzeppelin/upgrades/contracts/upgradeability/AdminUpgradeabilityProxy.sol');
let rolesAddress = require("./roles_address.js")


module.exports = async (deployer, network, accounts) => {

    const name="cCLP Fiat Token"
    const symbol="cCLP"
    const decimals = 18

    let roles;
    //Provide defaults for all roles
    if(!rolesAddress[network]){
        roles = {
            "admin":        accounts[0],
            "masterMinter": accounts[0],
            "pauser":       accounts[0],
            "blacklister":  accounts[0],
            "owner":        accounts[0]
        }
    }
    else {
        roles = rolesAddress[network];
    }
    

    deployer.deploy(FiatToken,name,symbol,decimals,roles.masterMinter,roles.blacklister, roles.pauser);
}
