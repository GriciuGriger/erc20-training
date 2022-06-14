pragma solidity ^0.8.0;

import "./ExerciseFour.sol";

contract ExerciseFive is ExerciseFour {

    event AddressPaused(address account);
    event AddressUnpaused(address account);

    event AddressBothDirectionsPaused(address account);
    event AddressBothDirectionsUnpaused(address account);

    event TimeLocked(address account, uint256 time);
    event LockTimeExpiry(address account);


    mapping(address => bool) internal _outgoingTransfers;
    mapping(address => bool) internal _incomingTransfers;

    mapping(address => uint) public _lockTime;

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_,
    uint256 totalSupply_) ExerciseFour(symbol_, name_, decimals_, totalSupply_) {}

    modifier whenAddressNotPaused(address account) {
        require(!checkIfPaused(account), "ExerciseFive: this address is paused");
        _;
    }

    modifier whenAddressPaused(address account) {
        require(checkIfPaused(account), "ExerciseFive: this address is unpaused");
        _;
    } 

    modifier whenAddressNotInpaused(address account) {
        require(!checkIfInpaused(account), "ExerciseFive: this address is inpaused");
        _;
    }

    modifier whenAddressInpaused(address account) {
        require(checkIfInpaused(account), "ExerciseFive: this address is not inpaused");
        _;
    } 

    modifier nonTimelocked(address account) {
        require(block.timestamp >= _lockTime[account], "ExerciseFive: this address is timelocked"); 
        _;
        if(_lockTime[account] != 0) {
            _lockTime[account] = 0;
            emit LockTimeExpiry(account);
        }
    }

    function pauseAddress(address account) public onlyOwner whenAddressNotPaused(account) {
        _outgoingTransfers[account] = true;
        emit AddressPaused(account);
    }

    function unpauseAddress(address account) public onlyOwner whenAddressPaused(account) {
        _outgoingTransfers[account] = false;
        emit AddressUnpaused(account);
    }

    function pauseBoth(address account) public onlyOwner whenAddressNotInpaused(account) {

         if(!checkIfPaused(account)){
            _outgoingTransfers[account] = true;
         }

        _incomingTransfers[account] = true;

        emit AddressBothDirectionsPaused(account);
    }

     function unpauseBoth(address account) public onlyOwner whenAddressInpaused(account) {

        if(checkIfPaused(account)){
            _outgoingTransfers[account] = false;
        }

        _incomingTransfers[account] = false;

        emit AddressBothDirectionsUnpaused(account);
    }

    function timelock(address account, uint256 time) public onlyOwner 
        whenAddressNotPaused(account) 
        whenAddressNotInpaused(account) 
        nonTimelocked(account) {

        _lockTime[account] = block.timestamp + time;

        // _outgoingTransfers[account] = true;
        // _incomingTransfers[account] = true;

        emit TimeLocked(account, time);
    }

    function checkIfPaused(address account) public view returns (bool) {
        return _outgoingTransfers[account];
    }

    function checkIfInpaused(address account) public view returns (bool) {
        return _incomingTransfers[account];
    }

    function transfer(address recipient,
    uint256 amount) public virtual override whenAddressNotPaused(msg.sender) 
    whenAddressNotInpaused(recipient)
    nonTimelocked(msg.sender)
    nonTimelocked(recipient){
        super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient,
    uint256 amount) public virtual override whenAddressNotPaused(sender) 
    whenAddressNotInpaused(recipient) 
    nonTimelocked(sender) 
    nonTimelocked(recipient) {
        super.transferFrom(sender, recipient, amount);
    }




}