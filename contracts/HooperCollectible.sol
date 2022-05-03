// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract HooperCollectible is Ownable, ERC1155 {
    // Base URI
    string private baseURI;
    string public name;
    uint256 public minted;
    uint private maxSupply = 9999;
    uint256 private price = 90000000000000000; // (in wei) = 0.09 ETH 50000000000000000 
    uint256 private whitelistPrice =  80000000000000000; // (in wei) = 0.08 ETH
    mapping(address => bool) public whitelist; 

    event Log(uint8[2], string); 

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

    function mintBatch(uint256 amount) external payable {
        if (whitelist[msg.sender]) {
            // they're whitelisted, mint for whitelistprice
            require(msg.value >= (whitelistPrice * amount), "You do not have enough Ether to Purchase these items");
        } else {
            require(msg.value >= (price * amount), "You do not have enough Ether to Purchase these items");
        }
        if (keccak256(abi.encodePacked((owner()))) == keccak256(abi.encodePacked(msg.sender))) {
            // owner is minting, they can mint up to 500 extra 
            require((minted + amount) <= (maxSupply + 500), "Maximum supply has been reached"); // owner can mint extra 500 nfts in reserve
            // mint no more than 25 at once to protect from losing gas by trying to batchMint too many at once 
            if (amount <= 25) {
                // calculate ids & amounts, per the number of NFTs specified
                uint256[] memory ids = new uint256[](amount);
                uint256[] memory amounts = new uint256[](amount);
                for (uint256 i=0; i < amount; i++) {
                    ids[i] = minted + i + 1; 
                    amounts[i] = 1;
                }
                minted += amount;
                _mintBatch(msg.sender, ids, amounts, '');
            }
        } else {
            require((minted + amount) <= maxSupply, "Maximum supply has been reached");
            require(amount <= 10, "You cannot mint more than 10 at once");
            // calculate ids & amounts, per the number of NFTs specified
            uint256[] memory ids = new uint256[](amount);
                uint256[] memory amounts = new uint256[](amount);
                for (uint256 i=0; i < amount; i++) {
                    ids[i] = minted + i + 1; 
                    amounts[i] = 1;
                }
                minted += amount;
            _mintBatch(msg.sender, ids, amounts, '');
        }
    }

    // no need for input parameters because we're always minting 1x NFT of ID minted+1
    function mint() external payable {
        if (keccak256(abi.encodePacked((owner()))) == keccak256(abi.encodePacked(msg.sender))) {
            require(minted <= maxSupply + 500, "Maximum supply has been reached"); // owner can mint up to 500 extra reserves
        } else {
            require(minted <= maxSupply, "Maximum supply has been reached"); 
        }
        if (whitelist[msg.sender]) {
            // they're whitelisted, mint for whitelistprice 
            require(msg.value >= (whitelistPrice), "You do not have enough Ether to Purchase these items");
        } else {
            require(msg.value >= (price), "You do not have enough Ether to Purchase these items");
        }
        _mint(msg.sender, (1 + minted), 1, '');
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
