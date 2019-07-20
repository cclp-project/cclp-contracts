pragma solidity ^0.5.2;

import "openzeppelin-eth/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-eth/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-eth/contracts/ownership/Ownable.sol";
import "openzeppelin-eth/contracts/lifecycle/Pausable.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";

/**
* @title FiatToken contract
* @dev This sontact was meant to work as a stable coin with upgradeability support.
*/
contract FiatToken is Ownable, ERC20Detailed, Pausable,  MasterMinter, ERC20Burnable, Blacklistable {


	/**
	* @dev this function is needed by support uppgradeability
	* @param name : string. The name of this token ERC20.
	* @param symbol : string. ERC20 token symbol .
	* @param decimals : uint8. Decimals fractions that may have a token unit.
	* @param masterMinterAddress : address.
	* @param blacklisterAddress : address.
	* @param pauser : address.
	* @param owner : address.
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

	/**
	* @dev Just to be sure at all
	*/
	function () external payable {
		revert("This contract is not meant to manage ether");
	}

	/**
	* @dev overriding ERC20.transfer with modifier whenNotPaused
	* @param to The address to transfer to.
	* @param value The amount to be transferred.
	*/
	function transfer(address to, uint256 value) public whenNotPaused notBlacklisted(msg.sender) returns(bool) {
		ERC20.transfer(to, value);
		return true;
	}



}