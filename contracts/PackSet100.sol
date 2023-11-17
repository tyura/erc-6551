// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./PackSet10.sol";
import "./PackSetTBA.sol";

contract PackSet100 is ERC721Enumerable {
    PackSet10 private packSet10;
    mapping(uint256 => address) public tokenIdTBAMap;

    constructor(address _packSet10) ERC721("PackSet100", "PS100") {
        packSet10 = PackSet10(_packSet10);
    }

    function recursiveUnpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        address ps100TbaAddress = tokenIdTBAMap[tokenId];
        uint256[] memory ps10TokenIds = packSet10.getTokenIdsByOwner(
            ps100TbaAddress
        );
        for (uint256 i; i < ps10TokenIds.length; i++) {
            address tbaAddress = packSet10.getTbaAddress(ps10TokenIds[i]);
            // tbaからユーザにtransfer
            PackSetTBA(payable(tbaAddress)).transferNFT(
                userWalletAddres,
                ps10TokenIds[i]
            );
        }
        _burn(tokenId);

        // 10パックセットまでの開封でよければ終了
        if (unpackIndicator == address(packSet10)) {
            return;
        }

        // 10パックセット以降も開封
        for (uint256 i; i < ps10TokenIds.length; i++) {
            packSet10.recursiveUnpack(
                userWalletAddres,
                ps10TokenIds[i],
                unpackIndicator
            );
        }
    }

    function getTokenIdsByOwner(
        address owner
    ) public returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](tokenCount);

        for (uint256 i; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }
    }

    function getTbaAddress(uint256 tokenId) public returns (address) {
        return tokenIdTBAMap[tokenId];
    }
}
