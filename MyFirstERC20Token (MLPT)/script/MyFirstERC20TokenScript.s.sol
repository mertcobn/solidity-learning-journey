// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MyFirstERC20Token} from "../src/MyFirstERC20Token.sol";

contract MyFirstERC20TokenScript is Script {
    function run() public returns (MyFirstERC20Token) {
        vm.startBroadcast();
        MyFirstERC20Token myFirstERC20Token = new MyFirstERC20Token();
        vm.stopBroadcast();
        return myFirstERC20Token;
    }
}
