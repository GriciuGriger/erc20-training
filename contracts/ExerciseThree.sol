//SPDX-License Identifier: MIT
pragma solidity ^0.8.0;

import "./ExerciseTwo.sol";

contract ExerciseThree is ExerciseTwo {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public _contractOwner;
    address public _pendingOwner;

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_,
    uint256 totalSupply_) ExerciseTwo(symbol_, name_, decimals_, totalSupply_) {
        _contractOwner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "ExerciseThree: caller is not the owner");
        _;
    }

    function transferOwnership(address pendingOwner_) public virtual onlyOwner {
        _pendingOwner = pendingOwner_;
    }

    function renounceOwnership() public virtual onlyOwner {
        _contractOwner = address(0);
    }

    function acceptOwnership(bool flag) external {
        require(msg.sender == _pendingOwner, "ExerciseThree: caller is not pending owner");
        require(flag, "ExerciseThree: pending owner rejects the ownership");

        address oldOwner = _contractOwner;
        _contractOwner = _pendingOwner;
        emit OwnershipTransferred(oldOwner, _contractOwner);
        
    }

    function mint(address account, uint256 amount) public virtual override onlyOwner {
        _mint(account, amount);
    }

   function burn(address account, uint256 amount) public virtual override onlyOwner {
        _burn(account, amount);
    }

   function owner() public view virtual returns (address) {
        return _contractOwner;
    }

}