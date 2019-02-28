pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";


contract MasterMinter is ERC20Mintable  {
    
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

    function addMinter(address account) public onlyMasterMinter {
        _addMinter(account);
    }

    function removeMinter(address account) public onlyMasterMinter {
        _removeMinter(account);
    }

    function updateMasterMinter(address _newMasterMinter) public onlyMasterMinter { //or onlyOwner?
        require(_newMasterMinter != address(0) && _newMasterMinter != msg.sender, "masterMinter has to be an real address and not the same");
        masterMinter = _newMasterMinter;
        emit MasterMinterChanged(masterMinter);
    }
    
}
