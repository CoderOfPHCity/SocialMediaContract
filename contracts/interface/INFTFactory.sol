// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

interface NftFactoryInterface {
    function createNFT(address to, uint256 tokenId) external;
}
