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
}