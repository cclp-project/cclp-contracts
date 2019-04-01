pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";

/**
@dev By the moment, the Owner address is the msg.sender
 */
contract FiatToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, MasterMinter, Blacklistable {

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address masterMinterAddress,
        address blacklisterAddress
    )
    MasterMinter(masterMinterAddress)
    Blacklistable(blacklisterAddress)
    ERC20Burnable()
    ERC20Mintable()
    ERC20Detailed(name, symbol, decimals)
    ERC20()
    public {}

    /**
    * @dev Just to be sure at all
     */
    function () external payable {
      revert();
    }

}