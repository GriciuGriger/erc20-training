//SPDX-License Identifier: MIT
pragma solidity ^0.8.0;

contract ExerciseOne {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    string public _symbol;
    string public _name;

    uint256 public _totalSupply;
    uint8 public _decimals;

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_, 
    uint256 totalSupply_) {
        _symbol = symbol_;
        _name = name_;
        _decimals = decimals_;
        _totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    function transfer(address recipient, 
    uint256 amount) public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function _transfer(address sender,
    address recipient,
    uint256 amount) internal virtual {
        require(_balances[sender] >= amount, "Insufficient funds to transfer");
        require(amount != 0, "0 money transfer not allowed");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        
        emit Transfer(sender, recipient, amount);
    }

    function transferFrom(address sender, 
    address recipient, 
    uint256 amount) public virtual returns (bool) {
        require(amount <= _allowances[sender][msg.sender], "Transfer amount exceeds allowance");

        _allowances[sender][msg.sender] -= amount;
        _transfer(sender, recipient, amount);

        return true;
    }

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(spender, amount);
        return true;
    }

    function _approve(address spender, uint256 amount) internal virtual {
        require(msg.sender != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    //REDUNDANT

    // function symbol() public view virtual returns (string memory) {
    //     return _symbol;
    // }

    // function name() public view virtual returns (string memory) {
    //     return _name;
    // }

    // function decimals() public view virtual returns (uint8) {
    //     return _decimals;
    // }

    // function totalSupply() public view virtual returns (uint256) {
    //     return _totalSupply;
    // }


}