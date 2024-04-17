// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/ICard.sol";

contract Card is
    ERC721EnumerableUpgradeable,
    ERC721BurnableUpgradeable,
    ERC721PausableUpgradeable,
    OwnableUpgradeable,
    ERC721URIStorageUpgradeable,
    ICard
{
    function initialize() public virtual initializer {
        __ERC721_init("Card", "CRD");
        __ERC721Enumerable_init();
        __ERC721Burnable_init();
        __ERC721Pausable_init();
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function mint(
        address to,
        uint256 tokenId,
        Metadata calldata metadata
    ) public {
        _mint(to, tokenId);
        string memory metadataString = getMetadataString(metadata);
        _setTokenURI(tokenId, metadataString);
    }

    function burn(
        uint256 tokenId
    ) public override(ERC721BurnableUpgradeable, ICard) {
        super.burn(tokenId);
    }

    function _burn(
        uint256 tokenId
    )
        internal
        virtual
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function pause() public virtual {
        _pause();
    }

    function unpause() public virtual {
        _unpause();
    }

    function getMetadataString(
        Metadata calldata metadata
    ) internal pure returns (string memory) {
        string memory name = string.concat('"name":"', metadata.name, '"');

        string memory description = string.concat(
            '"description":"',
            metadata.description,
            '"'
        );

        string memory image = string.concat('"image":"', metadata.image, '"');

        string memory metadataString = string.concat(
            "{",
            name,
            ",",
            description,
            ",",
            image,
            ",",
            _formatAttributes(metadata.attributes),
            "}"
        );

        return metadataString;
    }

    function updateMetadata(
        string calldata requestId,
        uint256 tokenId,
        Metadata calldata metadata
    ) external {
        string memory newMetadata = getMetadataString(metadata);
        _setTokenURI(tokenId, newMetadata);
        emit CardMetadataUpdate(requestId, tokenId, metadata);
    }

    function _formatAttribute(
        string memory traitType,
        string memory value
    ) private pure returns (string memory) {
        return
            string.concat(
                "{",
                '"trait_type":"',
                traitType,
                '",',
                '"value":"',
                value,
                '"',
                "}"
            );
    }

    function _formatAttributeUint(
        string memory traitType,
        uint value
    ) private pure returns (string memory) {
        return _formatAttribute(traitType, Strings.toString(value));
    }

    function _formatAttributes(
        Attributes memory attributes
    ) private pure returns (string memory) {
        string memory attributesString = string.concat('"attributes":[');

        attributesString = string.concat(
            attributesString,
            _formatAttributeUint("Cost", attributes.cost),
            ","
        );
        attributesString = string.concat(
            attributesString,
            _formatAttributeUint("OffensivePower", attributes.offensivePower),
            ","
        );
        attributesString = string.concat(
            attributesString,
            _formatAttributeUint("Hp", attributes.hp),
            ","
        );
        attributesString = string.concat(
            attributesString,
            _formatAttribute("Lines", attributes.lines),
            ","
        );
        attributesString = string.concat(
            attributesString,
            _formatAttribute("Illustrator", attributes.illustrator),
            ","
        );
        attributesString = string.concat(
            attributesString,
            _formatAttribute("Cv", attributes.cv),
            "]"
        );
        return attributesString;
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(
            ERC721URIStorageUpgradeable,
            ERC721Upgradeable,
            ERC721EnumerableUpgradeable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    )
        public
        view
        override(ERC721URIStorageUpgradeable, ERC721Upgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    )
        internal
        virtual
        override(
            ERC721Upgradeable,
            ERC721EnumerableUpgradeable,
            ERC721PausableUpgradeable
        )
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }
}
