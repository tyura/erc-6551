// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

interface IPlaceholder {
    function mint(address to, uint256 tokenId) external;

    function burn(uint256 tokenId) external;

    function getTokenIdsOfOwner(
        address owner
    ) external view returns (uint256[] memory);
}
