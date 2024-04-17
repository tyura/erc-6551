// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/IPlaceholder.sol";

contract Placeholder is
    OwnableUpgradeable,
    ERC721EnumerableUpgradeable,
    ERC721BurnableUpgradeable,
    IPlaceholder
{
    uint256 constant PLACEHOLDER_COUNT = 5;

    function initialize() public virtual initializer {
        __ERC721_init("Placeholder", "PLA");
        __ERC721Enumerable_init();
        __ERC721Burnable_init();
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function burn(
        uint256 tokenId
    ) public override(ERC721BurnableUpgradeable, IPlaceholder) {
        _burn(tokenId);
    }

    function getTokenIdsOfOwner(
        address owner
    ) external view override returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner);
        require(
            tokenCount == PLACEHOLDER_COUNT,
            "Placeholder count is not correct"
        );

        uint256[] memory tokenIds = new uint256[](PLACEHOLDER_COUNT);
        for (uint256 i = 0; i < tokenCount; ) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
            unchecked {
                i++;
            }
        }
        return tokenIds;
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    )
        internal
        virtual
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }
}
