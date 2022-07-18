pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./ExerciseFive.sol";

contract ExerciseEight is ERC20, Pausable, AccessControl {

    bytes32 public constant MINTER_ROLE = bytes32(uint256(0x01));
    bytes32 public constant PAUSER_ROLE = bytes32(uint256(0x02));
    bytes32 public constant ADDRESS_LOCK_ROLE = bytes32(uint256(0x03));
    bytes32 public constant MARKETER_ROLE = bytes32(uint256(0x04));

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_,
    uint256 totalSupply_) ERC20(symbol_, name_) {
        _mint(msg.sender, totalSupply_);
    }

    function mint(address account, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(account, amount);
    } 

    function burn(address account, uint256 amount) public onlyRole(MINTER_ROLE) {
        _burn(account, amount);
    }  

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }
 
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }
  
}