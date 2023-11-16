// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Pack.sol";
import "./PackSetTBA.sol";

contract PackSet10 is ERC721 {
    Pack private pack;
    mapping(uint256 => address) public tokenIdTBAMap;

    constructor(address _pack) {
        pack = Pack(_pack);
    }

    function recursiveUnpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        address tbaAddress100 = tokenIdTBAMap[tokenId];
        uint256[] packTokenIds = packSet10.getTokenIdsByOwner(tbaAddress);
        uint256[] memory tbaAddresses10 = new uint256[](packTokenIds);
        PackSetTBA packSetTBA = PackSetTBA();
        for (uint256 i; i < packTokenIds.length; i++) {
            // tbaからユーザにtransfer
            packSetTBA.transferNFT(userWalletAddres, packTokenIds[i]);
        }
        // burn
        burn(tokenId);

        // パックまでの開封でよければ終了
        if (unpackIndicator == address(packSet10)) {
            return;
        }

        // パックも開封
        for (uint256 i; i < packSet10.length; i++) {
            tbaAddresses10[i] = packSet100.recursiveUnpack(
                userWalletAddres,
                packSet10[i],
                unpackIndicator
            );
        }
    }

    function getTokenIdsByOwner(address owner) public {
        uint256 tokenCount = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](tokenCount);
        for (uint256 i; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }
    }

    function getTBAAddress(uint256 tokenId) public {
        return tokenIdTBAMap[tokenId];
    }
}
