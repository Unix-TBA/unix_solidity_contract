// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import {Token} from "../src/unix.sol";


contract TokenFactory {
    
    uint256 constant tokenID = 1;

    mapping (address => address[]) tokenCreated;

    function createNft (string memory tokenName, string memory tokenSymbol,string memory uri) external  {
        Token token = new Token(tokenName, tokenSymbol, msg.sender, tokenID, uri);

        tokenCreated[msg.sender].push(address(token));
    }

    function viewTokensCreated (address addr) external view returns (address[] memory) {

        return tokenCreated[addr];
    }
}