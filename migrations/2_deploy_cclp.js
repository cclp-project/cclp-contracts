let FiatToken = artifacts.require("./FiatToken.sol");
let MasterMinter = artifacts.require("./MasterMinter.sol");
let Blacklistable = artifacts.require("./Blacklistable.sol");

let Types = artifacts.require("./Types.sol");
let rolesAddress = require("./roles_address.js");


module.exports = async (deployer, network, accounts) => {
    console.log("Migrations - cCLP - Setting up")
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
    
    await deployer.deploy(Blacklistable);
    let blacklister = await Blacklistable.deployed();
    await blacklister.initialize(roles.blacklister,roles.owner);

    await deployer.deploy(MasterMinter);
    let masterMinter = await MasterMinter.deployed();
    await masterMinter.initialize(roles.masterMinter,roles.owner);



    await deployer.deploy(FiatToken);
    let fiatToken = await FiatToken.deployed();
    await fiatToken.initialize(name,symbol,decimals,masterMinter.address,blacklister.address,roles.pauser,roles.owner);

    console.log("fiatToken initialized");
}
