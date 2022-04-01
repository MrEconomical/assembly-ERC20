// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

/*
 * Standard test OpenZeppelin ERC20 implementation
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20("Standard Token", "TOKEN") {

    constructor() {
        _mint(msg.sender, 10 ** 6 * 1e18);
    }

}