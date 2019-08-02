const FiatToken = artifacts.require("./FiatToken.sol");
const MasterMinter = artifacts.require("./MasterMinter.sol");

contract("FiatToken Positive", accounts => {

    beforeEach(async() => {
        instance = await FiatToken.deployed();
        masterMinter = await MasterMinter.deployed();
    });

    /* Here starts the action */

    /* Mintable functions (Just for be sure)*/
    it("Check if the Minter is the msg.sender", async() => {

        assert.equal(await masterMinter.isMinter(accounts[0]), true);
    });

    it("Add new Minter and Check if isMinter", async() => {

        await masterMinter.addMinter(accounts[1])
        assert.equal(await masterMinter.isMinter(accounts[1]), true);
    });

    it("Mint 300 tokens from new Minter (accounts[1]) to account2 and get balance, Transfer event",
    async() => {

        const {logs} = await instance.mint(accounts[2], 300, {from: accounts[1]});
        assert.equal(await instance.balanceOf(accounts[2]), 300);
        assert.equal(logs[0].event, 'Transfer');
    });

    /* ERC20 functions (Just for be sure) */
    it("Making a transaction, 100 tokens from accounts[2] to 0", async() => {

        const {logs} = await instance.transfer(accounts[0], 100, {from: accounts[2]});
        assert.equal(logs[0].event, 'Transfer');
    });

    it("Check the new balanceOf accounts[0], sould be 100", async() => {

        assert.equal(await instance.balanceOf(accounts[0]), 100);
    });

    it("Check the Total Supply, sould be 300", async() => {

        assert.equal(await instance.totalSupply(), 300);
    });

    it("Making approve of 50 tokens and chek the allowance", async() => {
        const {logs} = await instance.approve(accounts[3], 50, {from: accounts[0]});
        assert.equal(await instance.allowance(accounts[0], accounts[3] ), 50);
    });

      it("Is the token decimals and symbol", async() => {
        
        assert.equal(await instance.decimals(),18);
        assert.equal(await instance.symbol(),"cCLP");
    });

    /* MasterMinter Contract */

    it("Update MasterMinter and check event", async() => {
        const {logs} = await masterMinter.updateMasterMinter(accounts[3], {from: accounts[0]});
        assert.equal(logs[0].event, 'MasterMinterChanged');
    });

    /* Check if the new MasterMinter works */
      it("Add new Minter and Check if isMinter with the new MasterMinter", async() => {
        await masterMinter.addMinter(accounts[5], {from: accounts[3]})
        assert.equal(await masterMinter.isMinter(accounts[5]), true);
    });

    it("Remove Minter and Check if is not Minter", async() => {
        await masterMinter.removeMinter(accounts[5], {from: accounts[3]})
        assert.equal(await masterMinter.isMinter(accounts[5]), false);
    });

    /* transerReserve */

    it("token supply must increese if a minter reserve increese", async()=>{
        let oldTotalSupply = await instance.totalSupply();
        console.log("oldTotalSupply:"+oldTotalSupply);
        let oldAccount0Reserve = await instance.minterReserve(accounts[0]);
        console.log("oldAccount0Reserve"+oldAccount0Reserve);
        await instance.mint(accounts[5],100,{from:accounts[0]});
        let currentTotalSupply = await instance.totalSupply();
        let currentAccount0Reserve = await instance.minterReserve(accounts[0]);
        console.log("currentTotalSupply:"+currentTotalSupply);
        console.log("currentAccount0Reserve:"+currentAccount0Reserve)
        assert.isTrue((currentTotalSupply-oldTotalSupply)==(currentAccount0Reserve-oldAccount0Reserve));
        assert.equal(100,currentTotalSupply-oldTotalSupply);
        assert.equal(100,currentAccount0Reserve-oldAccount0Reserve);
    });

    it("in transferReserve, reserve of account from should decrease and increase in account to", async () => {
        await instance.mint(accounts[7],100, {from: accounts[0]});
        let oldAccount0Reserve = await instance.minterReserve(accounts[0]);//minter 0 reserve
        await masterMinter.addMinter(accounts[9], {from: accounts[3]});
        let oldAccount9Reserve = await instance.minterReserve(accounts[9]);//minter 9 reserve
        await instance.transferReserve(accounts[0],accounts[9],100, {from: accounts[3]});
        let currentAccount0Reserve = await instance.minterReserve(accounts[0]);//minter 0 reserve
        let currentAccount9Reserve = await instance.minterReserve(accounts[9]);//minter 9 reserve
        let expectedAccount9Increased = oldAccount9Reserve+100;
        let expectedAccount0Decreased = oldAccount0Reserve-100;
        assert.equal(currentAccount0Reserve.toString(10) , expectedAccount0Decreased.toString(10).replace(/^0+/,""));
        assert.equal(currentAccount9Reserve.toString(10), expectedAccount9Increased.toString(10).replace(/^0+/,""));
    });

    
})

