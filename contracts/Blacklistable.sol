pragma solidity ^0.5.2;
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

/**
 * @title Blacklistable Token
 * @dev Allows accounts to be blacklisted by a "blacklister" role
*/
contract Blacklistable is Ownable {

    address public blacklister;
    mapping(address => bool) internal blacklisted;

    event Blacklisted(address indexed _account);
    event UnBlacklisted(address indexed _account);
    event BlacklisterChanged(address indexed newBlacklister);

    function initialize (address _blacklister, address _owner) public initializer {
        blacklister = _blacklister;
        emit BlacklisterChanged(blacklister);
        Ownable.initialize(_owner);
    }

    /**
     * @dev Throws if called by any account other than the blacklister
    */
    modifier onlyBlacklister(){
        require(msg.sender == blacklister,
        "Only Blacklister Role can call this method");
        _;
    }

    /**
     * @dev Throws if argument account is blacklisted
     * @param _account The address to check
    */
    modifier notBlacklisted(address _account) {
        require(blacklisted[_account] == false,
        "this account is marked in our  blac-klist");
        _;
    }

    /**
     * @dev Checks if account is blacklisted
     * @param _account The address to check
     */
    function isBlacklisted(address _account) public view returns (bool) {
        return blacklisted[_account];
    }

    /**
     * @dev Adds account to blacklist
     * @param _account The address to blacklist
    */
    function blacklist(address _account) public onlyBlacklister {
        blacklisted[_account] = true;
        emit Blacklisted(_account);
    }

    /**
     * @dev Removes account from blacklist
     * @param _account The address to remove from the blacklist
    */
    function unBlacklist(address _account) public onlyBlacklister {
        blacklisted[_account] = false;
        emit UnBlacklisted(_account);
    }

    function updateBlacklister(address _newBlacklister) public onlyOwner {
        require(_newBlacklister != address(0), "blacklister is 0x0");
        blacklister = _newBlacklister;
        emit BlacklisterChanged(blacklister);
    }
}