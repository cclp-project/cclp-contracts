pragma solidity ^0.5.0;
import "openzeppelin-eth/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-eth/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-eth/contracts/ownership/Ownable.sol";
import "openzeppelin-eth/contracts/lifecycle/Pausable.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";

/**
@dev By the moment, the Owner address is the msg.sender
 */
contract FiatToken is Initializable, Ownable, ERC20Detailed, Pausable,  MasterMinter, ERC20Burnable, Blacklistable {

    /**
    * @dev this function is needed by support upgreadability 
     */
    function initialize(string memory name,
        string memory symbol,
        uint8 decimals,
        address masterMinterAddress,
        address blacklisterAddress,
        address pauser,
        address owner) public initializer  {

      MasterMinter.initialize(masterMinterAddress);
      Blacklistable.initialize(blacklisterAddress);
      ERC20Detailed.initialize(name,symbol,decimals);
      MasterMinter.initialize(masterMinterAddress);
      Ownable.initialize(owner);
      Pausable.initialize(pauser);
    }

    function cantidadCuentas() public view returns(uint256){
      return totalSupply();
    }

    /**
    * @dev Just to be sure at all
     */
   /** function () external payable {
      revert();
    }*/

    /**
    * @dev overriding ERC20.transfer with modifier whenNotPaused
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public whenNotPaused notBlacklisted(msg.sender) returns (bool) {
    //function transfer(address to, uint256 value) public  notBlacklisted(msg.sender) returns (bool) {
        ERC20.transfer(to, value);
        return true;
    }

    

}