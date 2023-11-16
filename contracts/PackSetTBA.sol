// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./PackSet100.sol";

contract PackSetTBA is ERC6551Adccount {
    function executeCall(address to, uint256 value, bytes memory data) public {
        (bool success, ) = to.call{value: value}(data);
        require(success, "Call execution failed.");
    }

    function transferNFT(address to, uint256 tokenId) public {
        bytes memory data = abi.encodeWithSignature(
            "transferFrom(address,address,uint256)",
            address(this),
            to,
            tokenId
        );

        (
            uint256 chainId,
            address tokenContractAddress,
            uint256 tokenId
        ) = token();
        executeCall(address(tokenContractAddress), 0, data);
    }
}
