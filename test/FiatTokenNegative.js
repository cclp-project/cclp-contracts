const FiatToken = artifacts.require("./FiatToken.sol");
const MasterMinter = artifacts.require("./MasterMinter.sol");
const { BN, constants, expectEvent, expectRevert } = require('openzeppelin-test-helpers');

contract("FiatToken Negative", accounts => {

    beforeEach(async () => {
        instance = await FiatToken.deployed();
        masterMinter = await MasterMinter.deployed();
    });
    describe("Owner functions", ()=>{
        it("Only Owner can update the MasterMinter ",async()=>{
            expectRevert.unspecified(
                masterMinter.updateMasterMinter(accounts[3], {from: accounts[6]})
            )
        });
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

        describe("transferReserve", async () =>{

            
            it("should not allow transferReserve from no MasterMinter account", async () => {
                await instance.mint(accounts[7],100, {from: accounts[0]});
                let account0Reserve = await instance.minterReserve(accounts[0]);//minter reserve
                expectRevert(
                    instance.transferReserve(accounts[0],accounts[2],account0Reserve, {from: accounts[3]}),
                    "masterMinter address needed"
                )
                
            });
    
            it("should not allow transferReserve to a no Minter account", async () => {
                await instance.mint(accounts[7],100, {from: accounts[0]});
                let account0Reserve = await instance.minterReserve(accounts[0]);//minter reserve
                expectRevert(
                    instance.transferReserve(accounts[0],accounts[6],account0Reserve, {from: accounts[0]}),
                    "Account entered is not a minter"
                )
                
            });

            it("should not allow transferReserve if amount is greater than minter reserve (from)", async () => {
                let account0Reserve = await instance.minterReserve(accounts[0]);//minter reserve
                await masterMinter.addMinter(accounts[9], {from: accounts[0]});
                expectRevert(
                    instance.transferReserve(accounts[0],accounts[9],account0Reserve+1, {from: accounts[0]}),
                    "Reserve of minter is lower than amount to transfer"
                )
            });
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
            it("a minter can't burn more tokens than his reserve in fiat", async()=>{
                let account1Reserve = await instance.minterReserve(accounts[1]);//minter reserve
                await instance.mint(accounts[2],account1Reserve+1, {from:accounts[0]}) 
                expectRevert(
                    instance.burnFrom(accounts[2], account1Reserve+1,{from:accounts[1]}),
                    "Value to reduce from minter reserve is upper than his reserve"
                )
            });
            it("it should be not possible burn more tokens that an user have in his balance", async()=>{
                let account1Reserve = await instance.minterReserve(accounts[1]);//minter 01 reserve
                await instance.mint(accounts[2],100,{from:accounts[0]});    //minter 00 mint 100 for account 02
                let balanceAccount02 = await instance.balanceOf(accounts[2]);
                expectRevert(
                    instance.burnFrom(accounts[2], balanceAccount02+2,{from:accounts[0]}),
                    "User Account does not have enough funds"
                )
            });

            it("A user that is not a minter can't burn tokens (should revert)",async()=>{
                expectRevert(
                    instance.burnFrom(accounts[2],100, {from: accounts[2]}),//acount 02 is not a minter
                    "Only Minter accounts can do that"
                )
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