pragma solidity ^0.5.2;
import '@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol';
/**
@dev Code based on https://github.com/saurfang/ipfs-multihash-on-solidity
 */
library Types{
    struct Multihash{
        bytes32 digest ;
        uint8 hashFunction;
        uint8 size;
    }

}