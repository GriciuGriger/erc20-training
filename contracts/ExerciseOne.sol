//SPDX-License Identifier: MIT
pragma solidity ^0.8.0;

contract ExerciseOne {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    string internal _symbol;
    string internal _name;

    uint256 internal _decimals;
    uint256 internal _totalSupply;

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_, 
    uint256 totalSupply_) {
        _symbol = symbol_;
        _name = name_;
        _decimals = decimals_;
        _totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
    }

    function transfer(address recipient,
    uint256 amount) public virtual {
        require(msg.sender != address(0) && recipient != address(0), "Transfer from or to the zero address");
        require(_balances[msg.sender] >= amount, "Insufficient funds to transfer");
        require(amount != 0, "0 money transfer not allowed");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        
        emit Transfer(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, 
    address recipient, 
    uint256 amount) public virtual {
        require(amount <= _balances[sender], "Transfer amount exceeds balance");
        require(amount <= _allowances[sender][msg.sender], "Transfer amount exceeds allowance");

        _balances[sender] -= amount;
        _allowances[sender][msg.sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public {
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

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function decimals() public view virtual returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }


}