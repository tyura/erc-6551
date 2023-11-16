// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Pack is ERC721 {
    mapping(uint256 => address) private tokenIdTBAMap;

    function unpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        // unpackIndicatorがPackと一致しなければ終了
        if (unpackIndicator != address(this)) {
            return;
        }
        // burn
        burn(tokenId);

        // Openイベントをemit
        // イベント検知時に交換前NFTのburnと交換後NFTのmintを実行
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
