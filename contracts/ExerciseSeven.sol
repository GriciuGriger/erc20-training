pragma solidity ^0.8.0;

import "./ExerciseFive.sol";
import "./ExerciseSix.sol";
import "./Market.sol";

contract ExerciseSeven is ExerciseFive {

    bytes32 public constant MINTER_ROLE = bytes32(uint256(0x01));
    bytes32 public constant PAUSER_ROLE = bytes32(uint256(0x02));
    bytes32 public constant ADDRESS_LOCK_ROLE = bytes32(uint256(0x03));
    bytes32 public constant MARKETER_ROLE = bytes32(uint256(0x04));

    event AdministratorChanged(address previousAdminRole, address newAdminRole);
    event RoleGranted(bytes32 role, address account);
    event RoleRevoked(bytes32 role, address account);
    event RoleRenounced(bytes32 role, address account);

    mapping(address => mapping(bytes32 => bool)) internal _hasRole;

    Market public market;

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_,
    uint256 totalSupply_) ExerciseFive(symbol_, name_, decimals_, totalSupply_) {
        _hasRole[msg.sender][MINTER_ROLE] = true;
        _hasRole[msg.sender][PAUSER_ROLE] = true;
        _hasRole[msg.sender][ADDRESS_LOCK_ROLE] = true;
        _hasRole[msg.sender][MARKETER_ROLE] = true;
    }

    modifier onlyRole(bytes32 role) {
        require(hasRole(msg.sender, role), "ExerciseSeven: caller doesn't have this role");
        _;
    }

    function transferAdminRole(address newAdmin) public virtual onlyOwner {

        address oldAdmin = _contractOwner;
        _contractOwner = newAdmin;
        emit AdministratorChanged(oldAdmin, newAdmin);
    }

    function hasRole(address account, bytes32 role) internal view returns (bool){
        return _hasRole[account][role]; 
    }

    function grantRole(address account, bytes32 role) external onlyOwner {
        _hasRole[account][role] = true;
        emit RoleGranted(role, account);
    }
    
    function revokeRole(address account, bytes32 role) external onlyOwner {
        _hasRole[account][role] = false;
        emit RoleRevoked(role, account);
    }

    function renounceRole(bytes32 role) external {
        _hasRole[msg.sender][role] = false;
        emit RoleRenounced(role, msg.sender);
    }

    function mint(address account, uint256 amount) public override onlyRole(MINTER_ROLE) {
        _mint(account, amount);
    } 

    function burn(address account, uint256 amount) public override onlyRole(MINTER_ROLE) {
        _burn(account, amount);
    }  

    function pause() public override onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public override onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function pauseAddress(address account) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _pauseAddress(account);
    }

    function unpauseAddress(address account) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _unpauseAddress(account);
    }

    function pauseBoth(address account) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _pauseBoth(account);
    }

    function unpauseBoth(address account) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _unpauseBoth(account);
    }

    function timelock(address account, uint256 time) public override onlyRole(ADDRESS_LOCK_ROLE) {
        _timelock(account, time);
    }

    function changeBuyPrice(uint256 price) external onlyRole(MARKETER_ROLE) {
        market.changeBuyPrice(price);
    }

    function changeSellPrice(uint256 price) external onlyRole(MARKETER_ROLE) {
        market.changeSellPrice(price);
    }

    function withdraw(uint256 gweiToWithdraw) external payable onlyRole(MARKETER_ROLE) {
        market.withdraw(gweiToWithdraw);
    }
}
