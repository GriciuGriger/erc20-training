pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./ExerciseFive.sol";
import "./ExerciseSix.sol";

abstract contract ExerciseEight is ERC20, Pausable, AccessControl, ExerciseSix {

    bytes32 public constant MINTER_ROLE = bytes32(uint256(0x01));
    bytes32 public constant PAUSER_ROLE = bytes32(uint256(0x02));
    bytes32 public constant ADDRESS_LOCK_ROLE = bytes32(uint256(0x03));
    bytes32 public constant MARKETER_ROLE = bytes32(uint256(0x04));

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_,
    uint256 totalSupply_) ERC20(symbol_, name_) {
        _mint(msg.sender, totalSupply_);
    }

    modifier whenNotPaused() override(Pausable, ExerciseFour) {
        _;
    }

    modifier whenPaused() override(Pausable, ExerciseFour) {
        _;
    }

    function mint(address account, uint256 amount) public override onlyRole(MINTER_ROLE) {
        _mint(account, amount);
    } 

    function _mint(address account, uint256 amount) internal override(ERC20, ExerciseTwo) {
        ERC20._mint(account, amount);
    } 

    function burn(address account, uint256 amount) public override onlyRole(MINTER_ROLE) {
        _burn(account, amount);
    }  

    function _burn(address account, uint256 amount) internal override(ERC20, ExerciseTwo) {
        ERC20._burn(account, amount);
    }  

    function pause() public override onlyRole(PAUSER_ROLE) {
        _pause();
    }
 
    function _pause() internal override(Pausable, ExerciseFour) {
        Pausable._pause();
    }

    function unpause() public override onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _unpause() internal override(Pausable, ExerciseFour) {
        Pausable._unpause();
    }

    function pauseAddress(address account) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _pauseAddress(account);
    }

    function unpauseAddress(address account) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _unpauseAddress(account);
    }

    function timelock(address account, uint256 time) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _timelock(account, time);
    }

    function changeBuyPrice(uint256 price) external override onlyRole(MARKETER_ROLE) {
        _changeBuyPrice(price);
    }

    function changeSellPrice(uint256 price) external override onlyRole(MARKETER_ROLE) {
        _changeSellPrice(price);
    }

    function withdraw(uint256 gweiToWithdraw) external override payable onlyRole(MARKETER_ROLE) {
        _withdraw(gweiToWithdraw);
    }

    function transfer(
    address recipient,
    uint256 amount
    ) 
        public 
        virtual 
        override(ERC20, ExerciseFive)  
        whenAddressNotInpaused(recipient)
        whenAddressNotPaused(msg.sender) 
        nonTimelocked(recipient)
        nonTimelocked(msg.sender) 
        returns (bool)
    {
        return ERC20.transfer(recipient, amount);
    }

    function transferFrom(
    address sender, 
    address recipient,
    uint256 amount
    ) 
        public 
        virtual 
        override(ERC20, ExerciseFive) 
        whenAddressNotInpaused(recipient) 
        whenAddressNotPaused(sender) 
        nonTimelocked(recipient) 
        nonTimelocked(sender) 
        returns (bool)
    {
        return ERC20.transferFrom(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public override(ERC20, ExerciseOne) returns(bool) {
        return ERC20.approve(spender, amount);
    }

    function balanceOf(address account) public view override(ERC20, ExerciseOne) returns (uint256) {
        return ERC20.balanceOf(account);
    }

    function allowance(address owner, address spender) public view override(ERC20, ExerciseOne) returns (uint256) {
        return ERC20.allowance(owner, spender);
    }

    function symbol() public view override(ERC20, ExerciseOne) returns (string memory) {
        return ERC20.symbol();
    }

    function name() public view override(ERC20, ExerciseOne) returns (string memory) {
        return ERC20.name();
    }

    function decimals() public view override(ERC20, ExerciseOne) returns (uint8) {
        return ERC20.decimals();
    }

    function totalSupply() public view override(ERC20, ExerciseOne) returns (uint256) {
        return ERC20.totalSupply();
    }

}