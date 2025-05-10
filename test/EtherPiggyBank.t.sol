// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {EtherPiggyBank} from "../src/EtherPiggyBank.sol";

contract EtherPiggyBankTest is Test {
    EtherPiggyBank public etherPiggyBank;

    function setUp() public {
        etherPiggyBank = new EtherPiggyBank();
    }

    function testConstructorInitializesBankManagerAndRegistersThem() public view {
        assertEq(etherPiggyBank.bankManager(), address(this));
        assertEq(etherPiggyBank.isRegistered(etherPiggyBank.bankManager()), true);
    }

    function testAddMemberSuccessfullyByBankManager() public {
        address manager = etherPiggyBank.bankManager();
        address sinc = address(0x1);

        vm.startPrank(manager);
        etherPiggyBank.addMember(sinc);
        assertEq(etherPiggyBank.isRegistered(sinc), true);
        address[] memory members = etherPiggyBank.getMembers();
        assertEq(members[0], manager);
        assertEq(members[1], sinc);
    }

    function testAddMemberFailsIfZeroAddress() public {}

    function testAddMemberFailsIfAlreadyMember() public {}

    function testAddMemberFailsIfBankManagerAddress() public {}

    function testOnlyBankManagerCanAddMember() public {}

    function testDepositFailsIfNotRegistered() public {}

    function testDepositFailsIfZeroAmount() public {}

    function testDepositIncreasesBalanceCorrectly() public {}

    function testDepositAmountWorksSameAsDeposit() public {}

    function testGetMembersReturnsCorrectList() public {}

    function testGetBalanceByUserReturnsCorrectBalance() public {}

    function testGetBalanceByManagerReturnsCorrectBalance() public {}

    function testGetBalanceByManagerFailsForNonManager() public {}

    function testGetBalanceByManagerFailsIfZeroAddress() public {}

    function testWithdrawFailsIfNotRegistered() public {}

    function testWithdrawFailsIfAmountZero() public {}

    function testWithdrawFailsIfAmountExceedsBalance() public {}

    function testWithdrawSucceedsAndReducesBalance() public {}

    function testWithdrawRevertsIfTransferFails() public {}
}
