// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import "./SocialNft.sol";

contract NftFactory  {
    SocialNft public nftContract;
    
    constructor(SocialNft _nftContract) {
        nftContract = _nftContract;
    }
    
    function createNFT(address to, uint256 tokenId) public  {
        nftContract.safeMint(to, tokenId);
    }
}







  