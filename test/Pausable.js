const FiatToken = artifacts.require("./FiatToken.sol");
const { BN, constants, expectEvent, expectRevert } = require('openzeppelin-test-helpers');


contract("FiatToken Pausable", accounts => {
    beforeEach(async() => {
        instance = await FiatToken.deployed();
    });
    // 
    it("should check if account[1] is pauser", async() =>{
        assert.isTrue(await instance.isPauser(accounts[1]));
    });
      
    it("should check tha account[0] isn't a pauser",async()=>{
        assert.isFalse(await instance.isPauser(accounts[0]));
    });
    it("Tranfer when paused, Mint 100 tokens and try to transfer 100 tokens with contract paused, should revert", async () => {
        await instance.addMinter(accounts[1], {from: accounts[0]}) ;// AddMinter
        await instance.pause({from: accounts[1]}); //default pauser is accouts[1]
        assert.equal(await instance.isMinter(accounts[1]), true); // Check if is Minter
        await instance.mint(accounts[2], 100, {from: accounts[1]}); //Mint 100 tokens to accounts[2]
        await expectRevert.unspecified( 
            instance.transfer(accounts[3], 100, {from: accounts[2]})
        ); //Transfer to accounts[3]

    });

    it("Transfer when not is paused, Mint 100 tokens and try to transfer 100 tokens with contract unpaused, should be ok", async () => {
        //await instance.addMinter(accounts[1], {from: accounts[0]}) ;// AddMinter
        await instance.unpause({from: accounts[1]}); //default pauser is accouts[1]
        assert.equal(await instance.isMinter(accounts[1]), true); // Check if is Minter
        await instance.mint(accounts[2], 100, {from: accounts[1]}); //Mint 100 tokens to accounts[2]
        const result = await instance.transfer.call(accounts[3], 100, {from: accounts[2]}); //Transfer to accounts[3]
        assert.isTrue(result);
    });
});