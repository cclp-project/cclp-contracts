pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract MasterMinter is ERC20Mintable, Ownable  {
    
    event MasterMinterAdded(address indexed account);
    event MasterMinterChanged(address indexed newMasterMinter);

    address public masterMinter;

    constructor(address _masterMinter) public {
        masterMinter = _masterMinter;
    }

    /**
     * @dev Throws if called by any account other than the masterMinter
    */
    modifier onlyMasterMinter() {
        require(msg.sender == masterMinter, "masterMinter address needed");
        _;
    }

    /**
     * @dev add minter address, only the contract Owner can do that
    */
    function addMinter(address account) public onlyMasterMinter {
        _addMinter(account);
    }

    /**
     * @dev remobe a minter address, only the contract Owner can do that
    */
    function removeMinter(address account) public onlyMasterMinter {
        _removeMinter(account);
    }

    /**
     * @dev update the MasterMinter address, only the contract Owner can do that
    */
    function updateMasterMinter(address _newMasterMinter) public onlyOwner { 
        require(_newMasterMinter != address(0) && _newMasterMinter != msg.sender, "masterMinter has to be a real address and not the same");
        masterMinter = _newMasterMinter;
        emit MasterMinterChanged(masterMinter);
    }
    
}
