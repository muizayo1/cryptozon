const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarket", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Market = await ethers.getContractFactory("NFTMarket");
    const market = await Market.deploy("Hello, world!");
    await market.deployed(); // deploy the NftMarket contract
    const marketAddress = market.address;

    const NFT = await ethers.getContractFactory("NFTMarket");
    const nft = await NFT.deploy("Hello, world!");
    await nft.deployed(); // deploy the Nft contract
    const nftContractAddress = nft.address;
     
    // get the liting price
    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString();
    
    // set an auction price
    const auctionPrice = ethers.utils.parseUnits("100","ether");
      
    // create 2 test tokens
    await nft.createToken("");
    await nft.createToken("");

    //create sample nfts

    await market.createMarketItem(nftContractAddress, 1, auctionPrice, {value: listingPrice});
    await market.createMarketItem(nftContractAddress, 1, auctionPrice, {value: listingPrice});


    const [_, buyerAddress] = await ethers.getSigner();

    await market.connect(buyerAddress).createMarketSale(nftContractAddress, 1, {value: auctionPrice});

    //fetch market items
    const items = await market.fetchMarketItems();

    console.log("items:", items);

    
  });
});
