pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "./MasterMinter.sol";
contract FiatToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, MasterMinter {

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address masterMinterAddress
    )
        MasterMinter(masterMinterAddress)
        ERC20Burnable()
        ERC20Mintable()
        ERC20Detailed(name, symbol, decimals)
        ERC20()
        public
    {}
}