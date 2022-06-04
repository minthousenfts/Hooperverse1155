import '@openzeppelin/contracts/access/Ownable.sol';

contract HooperCollectible is Ownable, ERC1155 {
    // Base URI
    string private baseURI;
    string public name;
    uint256 public minted;
    uint private maxPublicSupply = 9749; // 9999 - 250 (reserve for owners)
    uint256 private price = 90000000000000000; // (in wei) = 0.09 ETH 50000000000000000 
    uint256 private whitelistPrice =  80000000000000000; // (in wei) = 0.08 ETH
    mapping(address => uint256) public whitelistAllowance; // how much each address is allowed to mint

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

    function updateTier(address user, uint256 tier) public onlyOwner {
        // bear in mind: 
        // tier 1 => mint 1 
        // tier 2 => mint 2 
        // tier 3 => mint 3 
        // tier 4 => mint 5 
        require(block.timestamp <= 	1656572400, "Too late");
        require(tier >= 1 && tier <= 4, "Tier must be between 1 and 4");

        // tiers should only be assigned before mint date. After mint date they should not be change. 
        if (tier >= 1 && tier <= 3) {
            whitelistAllowance[user] = tier; // tier is 1, 2, or 3, so allowance will be the same as the tier 
        } else {
            whitelistAllowance[user] = tier + 1; // tier must be 4, so allowance should be 5 
        }
    }

    function getMintAllowance(address user) public {

        require(whitelistAllowance[user] != 0, "You are not whitelisted.");

        // return whitelistAllowance[user];
    }


    function mintBatch(uint256 amount) external payable {

        require(amount != 1, "Unable to batch mint this amount. Use regular mint.");
        require(block.timestamp >= 	1656572400, "Too early");

        // CHECK IF OWNER 
        if (keccak256(abi.encodePacked((owner()))) == keccak256(abi.encodePacked(msg.sender))) {
            // owner is minting, they can mint up to 500 extra 
            require((minted + amount) <= (maxPublicSupply + 250), "Maximum supply has been reached"); // owner can mint extra 500 nfts in reserve
            // mint no more than 75 at once to protect from losing gas by trying to batchMint too many at once 
            require(amount <= 75, "Mint 75 or less NFTs at a time.");
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
        // CHECK IF WHITELISTED 
        else {
            require(whitelistAllowance[msg.sender] > 0, "You're not whitelisted, so you can't mint more than 1.");

            require(msg.value >= (whitelistPrice * amount), "You do not have enough Ether to Purchase these items.");

            // they must mint less than or equal to their allowance
            require(whitelistAllowance[msg.sender] >= amount, "You cannot mint that many items.");

            require((minted + amount) <= maxPublicSupply, "Maximum supply has been reached");
            // require(amount <= 10, "You cannot mint more than 10 at once");
            // calculate ids & amounts, per the number of NFTs specified
            uint256[] memory ids = new uint256[](amount);
            uint256[] memory amounts = new uint256[](amount);
            for (uint256 i=0; i < amount; i++) {
                ids[i] = minted + i + 1; 
                amounts[i] = 1;
            }
            minted += amount;
            whitelistAllowance[msg.sender] -= amount;
            _mintBatch(msg.sender, ids, amounts, '');
        }
        // USER ISN'T WHITELISTED. 

        // ------------------------------------------------------------------------------------------------------
        // THIS COMMENTED CODE IS KEPT HERE IN CASE NON-WHITELISTED USERS CAN MINT MORE THAN 1. DEPENDS ON CLIENT. 
        // DELETE / UN-COMMENT AFTER CONFIRMATION. 
        // ------------------------------------------------------------------------------------------------------

        // else {
        //     require((minted + amount) <= maxPublicSupply, "Maximum supply has been reached");
        //     // calculate ids & amounts, per the number of NFTs specified
        //     uint256[] memory ids = new uint256[](amount);
        //         uint256[] memory amounts = new uint256[](amount);
        //         for (uint256 i=0; i < amount; i++) {
        //             ids[i] = minted + i + 1; 
        //             amounts[i] = 1;
        //         }
        //         minted += amount;
        //     _mintBatch(msg.sender, ids, amounts, '');
        // }


        // if (whitelist[msg.sender]) {
        //     // they're whitelisted, mint for whitelistprice

        //     // make sure their tier allows them to mint as many hoopers as they're asking for
        //     require(whitelistAllowance[msg.sender] >= amount, "You cannot mint that many Hoopers");
        //     require(msg.value >= (whitelistPrice * amount), "You do not have enough Ether to Purchase these items");
        // } else {
        //     // they aren't whitelisted, mint for regular price

        //     require(whitelistAllowance[msg.sender] >= amount, "You cannot mint that many Hoopers");
        //     require(msg.value >= (price * amount), "You do not have enough Ether to Purchase these items");
        // }

        
        // } else {
        //     require((minted + amount) <= maxPublicSupply, "Maximum supply has been reached");
        //     // require(amount <= 10, "You cannot mint more than 10 at once");
        //     // calculate ids & amounts, per the number of NFTs specified
        //     uint256[] memory ids = new uint256[](amount);
        //         uint256[] memory amounts = new uint256[](amount);
        //         for (uint256 i=0; i < amount; i++) {
        //             ids[i] = minted + i + 1; 
        //             amounts[i] = 1;
        //         }
        //         minted += amount;
        //     _mintBatch(msg.sender, ids, amounts, '');
        // }
    }

    // no need for input parameters because we're always minting 1x NFT of ID minted+1
    function mint() external payable {

        require(block.timestamp >= 1656572400, "Too early");

        if (keccak256(abi.encodePacked((owner()))) == keccak256(abi.encodePacked(msg.sender))) {
            require(minted <= maxPublicSupply + 250, "Maximum supply has been reached"); // owner can mint up to 500 extra reserves
        } else {
            require(minted <= maxPublicSupply, "Maximum supply has been reached"); 
        }
        if (whitelistAllowance[msg.sender] != 0) { // made change here because got TypeError (was originally just whitelistAllowance[msg.sender]) 
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
