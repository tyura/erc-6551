// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

interface ICard {
    event CardMetadataUpdate(
        string indexed _requestId,
        uint256 indexed _cardTokenId,
        Metadata indexed _metadata
    );

    struct Attributes {
        string lines;
        string illustrator;
        string cv;
        uint256 cost;
        uint256 offensivePower;
        uint256 hp;
    }
    struct Metadata {
        string name;
        string description;
        string image;
        Attributes attributes;
    }

    struct IdWithMetadata {
        uint256 cardTokenId;
        Metadata metadata;
    }

    function mint(
        address to,
        uint256 tokenId,
        Metadata calldata metadata
    ) external;

    function burn(uint256 tokenId) external;

    function updateMetadata(
        string calldata requestId,
        uint256 tokenId,
        Metadata calldata metadata
    ) external;
}
