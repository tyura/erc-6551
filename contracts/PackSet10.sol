// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Pack.sol";
import "./PackSetTBA.sol";

contract PackSet10 is ERC721Enumerable {
    Pack private pack;
    mapping(uint256 => address) public tokenIdTBAMap;

    constructor(address _pack) ERC721("PackSet10", "PS10") {
        pack = Pack(_pack);
    }

    function recursiveUnpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        address packTbaAddress = tokenIdTBAMap[tokenId];
        uint256[] memory packTokenIds = pack.getTokenIdsByOwner(packTbaAddress);
        for (uint256 i; i < packTokenIds.length; i++) {
            address tbaAddress = pack.getTbaAddress(packTokenIds[i]);
            // tbaからユーザにtransfer
            PackSetTBA(payable(tbaAddress)).transferNFT(
                userWalletAddres,
                packTokenIds[i]
            );
        }
        _burn(tokenId);

        // パックまでの開封でよければ終了
        if (unpackIndicator == address(pack)) {
            return;
        }

        // パックも開封
        for (uint256 i; i < packTokenIds.length; i++) {
            pack.unpack(userWalletAddres, packTokenIds[i], unpackIndicator);
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
