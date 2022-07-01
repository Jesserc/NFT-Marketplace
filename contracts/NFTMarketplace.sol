//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721URIStorage {
    /**
    @dev these are state variables that we will be using throuh out or NFT Marketplace contract
     */

    address payable owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private itemsSold;
    uint256 listPrice = 0.1 ether;

    // constructor
    constructor() ERC721("NFTMarketplace", "NFTM") {
        owner = payable(msg.sender);
    }

    // This will be the structure of any listed NFT token and will look like this when displayed in our frontend
    struct ListedToken {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }

    // mapping a particular tokenId to one structure
    mapping(uint256 => ListedToken) idToListedToken;

    // custom error for the updateListPrice function below
    error ListPriceError(string message);

    function updateListPrice(uint256 _listPrice) public payable {
        if (owner != msg.sender) {
            revert ListPriceError("Only owner can update the listing price");
        }
        listPrice = _listPrice;
    }

    function getListPrice() public view returns (uint256) {
        return listPrice;
    }

    function getLatestidToListedToken()
        public
        view
        returns (ListedToken memory)
    {
        uint256 currentTokenId = _tokenIds.current();

        return idToListedToken[currentTokenId];
    }

    function getListedTokenForId(uint256 tokenId)
        public
        view
        returns (ListedToken memory)
    {
        return idToListedToken[tokenId];
    }

    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIds.current();
    }
}
