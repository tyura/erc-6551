// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./PackSet100.sol";
import "./PackSetTBA.sol";

contract PackSet600 is ERC721 {
    PackSet100 private packSet100;
    mapping(uint256 => address) public tokenIdTBAMap;

    constructor(address _packSet100) {
        packSet100 = PackSet100(_packSet100);
    }

    function recursiveUnpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        address tbaAddress600 = tokenIdTBAMap[tokenId];
        uint256[] tokenIds100 = packSet100.getTokenIdsByOwner(tbaAddress);
        uint256[] memory tbaAddresses100 = new uint256[](tokenIds100);
        PackSetTBA packSetTBA = PackSetTBA();
        for (uint256 i; i < tokenIds100.length; i++) {
            // tbaからユーザにtransfer
            packSetTBA.transferNFT(userWalletAddres, tokenIds100[i]);
        }
        // burn
        burn(tokenId);

        // 100パックセットまでの開封でよければ終了
        if (unpackIndicator == address(packSet100)) {
            return;
        }

        // 100パックセット以降も開封
        for (uint256 i; i < tokenIds100.length; i++) {
            tbaAddresses100[i] = packSet100.recursiveUnpack(
                userWalletAddres,
                tokenIds100[i],
                unpackIndicator
            );
        }
    }
}
