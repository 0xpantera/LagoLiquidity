// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

import "openzeppelin/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 initialSupply
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, initialSupply);
    }
}