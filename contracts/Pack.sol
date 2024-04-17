// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/ICard.sol";
import "./interfaces/IPlaceholder.sol";
import "./interfaces/IPack.sol";
// import "./erc/interfaces/IERC6551Executable.sol";

contract Pack is
    ERC721EnumerableUpgradeable,
    ERC721BurnableUpgradeable,
    OwnableUpgradeable,
    IPack
{
    ICard private card;
    IPlaceholder private placeholder;
    // IERC6551Executable private erc6551Executable;

    mapping(uint256 packTokenId => mapping(uint256 cardTokenId => bytes32))
        private _hashes;
    mapping(uint256 packTokenId => address) private tbas;

    function initialize(
        address _card,
        address _placeholder
    ) public virtual initializer {
        card = ICard(_card);
        placeholder = IPlaceholder(_placeholder);

        __ERC721_init("Pack", "PCK");
        __ERC721Enumerable_init();
        __ERC721Burnable_init();
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function open(
        address to,
        uint256 packTokenId,
        ICard.IdWithMetadata[] calldata idWithMetadatas
    ) public {
        _burn(packTokenId);

        address tbaAddress = tbas[packTokenId];
        uint256[] memory placeholderTokenIds = placeholder.getTokenIdsOfOwner(
            tbaAddress
        );
        // erc6551Executable = IERC6551Executable(tbaAddress);

        require(
            placeholderTokenIds.length == idWithMetadatas.length,
            "Card count is not correct"
        );
        for (uint256 i; i < placeholderTokenIds.length; ) {
            placeholder.burn(placeholderTokenIds[i]);
            // erc6551Executable.execute(
            //     address(placeholder),
            //     0,
            //     abi.encodeWithSignature(
            //         "burn(uint256)",
            //         placeholderTokenIds[i]
            //     ),
            //     0
            // );
            card.mint(
                to,
                idWithMetadatas[i].cardTokenId,
                idWithMetadatas[i].metadata
            );
            unchecked {
                i++;
            }
        }
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function burn(
        uint256 tokenId
    ) public override(ERC721BurnableUpgradeable, IPack) {
        super.burn(tokenId);
    }

    function setTBA(uint256 packTokenId, address tba) external {
        tbas[packTokenId] = tba;
    }

    function getTBA(uint256 packTokenId) external view returns (address) {
        return tbas[packTokenId];
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
