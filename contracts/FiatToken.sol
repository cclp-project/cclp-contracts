pragma solidity ^0.5.0;
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";

/**
@dev By the moment, the Owner address is the msg.sender
 */
contract FiatToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, Pausable, MasterMinter, Blacklistable {

   

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address masterMinterAddress,
        address blacklisterAddress,
        address pauser
    )
    MasterMinter(masterMinterAddress)
    Blacklistable(blacklisterAddress)
    ERC20Burnable()
    ERC20Mintable()
    ERC20Detailed(name, symbol, decimals)
    ERC20()
    public {
      addPauser(pauser);
      renouncePauser();
    }

    /**
    * @dev Just to be sure at all
     */
    function () external payable {
      revert();
    }

    /**
    * @dev overriding ERC20.transfer with modifier whenNotPaused
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
        ERC20.transfer(to, value);
        return true;
    }

    

}