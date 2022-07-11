pragma solidity ^0.8.0;

import "./ExerciseThree.sol";

contract ExerciseFour is ExerciseThree {

    event Paused(address account);
    event Unpaused(address account);

    bool public _paused;

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_,
    uint256 totalSupply_) ExerciseThree(symbol_, name_, decimals_, totalSupply_) {
        _paused = false;
    }

    modifier whenPaused() {
        require(isPaused(), "ExerciseFour: not paused");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused(), "ExerciseFour: paused");
        _;
    }

    function pause() public virtual onlyOwner whenNotPaused {
        _pause();
    }

    function _pause() internal {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public virtual onlyOwner whenPaused {
        _unpause();
    }

    function _unpause() internal {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function isPaused() public view returns (bool) {
        return _paused;
    }

    function burn(address account, uint256 amount) public override whenNotPaused
    {
        require(account != address(0), "Address 0 cannot burn tokens");
        _burn(account, amount);
    }

    function mint(address account, uint256 amount) public override whenNotPaused
    {
        require(account != address(0), "Address 0 cannot mint tokens");
        _mint(account, amount);
    }

    function transfer(address recipient,
    uint256 amount) public virtual override whenNotPaused returns(bool) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient,
    uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }

}