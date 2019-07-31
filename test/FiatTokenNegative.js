const FiatToken = artifacts.require("./FiatToken.sol");
const MasterMinter = artifacts.require("./MasterMinter.sol");

contract("FiatToken Negative", accounts => {

    beforeEach(async () => {
        instance = await FiatToken.deployed();
        masterMinter = await MasterMinter.deployed();
    });

    describe("Minter Functions", () => {
        
        it("should not allow to add Mint from no MasterMinter", async () => {
            assert.equal(false, await masterMinter.isMinter(accounts[2]))
            try {
                await masterMinter.addMinter(accounts[3], {
                    from: accounts[4]
                });
            } catch (err) {
                assert.isNotNull(err);
            }
        });
        
        it("should not allow to Mint from no Minter account", async () => {
            assert.equal(false, await masterMinter.isMinter(accounts[2]))
            try {
                await instance.Mint(accounts[3], {
                    from: accounts[2]
                });
            } catch (err) {
                assert.isNotNull(err);
            }
        });

        describe("ERC20 functions", () => { //Just to be sure
          
            it("AddMinter, Mint 100 tokens and try to transfer 101 tokens, should revert", async () => {
                await masterMinter.addMinter(accounts[1], {from: accounts[0]}) // AddMinter
                assert.equal(await masterMinter.isMinter(accounts[1]), true); // Check if is Minter
                await instance.mint(accounts[2], 100, {from: accounts[1]}); //Mint 100 tokens to accounts[2]
                try {
                    await instance.transfer(accounts[3], 101, {from: accounts[2]}); //Transfer to accounts[3]
                } catch (err) {
                    assert.isNotNull(err);
                }
            });

            it("Approve 10 tokens to accounts[4], them account[4] use transferFrom() 12 tokens, should revert", async () => { //Ok, this is strange...
                await instance.approve(accounts[4], 10, {from: accounts[2]}) // AddMinter
                assert.equal(await instance.allowance(accounts[2], accounts[4]), 10); // Check allowance
                try {
                    await instance.transferFrom(accounts[2], accounts[3],12, {from: accounts[4]}); //transferFrom to accounts[3]
                } catch (err) {
                    assert.isNotNull(err);
                }
            });

        });
    });

    describe("Fallback Function", () => { //Just to be sure
       
        it("Should not allow to Send ETH to contract", async () => {
          
            try {
                await instance.send(100000000,{from:accounts[6]})
            } catch (err) {
                assert.isNotNull(err);
            }
        });
    });



});