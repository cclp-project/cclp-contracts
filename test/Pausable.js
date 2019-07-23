const FiatToken = artifacts.require("./FiatToken.sol");
const MasterMinter = artifacts.require("./MasterMinter.sol");
const MasterPauser = artifacts.require("./MasterPauser.sol");
const { BN, constants, expectEvent, expectRevert } = require('openzeppelin-test-helpers');


contract("FiatToken Pausable", accounts => {
    beforeEach(async() => {
        instance = await FiatToken.deployed();
        masterPauser = await MasterPauser.deployed();
        masterMinter = await MasterMinter.deployed();
    });
    // 
    it("should check if account[0] is pauser", async() =>{
        assert.isTrue(await masterPauser.isPauser(accounts[0]));
    });
      
    it("should check tha account[0] isn't a pauser",async()=>{
        assert.isFalse(await masterPauser.isPauser(accounts[2]));
    });
    it("Tranfer when paused, Mint 100 tokens and try to transfer 100 tokens with contract paused, should revert", async () => {
        assert.equal(await masterMinter.isMinter(accounts[0]), true); // Check if is Minter
        await instance.mint(accounts[2], 100, {from: accounts[0]}); //Mint 100 tokens to accounts[2]
        assert.isTrue(await masterPauser.isPauser(accounts[0]));
        await masterPauser.pause({from: accounts[0]}); //default pauser is accouts[0]
        assert.isTrue(await masterPauser.paused());
        await expectRevert( 
            instance.transfer(accounts[3], 100, {from: accounts[2]}),
           "This contract is paused"
        ); 
        
    });
    it("Transfer when not is paused, Mint 100 tokens and try to transfer 100 tokens with contract unpaused, should be ok", async () => {
        assert.isTrue(await instance.paused());
        await masterPauser.unpause({from: accounts[0]}); //default pauser is accouts[1]
        await instance.mint(accounts[2], 100, {from: accounts[0]}); //Mint 100 tokens to accounts[2]
        const result = await instance.transfer.call(accounts[3], 100, {from: accounts[2]}); //Transfer to accounts[3]
        assert.isTrue(result);
    });

});