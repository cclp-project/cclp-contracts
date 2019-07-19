pragma solidity ^0.5.0;
import "./ERC20DetailedInitializable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";

/**
@dev By the moment, the Owner address is the msg.sender
 */
contract FiatToken is Initializable , ERC20DetailedInitializable, ERC20Burnable, Pausable, MasterMinter, Blacklistable {

   

    /**
    * @dev this function is needed by support upgreadability 
     */
    function initialize(string memory name,
        string memory symbol,
        uint8 decimals,
        address masterMinterAddress,
        address blacklisterAddress,
        address pauser) public initializer  {

      MasterMinter.initialize(masterMinterAddress);
      Blacklistable.initialize(blacklisterAddress);
      ERC20DetailedInitializable.initialize(name,symbol,decimals);
      //Add a pauser only make sense if pauser is distinct to deployer user (msg.sender), because deployer is a pauser by default in Open Zeppelling Pausable.sol
      if(pauser!=msg.sender){
        addPauser(pauser);
        //deployer renounce to be a pauser after add other pauser account
        renouncePauser();
      }
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
    function transfer(address to, uint256 value) public whenNotPaused notBlacklisted(msg.sender) returns (bool) {
        ERC20.transfer(to, value);
        return true;
    }

    

}