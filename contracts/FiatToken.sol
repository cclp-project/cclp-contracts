pragma solidity ^0.5.2;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./MasterPauser.sol";
import "./MasterMinter.sol";
import "./Blacklistable.sol";



/**
* @title FiatToken contract
* @dev This sontact was meant to work as a stable coin with upgradeability support.
*/
contract FiatToken is Ownable, ERC20Detailed,ERC20Burnable{

	Blacklistable public blacklister;
	MasterMinter public masterMinter;
	MasterPauser public pauser;

	/**
	* @dev this function is needed by support uppgradeability
	* @param name : string. The name of this token ERC20.
	* @param symbol : string. ERC20 token symbol .
	* @param decimals : uint8. Decimals fractions that may have a token unit.
	* @param _masterMinter : MasterMinter.
	* @param _blacklister : Blacklistable.
	* @param _pauser : MasterPauser.
	* @param owner : address.
	*/
	function initialize(string memory name,
		string memory symbol,
		uint8 decimals,
		MasterMinter _masterMinter,
		Blacklistable _blacklister,
		MasterPauser _pauser,
		address owner) public initializer  {
		ERC20Detailed.initialize(name,symbol,decimals);
 		masterMinter = _masterMinter;
		pauser = _pauser;
		emit InitializationLog("After Master Minter initialization");
		blacklister = _blacklister;
		emit InitializationLog("After Black Lister setting");
		Ownable.initialize(owner);
		emit InitializationLog("After Ownable initialization");

	}

	/*function reInitialize(string memory name,
		string memory symbol,
		uint8 decimals,
		MasterMinter _masterMinter,
		Blacklistable _blacklister,
		MasterPauser _pauser,
		address owner) public onlyOwner {
		
		pauser.pause();
		
		}/*

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
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!pauser.paused(),"This contract is paused");
        _;
    }

	modifier whenPaused(){
		require(pauser.paused(),"This contract is not paused");
        _;
	}

	function paused() public view returns(bool){
		return pauser.paused();
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

	

	function helloworld() public pure returns(string memory){
		return "hola mundo feliz";
	}

	event InitializationLog(
        string message
    );

	event FallBackCallLog(
		address sender
	);
}