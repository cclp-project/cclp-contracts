pragma solidity ^0.5.2;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import  "./Types.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";
import "./Pausable.sol";



/**
* @title FiatToken contract
* @dev This sontact was meant to work as a stable coin with upgradeability support.
*/
contract FiatToken is Ownable, ERC20Detailed,ERC20Burnable, Pausable{

	Blacklistable public blacklister;
	MasterMinter public masterMinter;

	/**
	* @dev this function is needed by support uppgradeability
	* @param name : string. The name of this token ERC20.
	* @param symbol : string. ERC20 token symbol .
	* @param decimals : uint8. Decimals fractions that may have a token unit.
	* @param _masterMinter : MasterMinter.
	* @param _blacklister : Blacklistable.
	* @param _pauserRole : address.
	* @param owner : address.
	*/
	function initialize(string memory name,
		string memory symbol,
		uint8 decimals,
		MasterMinter _masterMinter,
		Blacklistable _blacklister,
		address _pauserRole,
		address owner) public initializer  {
		ERC20Detailed.initialize(name,symbol,decimals);
 		masterMinter = _masterMinter;
		emit InitializationLog("After Master Minter initialization");
		Pausable.initialize(_pauserRole);
		emit InitializationLog("After Initialize Pausable");
		blacklister = _blacklister;
		emit InitializationLog("After Black Lister setting");
		Ownable.initialize(owner);
		emit InitializationLog("After Ownable initialization");

	}


	/**
	* @dev Just to be sure at all
	*/
	function () external payable {
		revert();
	}
	
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public onlyMinter returns (bool) {
        _mint(to, value);
        return true;
    }

	modifier onlyMinter() {
        require(masterMinter.isMinter(msg.sender),"Only Minter accounts can mint()");
        _;
    }





	/**
	* @dev overriding ERC20.transfer with modifier whenNotPaused
	* @param to The address to transfer to.
	* @param value The amount to be transferred.
	*/
	function transfer(address to, uint256 value) public notBlacklisted(msg.sender) whenNotPaused returns(bool) {
		ERC20.transfer(to, value);
		return true;
	}

	function approve(address spender, uint256 value) public
	notBlacklisted(msg.sender)
	whenNotPaused returns (bool){
		ERC20.approve(spender, value);
		return true;
	}

    function transferFrom(address from, address to, uint256 value) public
	notBlacklisted(from)  notBlacklisted(to) whenNotPaused
	returns (bool){
		ERC20.transferFrom(from,to,value);
		return true;
	}

	/**
     * @dev Throws if argument account is blacklisted
     * @param _account The address to check
    */
    modifier notBlacklisted(address _account) {
        require(!blacklister.isBlacklisted(_account),
        "this account is marked in our blac-klist");
        _;
    }

	Types.Multihash public toSDocument;

	function setToSDocument(
		bytes32 digest,
		uint8 hashFuntion,
		uint8 size ) public onlyOwner
	{
		bytes32 oldDigest = toSDocument.digest;
		uint8 oldHashFunction = toSDocument.hashFunction;
		uint8 oldSize = toSDocument.size;

		toSDocument = Types.Multihash(digest,hashFuntion,size);
		emit MultihashChanged(
			oldDigest,oldHashFunction,oldSize,
			digest, hashFuntion, size);
	}

	event InitializationLog(
        string message
    );

	event MultihashChanged(
        bytes32 oldDigest,
		uint8 oldHashFunction,
		uint8 oldSize,
        bytes32 newDigest,
        uint8 newHashFunction,
        uint8 newSize
    );


}