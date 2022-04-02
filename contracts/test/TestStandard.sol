// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestStandard is ERC20("Standard Token", "TOKEN") {

    constructor() {
        _mint(msg.sender, 10 ** 6 * 1e18);
    }

}