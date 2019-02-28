const FiatToken = artifacts.require("./FiatToken.sol");

contract("FiatToken Minter", accounts => {

    beforeEach(async() => {
        instance = await FiatToken.deployed();
    });

    /* Mintable functions*/
    it("should check if the masterMinter is account[0]", async() => {
        assert.equal(accounts[0], await instance.masterMinter());
    });

    it("should allow the masterMinter to add minters", async() => {
        assert.equal(false, await instance.isMinter(accounts[1]))
        const tx = await instance.addMinter(accounts[1], { from: accounts[0]});
        assert.equal(true, await instance.isMinter(accounts[1]))
        
        //Logs
        assert.equal("MinterAdded",tx.logs[0].event);
        assert.equal(accounts[1],tx.logs[0].args.account);
    });

    it("should not allow another minter to add minters", async() => {
        assert.equal(true, await instance.isMinter(accounts[1]))
        assert.equal(false, await instance.isMinter(accounts[2]))
        try{
            await instance.addMinter(accounts[2], { from: accounts[1]});
        }catch(err){
            assert.isNotNull(err);
        }
        assert.equal(false, await instance.isMinter(accounts[2]))
        
    });


});