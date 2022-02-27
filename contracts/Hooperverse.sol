//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// use ERC1155 contract for the token 
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Hooperverse is ERC1155 {

    // need to fix up the dummy URL 
    constructor() public ERC1155("https://some.url/api/item.json") {
        console.log("Welcome to the hooperverse!");
    }
}
