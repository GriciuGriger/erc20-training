//SPDX-License Identifier: MIT
pragma solidity ^0.8.0;

import "./ExerciseOne.sol";

contract ExerciseTwo is ExerciseOne {

    event TokenMinted(address indexed from, address indexed to, uint256 value);
    event TokenBurnt(address indexed to, address indexed from, uint256 value);

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_,
    uint256 totalSupply_) ExerciseOne(symbol_, name_, decimals_, totalSupply_) {}

    function mint(address account, uint256 amount) public virtual 
    {
        _mint(account, amount);
    }

    function _mint(address account, uint256 amount) internal 
    {
        require(amount != 0, "Cannot mint 0 tokens");

        _totalSupply += amount;
        _balances[account] += amount;

        emit TokenMinted(msg.sender, account, amount);
    }

    function burn(address account, uint256 amount) public virtual 
    {
        _burn(account, amount);
    }

    function _burn(address account, uint256 amount) internal
    {
        require(_balances[account] >= amount, "Burn amount exceeds balance");

        _totalSupply -= amount;
        _balances[account] -= amount;

        emit TokenBurnt(account, msg.sender, amount);
    }

}