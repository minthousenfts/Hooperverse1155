//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// use ERC1155 contract for the token 
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Hooperverse is ERC1155 {

    mapping (uint256 => string) private _uris;

    // need to fix up the dummy URL 
    constructor() ERC1155("https://some.url/api/item.json") {
        console.log("Welcome to the hooperverse!");
    }

    function uri(uint tokenId) override public view returns (string memory) {
        
        return (_uris[tokenId]);
        
        return(
            string(abi.encodePacked(
                "IPFSURL", 
                Strings.toString(tokenId),
                ".json"
            ))
        );
    } //function to return URI link (IPFS link to json metadata) for a specific tokenID

}
