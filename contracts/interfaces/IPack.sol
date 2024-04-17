// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./ICard.sol";

interface IPack {
    function open(
        address to,
        uint256 packTokenId,
        ICard.IdWithMetadata[] calldata idWithMetadatas
    ) external;

    function mint(address to, uint256 tokenId) external;

    function burn(uint256 tokenId) external;

    function getTBA(uint256 packTokenId) external view returns (address);

    function setTBA(uint256 packTokenId, address tba) external;
}
