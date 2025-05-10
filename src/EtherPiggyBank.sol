// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EtherPiggyBank {


    address bankManager;

    address[] members;

    mapping (address => uint) balance;

    mapping(address => bool) registeredUsers;

    constructor (){
        bankManager = msg.sender;
        members.push(msg.sender);
    }

    modifier onlyBankManager () {
        require (bankManager == msg.sender, "Only bank manager can perform this action");
        _;
    }

    function deposit () public payable {
        require (msg.value > 0, "Amount must be greater than zero");
        
    }
}