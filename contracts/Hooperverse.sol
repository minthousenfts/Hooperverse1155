// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Hooperverse is ERC1155, Ownable {
    address[] private whitelisted;
    uint256 public mintRate;
    uint256 public minted;
    uint256 public supply;

    constructor() ERC1155("https://ipfs.io/ipfs/bafybeiap7zul4x6tkslkfbxkchdjn4wofzzqzwtm6iwulcoibavmci42nm/{id}.json") {
        mintRate = 0.05 ether;
        minted = 0;
        supply = 10000;
    }
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
    function uri(uint tokenId) override public view returns (string memory) {
        return(
            string(abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeiap7zul4x6tkslkfbxkchdjn4wofzzqzwtm6iwulcoibavmci42nm/",
                Strings.toString(tokenId),
                "-",
                Strings.toString(minted),
                ".json"
            ))
        );
    } //function to return URI link (IPFS link to json metadata) for a specific tokenID
    function mint(bytes memory data) payable public {
        require(minted + 1 <= supply, "No more tokens to mint");
        require(msg.value < mintRate, "Not enough ether sent");
        _mint(msg.sender, 1, 1, data);
        minted++;
    }
}
