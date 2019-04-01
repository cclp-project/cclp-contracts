const FiatToken = artifacts.require("./FiatToken.sol");

contract("FiatToken MasterMinter", accounts => {

    beforeEach(async() => {
        instance = await FiatToken.deployed();
    });

    /* Mintable functions*/
    it("should check if the masterMinter is account[0]", async() => {
        assert.equal(accounts[0], await instance.masterMinter());
    });

    describe("addMinter()", () =>{
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
    })

    describe("removeMinter()", () =>{
        it("should not allow another minter to remove minters", async() => {
            assert.equal(true, await instance.isMinter(accounts[1]))
            try{
                await instance.removeMinter(accounts[1], { from: accounts[1]});
            }catch(err){
                assert.isNotNull(err);
            }
            assert.equal(true, await instance.isMinter(accounts[1]))
            
        });

        it("should allow the masterMinter to remove minters", async() => {
            assert.equal(true, await instance.isMinter(accounts[1]))
            const tx = await instance.removeMinter(accounts[1], { from: accounts[0]});
            assert.equal(false, await instance.isMinter(accounts[1]))
            
            //Logs
            assert.equal("MinterRemoved",tx.logs[0].event);
            assert.equal(accounts[1],tx.logs[0].args.account);
        });
    
    })

    describe("updateMasterMinter()", () =>{
        it("should not allow to change masterMinter to 0x0", async() => {
            assert.equal(accounts[0], await instance.masterMinter());
            try{
                await instance.updateMasterMinter("0x0", { from: accounts[0]});
            }catch(err){
                assert.isNotNull(err);
            }
            assert.equal(accounts[0], await instance.masterMinter());
        });

        it("should not allow to change masterMinter to self", async() => {
            assert.equal(accounts[0], await instance.masterMinter());
            try{
                await instance.updateMasterMinter( accounts[0], { from: accounts[0]});
            }catch(err){
                assert.isNotNull(err);
            }
            assert.equal(accounts[0], await instance.masterMinter());
        });


        it("should allow the masterMinter to change masterMinter", async() => {
            assert.equal(accounts[0], await instance.masterMinter());
            const tx = await instance.updateMasterMinter(accounts[1], { from: accounts[0]});
            assert.equal(accounts[1], await instance.masterMinter());
            
            //Logs
            assert.equal("MasterMinterChanged",tx.logs[0].event);
            assert.equal(accounts[1],tx.logs[0].args.newMasterMinter);
        });
    
    })


});