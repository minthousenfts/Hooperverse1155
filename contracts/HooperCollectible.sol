// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract ArtCollectible is Ownable, ERC1155 {
    // Base URI
    string private baseURI;
    string public name;
    uint256 private minted = 0;
    uint private maxSupply = 10000;
    uint256 private price = 50000000000000000; // (in wei) = 0.05 ETH 
    uint256 private whitelistPrice =  20000000000000000; // (in wei) = 0.02 ETH
    mapping(address => bool) public whitelist; 

    constructor()
        ERC1155(
            'ipfs://QmfH4te5jjEn87rpS3KiM3D8qciXWXxVZP23gfrbSraBVE/{id}.json' // REPLACE THIS WITH ACTUAL IPFS FROM PINATA ONCE UPLOADS ARE DONE
        )
    {
        setName('Hooperverse NFT Collection');
    }

    function setURI(string memory _newuri) public onlyOwner {
        _setURI(_newuri);
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    function setWhitelistPrice(uint256 _newPrice) public onlyOwner {
        whitelistPrice = _newPrice;
    }

    function setName(string memory _name) public onlyOwner {
        name = _name;
    }

    function updateWhitelist(address user, bool isWhitelisted) public onlyOwner {
        whitelist[user] = isWhitelisted;
    } // require(whitelist[msg.sender], "You're not whitelisted."); 

    function adjustIds(uint256[] memory ids) private returns(uint256[] memory) {
        // add `minted` to every id 
        // (i.e. when minted=50: [1,2,3,4,5] => [51,52,53,54,55]
        for (uint i=0; i < ids.length; i++) {
            ids[i] = minted + i + 1;
        }
        minted += ids.length;
        return ids;
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts) payable public {
        if (whitelist[msg.sender]) {
            // they're whitelisted, mint for whitelistprice 
            require(msg.value >= (whitelistPrice * ids.length), "You do not have enough Ether to Purchase these items");
        } else {
            require(msg.value >= (price * ids.length), "You do not have enough Ether to Purchase these items");
        }
        if (keccak256(abi.encodePacked((owner()))) == keccak256(abi.encodePacked((msg.sender))) {
            // owner is minting 
            require((minted + ids.length) <= (maxSupply + 500), "Maximum supply has been reached"); // owner can mint extra 500 nfts in reserve
            // mint no more than 25 at once to protect from losing gas by trying to batchMint too many at once 
            if (ids.length <= 25) {
                _mintBatch(msg.sender, adjustIds(ids), amounts, '');
            }
        } else {
            require((minted + ids.length) <= maxSupply, "Maximum supply has been reached");
            require(ids.length >= 5, "You cannot mint more than 5 at once");
            _mintBatch(msg.sender, adjustIds(ids), amounts, '');
        }
    }

    function mint(uint256 id, uint256 amount) public payable {
        if (keccak256(abi.encodePacked((owner()))) == keccak256(abi.encodePacked((msg.sender))) {
            require(minted <= maxSupply + 500, "Maximum supply has been reached"); // owner can mint up to 500 extra reserves
        } else {
            require(minted <= maxSupply, "Maximum supply has been reached"); 
        }
        if (whitelist[msg.sender]) {
            // they're whitelisted, mint for whitelistprice 
            require(msg.value >= (whitelistPrice * ids.length), "You do not have enough Ether to Purchase these items");
        } else {
            require(msg.value >= (price * ids.length), "You do not have enough Ether to Purchase these items");
        }
        _mint(msg.sender, (id + minted), amount, '');
        minted++;
    }

    // handling payments & withdrawals 

    receive () external payable {}

    function withdrawFromWalletBalance(address payable addr, uint amount) public onlyOwner {
        require(address(this).balance >= amount, "Wallet balance too low to fund withdraw");
        addr.transfer(amount);
    }

    function withdrawAllFromWalletBalance(address payable addr) public onlyOwner {
        withdrawFromWalletBalance(addr, address(this).balance);
    }
}
