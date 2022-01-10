//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utilis/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address contractAddress;

    constructor(address marketplaceAddress)
        ERC721("Partnerverse Tokens", "PNVT")
    {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns (uint256) {
        // set a new token id for the token to be minted
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId); // mint the token
        _setTokenURI(newItemId, tokenURI); // generate the URI
        setApprovalForAll(contractAddress, true); // grant transactions permisson

        // return token ID
        return newItemId;
    }
}