// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./PackSet100.sol";
import "./PackSetTBA.sol";

contract PackSet100 is ERC721 {
    PackSet10 private packSet10;
    mapping(uint256 => address) public tokenIdTBAMap;

    constructor(address _packSet100) {
        packSet10 = PackSet10(_packSet10);
    }

    function recursiveUnpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        address tbaAddress100 = tokenIdTBAMap[tokenId];
        uint256[] tokenIds10 = packSet10.getTokenIdsByOwner(tbaAddress);
        uint256[] memory tbaAddresses10 = new uint256[](tokenIds10);
        PackSetTBA packSetTBA = PackSetTBA();
        for (uint256 i; i < tokenIds10.length; i++) {
            // tbaからユーザにtransfer
            packSetTBA.transferNFT(userWalletAddres, tokenIds10[i]);
        }
        // burn
        burn(tokenId);

        // 10パックセットまでの開封でよければ終了
        if (unpackIndicator == address(packSet10)) {
            return;
        }

        // 10パックセット以降も開封
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
