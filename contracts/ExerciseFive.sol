pragma solidity ^0.8.0;

import "./ExerciseFour.sol";
import "hardhat/console.sol";

contract ExerciseFive is ExerciseFour {

    event AddressPaused(address account);
    event AddressUnpaused(address account);

    event AddressBothDirectionsPaused(address account);
    event AddressBothDirectionsUnpaused(address account);

    event TimeLocked(address account, uint256 time);
    event LockTimeExpiry(address account);

    mapping(address => bool) internal _outgoing;
    mapping(address => bool) internal _incoming;

    mapping(address => uint) public _lockTime;

    constructor(string memory symbol_, 
    string memory name_, 
    uint8 decimals_,
    uint256 totalSupply_) ExerciseFour(symbol_, name_, decimals_, totalSupply_) {}

    modifier whenAddressNotPaused(address account) {
        require(!checkIfPaused(account), "ExerciseFive: this address is paused");
        _;
    }

    modifier whenAddressPaused(address account) {
        require(checkIfPaused(account), "ExerciseFive: this address is unpaused");
        _;
    } 

    modifier whenAddressNotPausedInBothDirections(address account) {
        require(!checkIfInpaused(account), "ExerciseFive: this address is inpaused");
        _;
    }

    modifier whenAddressPausedInBothDirections(address account) {
        require(checkIfInpaused(account), "ExerciseFive: this address is not inpaused");
        _;
    } 

    modifier nonTimelocked(address account) {
        require(block.timestamp >= _lockTime[account], "ExerciseFive: this address is timelocked"); 
        if(_lockTime[account] != 0) {
            _lockTime[account] = 0;
            emit LockTimeExpiry(account);
        }
        _;
    }

    function pauseAddress(address account) public virtual onlyOwner {
        _pauseAddress(account);
    }

    function _pauseAddress(address account) internal 
    whenAddressNotPaused(account) {
        _outgoing[account] = true;
        emit AddressPaused(account);
    }

    function unpauseAddress(address account) public virtual onlyOwner {
        _unpauseAddress(account);
    }

    function _unpauseAddress(address account) internal 
    whenAddressPaused(account) {
        _outgoing[account] = false;
        emit AddressUnpaused(account);
    }

    function pauseBoth(address account) public virtual onlyOwner {
        _pauseBoth(account);
    }

    function _pauseBoth(address account) internal 
    whenAddressNotPausedInBothDirections(account) {

        // if(!checkIfPaused(account)){
            _outgoing[account] = true;
        // }

        _incoming[account] = true;

        emit AddressBothDirectionsPaused(account);
    }

    function unpauseBoth(address account) public virtual onlyOwner 
    {
        _unpauseBoth(account);
    }

    function _unpauseBoth(address account) internal 
    whenAddressPausedInBothDirections(account) 
    {

        //if(checkIfPaused(account)){
            _outgoing[account] = false;
       // }

        _incoming[account] = false;

        emit AddressBothDirectionsUnpaused(account);
    }

    function timelock(address account, uint256 time) 
        public 
        virtual 
        onlyOwner 
    {
         _timelock(account, time);
    }

    function _timelock(address account, uint256 time) internal 
        whenAddressNotPaused(account) 
        whenAddressNotPausedInBothDirections(account) 
        nonTimelocked(account)  {

        _lockTime[account] = block.timestamp + time;

        emit TimeLocked(account, time);
    }

    function checkIfPaused(address account) public view returns (bool) {
        return _outgoing[account];
    }

    function checkIfInpaused(address account) public view returns (bool) {
        return _incoming[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) 
        public 
        virtual 
        override 
        whenAddressNotPausedInBothDirections(recipient)
        whenAddressNotPaused(msg.sender) 
        nonTimelocked(recipient)
        nonTimelocked(msg.sender) 
        returns (bool)
    {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, 
    address recipient,
    uint256 amount
    ) 
        public 
        virtual 
        override 
        whenAddressNotPausedInBothDirections(recipient) 
        whenAddressNotPaused(sender) 
        nonTimelocked(recipient) 
        nonTimelocked(sender) 
        returns (bool)
    {
        return super.transferFrom(sender, recipient, amount);
    }

}