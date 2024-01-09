// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

/** 
 Deploy to Anvil (anvil chain started in a different terminal): 
 forge script script/DeployERC20Token.s.sol \
 --rpc-url http://127.0.0.1:8545 \
 --broadcast \
 --private-key=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
 @dev use --interactive for private key with real money
*/
contract DeployERC20Token is Script {
    uint256 public INITIAL_SUPPLY = 1000 ether;
    
    function run() external returns (ERC20Token token) {
        vm.startBroadcast();
        token = new ERC20Token(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}
