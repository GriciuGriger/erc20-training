pragma solidity ^0.8.0;

import "./IERC20Mintable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Market is Ownable {

    event TokenPurchase(address purchaser, uint256 amount, uint256 price);
    event TokenSale(address seller, uint256 amount, uint256 price);

    event TokenBuyPriceChanged(address by, uint256 price);
    event TokenSellPriceChanged(address by, uint256 price);

    event ETHWithdrawn(address by, uint256 amountWithdrawn);

    uint256 internal _buyPrice;
    uint256 internal _sellPrice;

    address public token;

    function buyTokens() external payable 
    {
        _buyTokens();
    }

    function _buyTokens() internal 
    {
        uint256 amount = msg.value / _buyPrice;

        IERC20Mintable(token).mint(msg.sender, amount);

        emit TokenPurchase(msg.sender, amount, _buyPrice);
    }

    function sellTokens(uint256 amount) external
    {
        _sellTokens(amount);
    }

    function _sellTokens(uint256 amount) internal 
    {
        uint256 totalGain = amount * _sellPrice;
        require(address(this).balance >= totalGain, "Cannot sell tokens because of too little ether left in the contract");

        IERC20Mintable(token).burn(msg.sender, amount);

        (bool success, ) = 
        payable(msg.sender).call{value: totalGain}("");
        require(success, "Failed to sell tokens");

        emit TokenSale(msg.sender, amount, _sellPrice);
    }

    function changeBuyPrice(uint256 price) external virtual onlyOwner 
    {
        _changeBuyPrice(price);
    }

    function _changeBuyPrice(uint256 price) internal
    {
        require(price != 0, "Cannot change to 0 Price");
        require(price > _sellPrice, "Buy price cannot be smaller than Sell price");

        _buyPrice = price;
        emit TokenBuyPriceChanged(msg.sender, price);
    }

    function changeSellPrice(uint256 price) external virtual onlyOwner 
    {
        _changeSellPrice(price);
    }

    function _changeSellPrice(uint256 price) internal 
    {
        require(price != 0, "Cannot change to 0 price");
        require(price < _buyPrice, "Sell price cannot be larger than Buy price");

        _sellPrice = price;
        emit TokenSellPriceChanged(msg.sender, price);
    }

    function prices() public view returns (uint256 buyPrice, uint256 sellPrice)
    {
        return (_buyPrice, _sellPrice);
    }

    function withdraw(uint256 gweiToWithdraw) external virtual payable onlyOwner 
    {
        _withdraw(gweiToWithdraw);
    }

    function _withdraw(uint256 gweiToWithdraw) internal  
    {
        uint256 contractBalance = address(this).balance;
        uint256 costOfLeftTokens = IERC20Mintable(token).totalSupply() * _sellPrice;
        
        require(contractBalance - gweiToWithdraw >= costOfLeftTokens, "The amount of ether to withdraw exceeds cost of tokens left");
 
        (bool success, ) = payable(msg.sender).call{value: gweiToWithdraw}("");   
        require(success, "Failed to withdraw Ether");     

        emit ETHWithdrawn(msg.sender, gweiToWithdraw);
    }

    receive() external payable 
    {
        uint256 amount = msg.value / _buyPrice;

        IERC20Mintable(token).mint(msg.sender, amount);

        emit TokenPurchase(msg.sender, amount, _buyPrice);
    }

}
