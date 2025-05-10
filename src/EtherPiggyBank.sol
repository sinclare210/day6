// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EtherPiggyBank {
    address immutable bankManager;
    address[] private members;

    mapping(address => uint256) private balance;
    mapping(address => bool) private registeredUsers;

    // Custom errors
    error OnlyBankManager();
    error NotAMember();
    error ZeroAddressNotAllowed();
    error AlreadyMember();
    error ManagerIsAlreadyMember();
    error AmountMustBeGreaterThanZero();
    error InsufficientFunds();
    error TransferFailed();

    constructor() {
        bankManager = msg.sender;
        members.push(msg.sender);
        registeredUsers[bankManager] = true;
    }

    modifier onlyBankManager() {
        if (msg.sender != bankManager) revert OnlyBankManager();
        _;
    }

    modifier onlyRegisteredMember() {
        if (!registeredUsers[msg.sender]) revert NotAMember();
        _;
    }

    function deposit() public payable onlyRegisteredMember {
        if (msg.value == 0) revert AmountMustBeGreaterThanZero();
        balance[msg.sender] += msg.value;
    }

    function addMember(address addy) public onlyBankManager {
        if (addy == address(0)) revert ZeroAddressNotAllowed();
        if (addy == bankManager) revert ManagerIsAlreadyMember();
        if (registeredUsers[addy]) revert AlreadyMember();

        registeredUsers[addy] = true;
        members.push(addy);
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }

    function depositAmount() public payable onlyRegisteredMember {
        if (msg.value == 0) revert AmountMustBeGreaterThanZero();
        balance[msg.sender] += msg.value;
    }

    function getBalanceByManager(address _member) public view onlyBankManager returns (uint256) {
        if (_member == address(0)) revert ZeroAddressNotAllowed();
        return balance[_member];
    }

    function withdraw(uint256 _amount) public onlyRegisteredMember {
        if (_amount == 0) revert AmountMustBeGreaterThanZero();
        if (_amount > balance[msg.sender]) revert InsufficientFunds();

        (bool success,) = msg.sender.call{value: _amount}("");
        if (!success) revert TransferFailed();

        balance[msg.sender] -= _amount;
    }

    function getBalanceByUser() public view returns (uint256) {
        return balance[msg.sender];
    }
}
