// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Exchange.sol";
import "../src/Token.sol";

contract ExchangeTest is Test {
    Exchange public exchange;
    Token public token;

    function setUp() public {
        token = new Token("Token", "TKN", 1000000 * 10**18); 
        exchange = new Exchange(address(token));
    }

    function testAddLiquidity() public {
        token.approve(address(exchange), 200 * 10**18);
        exchange.addLiquidity{value: 100 * 10**18}(200 * 10**18);

        assertEq(address(exchange).balance, 100 * 10**18);
        assertEq(exchange.getReserve(), 200 * 10**18);
    }

    function testGetTknAmount() public {
        token.approve(address(exchange), 2000 * 10**18);
        exchange.addLiquidity{value: 1000 * 10**18}(2000 * 10**18);

        uint256 tokensOut = exchange.getTknAmount(1 * 10**18);
        assertEq(tokensOut, 1998001998001998001);

        tokensOut = exchange.getTknAmount(100 * 10**18);
        assertEq(tokensOut, 181818181818181818181);

        tokensOut = exchange.getTknAmount(1000 * 10**18);
        assertEq(tokensOut, 1000 * 10**18);
    }
}