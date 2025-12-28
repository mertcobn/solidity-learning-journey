// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from "lib/forge-std/src/Script.sol";
import {MyFirstERC721Token} from "../src/MyFirstERC721Token.sol";

contract MyFirstERC721TokenScript is Script {
    function run() public returns (MyFirstERC721Token) {


        string memory tokenName = vm.envString("TOKEN_NAME");
        string memory tokenSymbol = vm.envString("TOKEN_SYMBOL");
        string memory baseURI = vm.envString("BASE_URI");

        vm.startBroadcast();
        MyFirstERC721Token myFirstERC721Token = new MyFirstERC721Token(tokenName, tokenSymbol, baseURI, 20);
        vm.stopBroadcast();
        return myFirstERC721Token;
    }
}
