pragma solidity ^0.8.0;

import "./ExerciseFive.sol";
import "hardhat/console.sol";


contract ExerciseSix is ExerciseFive {

    event TokenPurchase(address purchaser, uint256 amount, uint256 price);
    event TokenSale(address seller, uint256 amount, uint256 price);

    event TokenBuyPriceChanged(address by, uint256 price);
    event TokenSellPriceChanged(address by, uint256 price);

    event ETHWithdrawn(address by, uint256 amountWithdrawn);

    address payable private _payout;
    uint256 private _buyPrice;
    uint256 private _sellPrice;

    constructor(string memory symbol_, 
    string memory name_, 
    uint256 decimals_,
    uint256 totalSupply_) ExerciseFive(symbol_, name_, decimals_, totalSupply_) {
        _payout = payable(address(this));
        _buyPrice = 1 gwei;
        _sellPrice = 0.5 gwei;
    }
  
    function buyTokens(uint256 amount) external payable 
    {
        uint256 totalCost = amount * _buyPrice;
       //require(msg.value == totalCost && amount != 0, "Invalid Amount Sent");
    
        _mint(msg.sender, amount);

        (bool success, ) = 
        _payout.call{value: totalCost}("");
        require(success, "Failed to buy tokens");

        emit TokenPurchase(msg.sender, amount, _buyPrice);
    }

    function sellTokens(uint256 amount) external payable 
    {
        uint256 totalGain = amount * _sellPrice;
       // require(msg.value == totalGain && amount != 0, "Invalid Amount Sent");

        _burn(msg.sender, amount);

        (bool success, ) = 
        payable(msg.sender).call{value: totalGain}("");
        require(success, "Failed to sell tokens");

        emit TokenSale(msg.sender, amount, _sellPrice);
    }

    function changeBuyPrice(uint256 price) external onlyOwner 
    {
        require(price != 0, "Cannot change to 0 Price");
        require(price > _sellPrice, "Buy price cannot be smaller than Sell price");

        if (_buyPrice == price) {
            return;
        }

        _buyPrice = price;
        emit TokenBuyPriceChanged(msg.sender, price);
    }

    function changeSellPrice(uint256 price) external onlyOwner 
    {
        require(price != 0, "Cannot change to 0 price");
        require(price < _buyPrice, "Sell price cannot be larger than Buy price");

        if (_sellPrice == price) {
            return;
        }

        _sellPrice = price;
        emit TokenSellPriceChanged(msg.sender, price);
    }

    function withdraw(uint256 gweiToWithdraw) payable external onlyOwner 
    {
        uint256 contractBalance = _payout.balance;
        uint256 costOfLeftTokens = _totalSupply * _sellPrice;
        
        require(contractBalance - gweiToWithdraw > costOfLeftTokens, "The amount of ether to withdraw exceeds cost of tokens left");

        (bool success, ) = payable(msg.sender).call{value: gweiToWithdraw}("");   
        require(success, "Failed to withdraw Ether");     

        emit ETHWithdrawn(msg.sender, gweiToWithdraw);
    }

    function prices() public view returns (uint256 buyPrice, uint256 sellPrice)
    {
        return (_buyPrice, _sellPrice);
    }

    receive() external payable {}

}