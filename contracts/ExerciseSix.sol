pragma solidity ^0.8.0;

import "./Market.sol";

abstract contract ExerciseSix is Market {

    // event ETHWithdrawn(address by, uint256 amountWithdrawn);

    // constructor(string memory symbol_, 
    // string memory name_, 
    // uint8 decimals_,
    // uint256 totalSupply_) ExerciseThree(symbol_, name_, decimals_, totalSupply_) {
    //     _changeBuyPrice(1 gwei);
    //     _changeSellPrice(0.5 gwei);
    // }

    // function withdraw(uint256 gweiToWithdraw) external virtual payable onlyOwner {
    //     _withdraw(gweiToWithdraw);
    // }

    // function _withdraw(uint256 gweiToWithdraw) internal  
    // {
    //     uint256 contractBalance = address(this).balance;
    //     uint256 costOfLeftTokens = _totalSupply * _sellPrice;
        
    //     require(contractBalance - gweiToWithdraw >= costOfLeftTokens, "The amount of ether to withdraw exceeds cost of tokens left");
 
    //     (bool success, ) = payable(msg.sender).call{value: gweiToWithdraw}("");   
    //     require(success, "Failed to withdraw Ether");     

    //     emit ETHWithdrawn(msg.sender, gweiToWithdraw);
    // }

    // receive() external payable {
        
    //     uint256 amount = msg.value / _buyPrice;

    //     _mint(msg.sender, amount);

    //     emit TokenPurchase(msg.sender, amount, _buyPrice);
    // }

}