// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {Token} from "../src/unix.sol";

interface IERC6551Registry {
    /**
     * @dev The registry MUST emit the ERC6551AccountCreated event upon successful account creation.
     */
    event ERC6551AccountCreated(
        address account,
        address indexed implementation,
        bytes32 salt,
        uint256 chainId,
        address indexed tokenContract,
        uint256 indexed tokenId
    );

    /**
     * @dev The registry MUST revert with AccountCreationFailed error if the create2 operation fails.
     */
    error AccountCreationFailed();

    /**
     * @dev Creates a token bound account for a non-fungible token.
     *
     * If account has already been created, returns the account address without calling create2.
     *
     * Emits ERC6551AccountCreated event.
     *
     * @return account The address of the token bound account
     */
    function createAccount(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external returns (address account);

    /**
     * @dev Returns the computed token bound account address for a non-fungible token.
     *
     * @return account The address of the token bound account
     */
    function account(
        address implementation,
        bytes32 salt,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId
    ) external view returns (address account);
}


contract TokenFactory {
    mapping (address => address[]) tokenCreated;
    address public constant accountProxy = 0x55266d75D1a14E4572138116aF39863Ed6596E7F;
    address public constant registry = 0x000000006551c19487814612e58FE06813775758;

    function port (string memory tokenName, string memory tokenSymbol, string memory uri, uint256 tokenId)  external {
        address caller = msg.sender; // cache the sender
        Token token = new Token(tokenName, tokenSymbol, caller, tokenId, uri);
        IERC6551Registry(registry).createAccount(
            accountProxy,
            0x0,
            8453,
            address(token),
            tokenId
        );

        tokenCreated[caller].push(address(token));
    }

    function viewTokensCreated (address addr) external view returns (address[] memory) {

        return tokenCreated[addr];
    }
}

// Port Factory Base = 0x6fcD54b2B5945AeB3555fE68548448904d2a3F9c