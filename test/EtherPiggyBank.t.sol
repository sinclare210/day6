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
        address manager = etherPiggyBank.bankManager();
        assertEq(manager, address(this));
        assertEq(etherPiggyBank.isRegistered(etherPiggyBank.bankManager()), true);
    }

    function testAddMemberSuccessfullyByBankManager() public {
        address manager = etherPiggyBank.bankManager();
        address sinc = address(0x1);

        etherPiggyBank.addMember(sinc);

        assertEq(etherPiggyBank.isRegistered(sinc), true);
        address[] memory members = etherPiggyBank.getMembers();
        assertEq(members[0], manager);
        assertEq(members[1], sinc);
    }

    function testAddMemberFailsIfZeroAddress() public {
        address zero = address(0x0);
        vm.expectRevert(EtherPiggyBank.ZeroAddressNotAllowed.selector);
        etherPiggyBank.addMember(zero);
    }

    function testAddMemberFailsIfAlreadyMember() public {
        address sinc = address(0x1);

        etherPiggyBank.addMember(sinc);
        vm.expectRevert(EtherPiggyBank.AlreadyMember.selector);
        etherPiggyBank.addMember(sinc);
    }

    function testAddMemberFailsIfBankManagerAddress() public {
        address manager = etherPiggyBank.bankManager();

        vm.expectRevert(EtherPiggyBank.ManagerIsAlreadyMember.selector);
        etherPiggyBank.addMember(manager);
    }

    function testOnlyBankManagerCanAddMember() public {
        address sinc = address(0x1);
        address impersonate = address(0x2);

        vm.startPrank(impersonate);
        vm.expectRevert(EtherPiggyBank.OnlyBankManager.selector);
        etherPiggyBank.addMember(sinc);
        vm.stopPrank();
    }

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
