// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/IPack.sol";
import "./interfaces/IPlaceholder.sol";
import "./erc/interfaces/IERC6551Registry.sol";

contract PackFactory is Initializable, OwnableUpgradeable {
    IPack private pack;
    IPlaceholder private placeholder;
    IERC6551Registry private registry;
    address private implementationAddress;
    address private packContractAddress;
    uint256 private chainId;

    struct TokenIdPair {
        uint256 placeholderTokenId;
        uint256 cardTokenId;
    }
    event PackCreate(
        string indexed _requestId,
        uint256 indexed _packTokenId,
        TokenIdPair[] indexed _tokenIdPairs
    );

    function initialize(
        address _pack,
        address _placeholder,
        address _registry,
        address _implementation
    ) public initializer {
        pack = IPack(_pack);
        packContractAddress = _pack;
        placeholder = IPlaceholder(_placeholder);
        registry = IERC6551Registry(_registry);
        implementationAddress = _implementation;
        assembly {
            let _chainId := chainid()
            sstore(chainId.slot, _chainId)
        }
        __Ownable_init();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    struct PackContent {
        uint256 packTokenId;
        TokenIdPair[] tokenIdPairs;
    }
    function createPacks(
        string calldata requestId,
        address to,
        PackContent[] calldata packs
    ) public {
        for (uint256 i = 0; i < packs.length; ) {
            PackContent calldata _pack = packs[i];
            pack.mint(to, _pack.packTokenId);

            address tba = registry.createAccount(
                implementationAddress,
                bytes32(0),
                chainId,
                packContractAddress,
                _pack.packTokenId
            );
            pack.setTBA(_pack.packTokenId, tba);

            for (uint256 j = 0; j < _pack.tokenIdPairs.length; ) {
                placeholder.mint(tba, _pack.tokenIdPairs[j].placeholderTokenId);
                unchecked {
                    j++;
                }
            }

            emit PackCreate(requestId, _pack.packTokenId, _pack.tokenIdPairs);
            unchecked {
                i++;
            }
        }
    }
}
