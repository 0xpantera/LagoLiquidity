// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

import "openzeppelin/token/ERC20/IERC20.sol";

contract Exchange {
    address public tokenAddress;

    constructor(address _token) {
        require(_token != address(0), "invalid token address");

        tokenAddress = _token;
    }

    function addLiquidity(uint256 _tokenAmount) public payable {
        IERC20 token = IERC20(tokenAddress);
        token.transferFrom(msg.sender, address(this), _tokenAmount);
    }

    function getReserve() public view returns(uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function getAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) private pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserves");

        return (inputAmount * outputReserve) / (inputReserve + inputAmount);
    }

    function getTknAmount(uint256 _ethSold) public view returns(uint256) {
        require(_ethSold > 0, "ethSold is too small");

        uint256 tokenReserve = getReserve();

        return getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    function getEthAmount(uint256 _tknSold) public view returns(uint256) {
        require(_tknSold > 0, "tknSold is too small");

        uint256 tokenReserve = getReserve();

        return getAmount(_tknSold, tokenReserve, address(this).balance);
    }

    function ethToTknSwap(uint256 _minTokens) public payable {
        uint256 tknReserve = getReserve();
        uint256 tknsBought = getAmount(
            msg.value,
            address(this).balance - msg.value,
            tknReserve
        );

        require(tknsBought >= _minTokens, "insufficient output amount");

        IERC20(tokenAddress).transfer(msg.sender, tknsBought);
    }

    function TknToEthSwap(uint256 _minEth, uint256 _tknSold) public {
        uint256 tknReserve = getReserve();
        uint256 ethBought = getAmount(
            _tknSold,
            tknReserve,
            address(this).balance
        );

        require(ethBought >= _minEth, "insufficient output amount");

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _tknSold);
        payable(msg.sender).transfer(ethBought);
    }

}