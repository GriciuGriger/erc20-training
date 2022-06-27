pragma solidity ^0.8.0;

import "./ExerciseSix.sol";

contract ExerciseSeven is ExerciseSix {

    enum Role{ MINTER, GLOBAL_PAUSER, TIME_AND_ADRESS_LOCKER, MARKETER }

    event AdministratorChanged(address previousAdminRole, address newAdminRole);
    event RoleGranted(Role role, address account);
    event RoleRevoked(Role role, address account);
    event RoleRenounced(Role role, address account);

    address private _administrator;

    mapping(address => mapping(Role => bool)) internal _hasRole;

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_,
    uint256 totalSupply_) ExerciseSix(symbol_, name_, decimals_, totalSupply_) {
        _administrator = msg.sender;
        _hasRole[msg.sender][Role.MINTER] = true;
        _hasRole[msg.sender][Role.GLOBAL_PAUSER] = true;
        _hasRole[msg.sender][Role.TIME_AND_ADRESS_LOCKER] = true;
        _hasRole[msg.sender][Role.MARKETER] = true;
    }

    modifier isAdmin() {
        require(_administrator == msg.sender, "ExerciseSeven: caller is not the admin");
        _;
    }

    modifier onlyRole(Role role) {
        require(hasRole(msg.sender, role), "ExerciseSeven: caller doesn't have this role");
        _;
    }

    function transferAdminRole(address newAdmin) public virtual isAdmin {

        address oldAdmin = _administrator;
        _administrator = newAdmin;
        emit AdministratorChanged(oldAdmin, newAdmin);
    }

    function hasRole(address account, Role role) internal view returns (bool){
        return _hasRole[account][role]; 
    }

    function grantRole(address account, Role role) external isAdmin {
        _hasRole[account][role] = true;
        emit RoleGranted(role, account);
    }
    
    function revokeRole(address account, Role role) external isAdmin {
        _hasRole[account][role] = false;
        emit RoleRevoked(role, account);
    }

    function renounceRole(Role role) external {
        _hasRole[msg.sender][role] = false;
        emit RoleRenounced(role, msg.sender);
    }

    function mint(address account, uint256 amount) public override onlyRole(Role.MINTER) {
        _mint(account, amount);
    } 

    function burn(address account, uint256 amount) public override onlyRole(Role.MINTER) {
        _burn(account, amount);
    }  

    function pause() public override onlyRole(Role.GLOBAL_PAUSER) {
        _pause();
    }

    function unpause() public override onlyRole(Role.GLOBAL_PAUSER) {
        _unpause();
    }

    function pauseAddress(address account) public override onlyRole(Role.GLOBAL_PAUSER) {
        _pauseAddress(account);
    }

    function unpauseAddress(address account) public override onlyRole(Role.TIME_AND_ADRESS_LOCKER) {
        _unpauseAddress(account);
    }

    function pauseBoth(address account) public override onlyRole(Role.TIME_AND_ADRESS_LOCKER) {
        _pauseBoth(account);
    }

    function unpauseBoth(address account) public override onlyRole(Role.TIME_AND_ADRESS_LOCKER) {
        _unpauseBoth(account);
    }

    function timelock(address account, uint256 time) public override onlyRole(Role.TIME_AND_ADRESS_LOCKER) {
        _timelock(account, time);
    }

    function changeBuyPrice(uint256 price) external override onlyRole(Role.MARKETER) {
        _changeBuyPrice(price);
    }

    function changeSellPrice(uint256 price) external override onlyRole(Role.MARKETER) {
        _changeSellPrice(price);
    }

    function withdraw(uint256 gweiToWithdraw) external override payable onlyRole(Role.MARKETER) {
        _withdraw(gweiToWithdraw);
    }
}
