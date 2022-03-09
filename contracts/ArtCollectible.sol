// SPDX-License-Identifier: MIT
// pragma solidity >=0.4.22 <0.9.0;

pragma solidity ^0.8.1;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract ArtCollectible is Ownable, ERC1155 {
    // Base URI
    string private baseURI;
    string public name;
    event nftMinted(address addressCalled, uint256 tokenId);
    event nftBatchMinted(address addressCalled, uint256[] tokenIds);

    constructor()
        ERC1155(
            'ipfs://QmfH4te5jjEn87rpS3KiM3D8qciXWXxVZP23gfrbSraBVE/{id}.json'
        )
    {
        setName('Hooperverse NFT Collection');
    }

    function setURI(string memory _newuri) public onlyOwner {
        _setURI(_newuri);
    }

    function setName(string memory _name) public onlyOwner {
        name = _name;
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        public
    {
        _mintBatch(msg.sender, ids, amounts, '');
        emit nftBatchMinted(msg.sender, ids);
    }

    function mint(uint256 id, uint256 amount) public onlyOwner {
        _mint(msg.sender, id, amount, '');
        emit nftMinted(msg.sender, id);
    }
}
