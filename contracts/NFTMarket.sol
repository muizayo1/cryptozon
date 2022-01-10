//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utilis/Counters.sol";
// prevents re-entrancy attacks
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold; // total number of items sold

    address payable owner; // owner of the smart countract
    // people have to pay to put their NFT on this marketplace
    uint256 listingPrice = 0.025 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint256 itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    // a way to access the values of MarketItem by mapping, setting the uint as a key
    mapping(uint256 => MarketItem) private idMarketItem;

    // log mesage when item is sold
    event MarketItemCreated(
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

   /// @notice function to create market item
    function createMarketItem(
        address nftContract,
        uint256 tokenId
        uint256 price) public payable nonReentrant {
            require (price > 0, "price cannot be zero");
            require(msg.value == listingPrice, "Price must be equal to listing price");

            _itemsIds.increment();
            uint256 itemId = _itemIds.current();

            idMarketItem[itemId] = MarketItem(
                itemId,
                nftContract,
                tokenId,
                payable(msg.sender), //address of the seller putting the nft for sale 
                payable(address(0)), // no owner yet(set owner to empty address)
                price,
                false
            );

            // transfer ownership of the nft to the contract itself
            IERC721(nftContract).transferFrom(msg.sender,address(this), tokenId);
            // log this transaction
            emit MarketItemCreated(itemId, nftContract, tokenId, msg.sender, address(0), price, false);

            /// @notice function to create a sale 
            function createMarketSale (
                address nftContract,
                uint256 itemId) public payable nonReentrant {
                    uint price = idMarketItem[itemId].price;
                    uint tokenId = idMarketItem[itemId].tokenId;

                    require(msg.value == price,"please pay the asking price in order for a successful transasction");
                     // pay the seller the amount
                     idMarketItem[itemId].seller.transfer(msg.value);

                     //transfer ownership of the nft from the contract itself to the buyer
                       IERC721(nftContract).transferFrom(address(this), msg.sender,tokenId);

                      idMarketItem[itemId].owner = payable(msg.sender); // mark buyer as new owner
                      idMarketItem[itemId].sold = true; // mark that it has been sold
                      _itemSold.increment(); // increment the total number of items sold by 1
                      payable(owner).transfer(listingPrice); // pay owner of the contract the listing price    
                }
                /// @notice total number of items unsold on our platform
                function fetchMarketItems() public view returns(MarketItem[] memory) {
                    uint itemCount = _itemIds.current(); // total items ever created
                    // total number of items that are unsold = total items created - total items
                    uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
                    uint currentIndex = 0;

                    MarketItem[] memory items = new MarketItem[](unsoldItemCount);

                    //loop through all items ever created

                    for (uint i = 0; i< itemCount; i++) {
                        //check if the item has not been sold
                        // by checking if the owner field is empty
                        if (idMarketItem[i+1].owner == address(0)) {
                            //yes this item has never been sold
                            uint currentId  = idMarketItem[i + 1].itemId;
                            MarketItem storage currentItem = idMarketItem[currentId];
                            items[currentIndex] = currentItem;
                            currentIndex += 1;
                        }
                    }
                    return items; // return array of all unsold items
                }
                

                /// @notice fetch list of NFTs owned by this user
                function fetchMyNFTS() public view returns(MarketItem() memory) {
                    //get total number of items ever created 
                    uint totalItemCount = _itemIds.current();
                    
                    uint itemCount = 0;
                    uint currentIndex = 0;
                    

                    for (uint i = 0; i < totalItemCount; i++) {
                        //get only the items that this user has bought/ owned
                        if(idMarketItem[i+1].owner == msg.sender){
                            itemCount += 1;
                        }
                    }

                    MarketItem[] memory items = new MarketItems[] (itemsCount);
                    for (uint i = 0; i < totalItemCount; i++) {
                        if (idMarketItem[i+1].owner == msg.sender) {
                            uint currentId = idMarketItem[i+1].itemId;
                            MarketItem storage currentItem = idMarketItem[currentId];
                            items[currentIndex] = currentItem;
                            currentIndex += 1;
                        }
                    }
                    return items;
                }
                 function fetchItemsCreated() public view returns(MarketItem() memory) {
                    //get total number of items ever created 
                    uint totalItemCount = _itemIds.current();
                    
                    uint itemCount = 0;
                    uint currentIndex = 0;
                    

                    for (uint i = 0; i < totalItemCount; i++) {
                        //get only the items that this user has bought/ owned
                        if(idMarketItem[i+1].seller == msg.sender){
                            itemCount += 1;
                        }
                    }

                    MarketItem[] memory items = new MarketItems[] (itemsCount);
                    for (uint i = 0; i < totalItemCount; i++) {
                        if (idMarketItem[i+1].seller == msg.sender) {
                            uint currentId = idMarketItem[i+1].itemId;
                            MarketItem storage currentItem = idMarketItem[currentId];
                            items[currentIndex] = currentItem;
                            currentIndex += 1;
                        }
                    }
                    return items;
                }
            )
        }
}
