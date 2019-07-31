pragma solidity ^0.5.2;


import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";

/**
*   @title MasterPauser role, is that who is resposable of add and remove another pausers.
*/
contract MasterPauser is Ownable, Pausable {


    event MasterPauserAdded(address indexed account);
    event MasterPauserChanged(address indexed newMasterPauser);

    address public masterPauser;

    function initialize (
        address _masterPauser,
        address owner
        ) public initializer {
        masterPauser = _masterPauser;
        PauserRole.initialize(_masterPauser);
        Ownable.initialize(owner);
        emit MasterPauserChanged(_masterPauser);
    }

    /**
     * @dev Throws if called by any account other than the masterPauser
    */
    modifier onlyMasterPauser() {
        require(msg.sender == masterPauser, "masterPauser address needed");
        _;
    }


    /**
     * @dev add pauser address, only the contract Owner can do that
    */
    function addPauser(address account) public onlyMasterPauser {
        _addPauser(account);
    }


    /**
     * @dev remove a pauser address, only the contract Owner can do that
    */
    function removePauser(address account) public onlyMasterPauser {
        _removePauser(account);
    }

    /**
     * @dev update the MasterPauser address, only the contract Owner can do that
    */
    function updateMasterPauser(address _newMasterPauser) public onlyOwner {
        require(_newMasterPauser != address(0) && _newMasterPauser != msg.sender, "masterPauser has to be a real address and not the same");
        masterPauser = _newMasterPauser;
        emit MasterPauserChanged(masterPauser);
    }

}
