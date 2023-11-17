// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./PackSet100.sol";
import "./PackSetTBA.sol";

contract PackSet600 is ERC721 {
    PackSet100 private packSet100;
    mapping(uint256 => address) public tokenIdTBAMap;

    constructor(address _packSet100) ERC721("PackSet600", "PS600") {
        packSet100 = PackSet100(_packSet100);
    }

    function recursiveUnpack(
        address userWalletAddres,
        uint256 tokenId,
        address unpackIndicator
    ) public {
        address ps600TbaAddress = tokenIdTBAMap[tokenId];
        uint256[] memory ps100TokenIds = packSet100.getTokenIdsByOwner(
            ps600TbaAddress
        );
        for (uint256 i; i < ps100TokenIds.length; i++) {
            address tbaAddress = packSet100.getTbaAddress(ps100TokenIds[i]);
            // tbaからユーザにtransfer
            PackSetTBA(payable(tbaAddress)).transferNFT(
                userWalletAddres,
                ps100TokenIds[i]
            );
        }
        _burn(tokenId);

        // 100パックセットまでの開封でよければ終了
        if (unpackIndicator == address(packSet100)) {
            return;
        }

        // 100パックセット以降も開封
        for (uint256 i; i < ps100TokenIds.length; i++) {
            packSet100.recursiveUnpack(
                userWalletAddres,
                ps100TokenIds[i],
                unpackIndicator
            );
        }
    }
}
