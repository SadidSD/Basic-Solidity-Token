// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTMarketplace {
    mapping(address => string[]) private nfts; // NFTs owned by each address
    mapping(string => uint) private prices;    // NFT prices in wei
    mapping(string => address) private owners; // NFT owners

    // Events
    event Mint(address indexed owner, string uri, uint price);
    event Purchase(address indexed buyer, address indexed seller, string uri, uint price);

    receive() external payable {}

    // Mint a new NFT with price in wei
    function mint(string memory uri, uint priceInWei) public {
        require(owners[uri] == address(0), "NFT already exists");

        nfts[msg.sender].push(uri);
        prices[uri] = priceInWei;
        owners[uri] = msg.sender;

        emit Mint(msg.sender, uri, priceInWei);
    }

    // Show NFTs owned by an address
    function showNFTs(address _address) public view returns (string[] memory) {
        return nfts[_address];
    }

    // Show price of an NFT (in wei)
    function showPrice(string memory uri) public view returns (uint) {
        require(owners[uri] != address(0), "NFT does not exist");
        return prices[uri];
    }

    // Internal function to remove NFT from an owner's array
    function _removeNFT(address owner, string memory NFT) internal {
        string[] storage userNFTs = nfts[owner];
        for (uint i = 0; i < userNFTs.length; i++) {
            if (keccak256(bytes(userNFTs[i])) == keccak256(bytes(NFT))) {
                userNFTs[i] = userNFTs[userNFTs.length - 1]; // swap with last
                userNFTs.pop(); // remove last
                return;
            }
        }
    }

    // Purchase an NFT
    function purchaseNFT(string memory NFT) public payable {
        address previousOwner = owners[NFT];
        require(previousOwner != address(0), "NFT does not exist");
        require(previousOwner != msg.sender, "You already own this NFT");

        uint price = prices[NFT]; // already in wei

        // Remove NFT from previous owner
        _removeNFT(previousOwner, NFT);

        // Update ownership
        owners[NFT] = msg.sender;
        nfts[msg.sender].push(NFT);

        // Transfer payment
        payable(previousOwner).transfer(price*1000000000000000000);

        emit Purchase(msg.sender, previousOwner, NFT, price);
    }
}
