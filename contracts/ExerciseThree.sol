//SPDX-License Identifier: MIT
pragma solidity ^0.8.0;

import "./ExerciseTwo.sol";

contract ExerciseThree is ExerciseTwo {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address private _contractOwner;
    mapping(address => bool) internal ownershipAccepted;

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_,
    uint256 totalSupply_) ExerciseTwo(symbol_, name_, decimals_, totalSupply_) {
        _contractOwner = msg.sender;
        ownershipAccepted[address(0)] = true;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "ExerciseThree: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(ownershipAccepted[newOwner], "ExerciseThree: new owner is not accepting granted ownership");

        address oldOwner = _contractOwner;
        _contractOwner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        transferOwnership(address(0));
    }

    function acceptOwnership(bool flag) external {
        ownershipAccepted[msg.sender] = flag;
    }

    function mint(address account, uint256 amount) public override onlyOwner {
        super.mint(account, amount);
    }

   function burn(address account, uint256 amount) public override onlyOwner {
        super.burn(account, amount);
    }

   function owner() public view virtual returns (address) {
        return _contractOwner;
    }

}