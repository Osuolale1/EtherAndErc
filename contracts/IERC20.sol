
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Fem is ERC20 {
    constructor() ERC20("fem", "FM") {
        _mint(msg.sender, 1000000000000000000000); // Mint 1000 tokens with 18 decimal places
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}
