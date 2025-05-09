// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract EtherPiggyBank {

    address public owner;

    address bankManager;

    uint256 public balance;

    constructor (){
        owner = msg.sender;
    }

    modifier onlyOwner () {
        require (owner == msg.sender);
        _;
    }

    function deposit () public payable {
        require (msg.value > 0, "Amount must be greater than zero");
        balance = balance + msg.value;
    }
}