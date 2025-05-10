// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {EtherPiggyBank} from "../src/EtherPiggyBank.sol";

contract EtherPiggyBankScript is Script {

    EtherPiggyBank public etherPiggyBank;
    
    function setUp () public {

    }

    function run () public {
        vm.startBroadcast();
        etherPiggyBank = new EtherPiggyBank();
        vm.stopBroadcast();
    }
}