const bs58 = require('bs58')
const FiatToken = artifacts.require("./FiatToken.sol");
const { BN, constants, expectEvent, expectRevert } = require('openzeppelin-test-helpers');


contract("FiatToken Terms of Service", accounts => {

    beforeEach(async () => {
        instance = await FiatToken.deployed();
    });


    describe("setToSDocument()", () => {
        it('should store an ipfs address', async () => {
            //there is a Mit license in https://gateway.ipfs.io/ipfs/QmXgdjeV1c5VU4Cz6hVA36UsTXm1qu1QWjChyMYUSPFmy3
            let mitFileHash = 'QmXgdjeV1c5VU4Cz6hVA36UsTXm1qu1QWjChyMYUSPFmy3';
            const mitBytes = bs58.decode(mitFileHash);
            let mitHexStr = mitBytes.toString('hex');
            let hashfunctionCode = parseInt(mitHexStr.substr(0, 2), 16); //18
            let hashSize = parseInt(mitHexStr.substr(2, 2), 16); //32
            //let digest = web3.utils.hexToBytes('0x'+mitHexStr.substr(4));
            let digest = '0x' + mitHexStr.substr(4);
            const { logs } = await instance.setToSDocument(digest, hashfunctionCode, hashSize,{from:accounts[0]});
            //Los numeros en expect se transforman a BN... particularidades del framework :/
            expectEvent.inLogs(logs, 'MultihashChanged', { oldDigest: '0x0000000000000000000000000000000000000000000000000000000000000000', oldHashFunction: new BN(0), oldSize: new BN(0), newDigest: digest, newHashFunction: new BN(hashfunctionCode), newSize: new BN(hashSize) });
        });
        it('should return ipfs hash data',async()=>{

        });
    });
})