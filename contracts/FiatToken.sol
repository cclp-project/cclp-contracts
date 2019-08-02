pragma solidity ^0.5.2;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import '@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol';
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import  "./Types.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";
import "./Pausable.sol";



/**
* @title FiatToken contract
* @dev This sontact was meant to work as a stable coin with upgradeability support.
*/
contract FiatToken is Ownable, ERC20Detailed, ERC20, Pausable {
	using SafeMath for uint256;

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
		bool mintedReturn = _increaseReserve(msg.sender, value);
		if( ! mintedReturn){
			revert("Minter Reserve can't be updated");
		}
		return true;
    }

	/**
	* @dev burnFrom is allowed only for a minter.
	* @param to : address
	* @param value : uint256
	*/
	function burnFrom(address to, uint256 value) public onlyMinter {
		require(balanceOf(to)>=value, "User Account does not have enough funds");
		_burn(to, value);
		bool burnedReturn = _decreaseReserve(msg.sender,value);
		if( !  burnedReturn){
			revert("Minter Reserve can't be updated");
		}
	}


	modifier onlyMinter() {
        require(masterMinter.isMinter(msg.sender),"Only Minter accounts can do that");
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

	mapping (address => uint256) private _mintersReserve;

	function _increaseReserve(address minter, uint256 amount) internal returns (bool) {
		_mintersReserve[minter] = _mintersReserve[minter].add(amount);
		emit MinterReserveUpdate(minter,amount,true);
		return true;
	}

	function _decreaseReserve(address minter, uint256 value) internal returns (bool) {
		require(value<=_mintersReserve[minter], "Value to reduce from minter reserve is upper than his reserve");
		_mintersReserve[minter] = _mintersReserve[minter].sub(value);
		emit MinterReserveUpdate(minter,value,false);
		return true;
	}

	function minterReserve(address minter) public view returns(uint256){
		require(masterMinter.isMinter(minter), "Account entered is not a minter");
		return _mintersReserve[minter];
	}

    /**
     * @dev Throws if called by any account other than the masterMinter
    */
    modifier onlyMasterMinter() {
        require(msg.sender == masterMinter.getMasterMinter(), "masterMinter address needed");
        _;
    }

	function transferReserve(address from,address to, uint256 amount) public onlyMasterMinter returns (bool) {
		require(masterMinter.isMinter(to), "Account entered is not a minter");
		require(minterReserve(from)>=amount, "Reserve of minter is lower than amount to transfer");
		return _increaseReserve(to,amount) && _decreaseReserve(from,amount);
	}

	event MinterReserveUpdate(
		address minter,
		uint256 value,
		bool increase
	);

}