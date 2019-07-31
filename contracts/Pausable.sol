pragma solidity ^0.5.2;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";

/**
*   @title Pausable behaviour
*/
contract Pausable is Initializable , Ownable {

    address pauserRole;
	bool private _paused;

    function initialize (address _pauserRole) public initializer {
        pauserRole = _pauserRole;
		emit PauserChanged(pauserRole);
        _paused = false;
    }


	function changePauser(address _pauserRole) public onlyOwner {
		pauserRole = _pauserRole;
		emit PauserChanged(pauserRole);
	}

	function isPauser(address anAddress) public view returns(bool){
		return pauserRole == anAddress;
	}

	modifier onlyPauser {
		require(msg.sender==pauserRole,"Only pauser role address can pause this contract");
		_;
	}

    event PauserChanged(address indexed pauser);

	function pause() public onlyPauser whenNotPaused {
		_paused = true;
	}

	function unpause() public onlyPauser whenPaused {
		_paused = false;
	}


    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused,"This contract is paused");
        _;
    }

	modifier whenPaused(){
		require(_paused,"This contract is not paused");
        _;
	}

	function isPaused() public view returns(bool){
		return _paused;
	}
}