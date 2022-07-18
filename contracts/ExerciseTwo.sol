//SPDX-License Identifier: MIT
pragma solidity ^0.8.0;

import "./ExerciseOne.sol";

contract ExerciseTwo is ExerciseOne {

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_,
    uint256 totalSupply_) ExerciseOne(symbol_, name_, decimals_, totalSupply_) {}

    function mint(address account, uint256 amount) public virtual 
    {
        require(account != address(0), "Address 0 cannot mint tokens");
        _mint(account, amount);
    }

    function _mint(address account, uint256 amount) internal 
    {
        require(amount != 0, "Cannot mint 0 tokens");

        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public virtual 
    {
        require(account != address(0), "Address 0 cannot burn tokens");
        _burn(account, amount);
    }

    function _burn(address account, uint256 amount) internal
    {
        require(_balances[account] >= amount, "Burn amount exceeds balance");

        _totalSupply -= amount;
        _balances[account] -= amount;

        emit Transfer(account, address(0), amount);
    }

}