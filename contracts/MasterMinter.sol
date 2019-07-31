pragma solidity ^0.5.2;

import "@openzeppelin/contracts-ethereum-package/contracts/access/roles/MinterRole.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";

/**
*   @title MasterMinter role, is that who is resposable of add and remove another minters
*/
contract MasterMinter is Ownable, MinterRole {


    event MasterMinterAdded(address indexed account);
    event MasterMinterChanged(address indexed newMasterMinter);

    address public masterMinter;

    function initialize (
        address _masterMinter,
        address owner
        ) public initializer {
        masterMinter = _masterMinter;
        MinterRole.initialize(_masterMinter);
        Ownable.initialize(owner);
        emit MasterMinterChanged(masterMinter);
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
