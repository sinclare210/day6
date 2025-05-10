// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {EtherPiggyBank} from "../src/EtherPiggyBank.sol";

contract RevertingReceiver {
    fallback() external payable {
        revert("Don't send me ETH");
    }

    receive() external payable {
        revert("Don't send me ETH");
    }

    EtherPiggyBank public bank;

    constructor(address _bank) {
        bank = EtherPiggyBank(_bank);
    }

    function depositToBank() external payable {
        bank.deposit{value: msg.value}();
    }

    function withdrawFromBank(uint256 amount) external {
        bank.withdraw(amount);
    }
}

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

    function testDepositFailsIfNotRegistered() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        vm.startPrank(sinc);
        vm.expectRevert(EtherPiggyBank.NotAMember.selector);
        etherPiggyBank.deposit{value: 1 ether}();
        console.log(sinc.balance);
        vm.stopPrank();
    }

    function testDepositFailsIfZeroAmount() public {
        address sinc = address(0x1);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);
        vm.expectRevert(EtherPiggyBank.AmountMustBeGreaterThanZero.selector);
        etherPiggyBank.deposit{value: 0 ether}();
        console.log(sinc.balance);
        vm.stopPrank();
    }

    function testDepositIncreasesBalanceCorrectly() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);

        etherPiggyBank.deposit{value: 1 ether}();
        console.log(sinc.balance);
        assertEq(etherPiggyBank.getBalanceByUser(), 1 ether);
        vm.stopPrank();
    }

    function testGetMembersReturnsCorrectList() public {
        address sinc = address(0x1);
        address sinc1 = address(0x2);
        address sinc2 = address(0x3);
        address sinc3 = address(0x4);

        etherPiggyBank.addMember(sinc);
        etherPiggyBank.addMember(sinc1);
        etherPiggyBank.addMember(sinc2);
        etherPiggyBank.addMember(sinc3);

        address[] memory members = etherPiggyBank.getMembers();
        assertEq(members[1], sinc);
        assertEq(members[2], sinc1);
        assertEq(members[3], sinc2);
        assertEq(members[4], sinc3);
    }

    function testGetBalanceByUserReturnsCorrectBalance() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);

        etherPiggyBank.deposit{value: 1 ether}();
        console.log(sinc.balance);
        assertEq(etherPiggyBank.getBalanceByUser(), 1 ether);

        vm.stopPrank();
    }

    function testGetBalanceByManagerReturnsCorrectBalance() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);

        etherPiggyBank.deposit{value: 1 ether}();
        vm.stopPrank();
        assertEq(etherPiggyBank.getBalanceByManager(sinc), 1 ether);
    }

    function testGetBalanceByManagerFailsForNonManager() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);

        etherPiggyBank.deposit{value: 1 ether}();
        vm.expectRevert(EtherPiggyBank.OnlyBankManager.selector);
        etherPiggyBank.getBalanceByManager(sinc);
        vm.stopPrank();
    }

    function testGetBalanceByManagerFailsIfZeroAddress() public {
        address zero = address(0x0);

        vm.expectRevert(EtherPiggyBank.ZeroAddressNotAllowed.selector);
        etherPiggyBank.getBalanceByManager(zero);
    }

    function testWithdrawFailsIfNotRegistered() public {
        address sinc = address(0x1);

        vm.startPrank(sinc);

        vm.expectRevert(EtherPiggyBank.NotAMember.selector);
        etherPiggyBank.withdraw(1 ether);

        vm.stopPrank();
    }

    function testWithdrawFailsIfAmountZero() public {
        address sinc = address(0x1);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);

        vm.expectRevert(EtherPiggyBank.AmountMustBeGreaterThanZero.selector);
        etherPiggyBank.withdraw(0 ether);

        vm.stopPrank();
    }

    function testWithdrawFailsIfAmountExceedsBalance() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);
        etherPiggyBank.deposit{value: 1 ether}();

        vm.expectRevert(EtherPiggyBank.InsufficientFunds.selector);
        etherPiggyBank.withdraw(1.5 ether);

        vm.stopPrank();
    }

    function testWithdrawSucceedsAndReducesBalance() public {
        address sinc = address(0x1);
        vm.deal(sinc, 2 ether);

        etherPiggyBank.addMember(sinc);

        vm.startPrank(sinc);
        etherPiggyBank.deposit{value: 1 ether}();

        etherPiggyBank.withdraw(0.5 ether);
        assertEq(etherPiggyBank.getBalanceByUser(), 0.5 ether);

        vm.stopPrank();
    }

    function testWithdrawRevertsIfTransferFails() public {
        // Deploy a malicious contract that rejects Ether
        RevertingReceiver malicious = new RevertingReceiver(address(etherPiggyBank));

        // Add it as a member
        etherPiggyBank.addMember(address(malicious));

        // Fund the malicious contract with 1 ether so it can deposit
        vm.deal(address(malicious), 1 ether);

        // Deposit into the piggy bank from malicious contract
        vm.startPrank(address(malicious));
        malicious.depositToBank{value: 1 ether}();
        vm.stopPrank();

        // Attempt withdrawal, which should revert due to receive() reverting
        vm.startPrank(address(malicious));
        vm.expectRevert(EtherPiggyBank.TransferFailed.selector);
        malicious.withdrawFromBank(1 ether);
        vm.stopPrank();
    }
}
