// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {MyFirstERC20Token} from "../src/MyFirstERC20Token.sol";

contract MyFirstERC20TokenScript is Script {
    MyFirstERC20Token public myFirstERC20Token;

    function run() public {
        vm.startBroadcast();

        myFirstERC20Token = new MyFirstERC20Token();

        vm.stopBroadcast();
    }
}
