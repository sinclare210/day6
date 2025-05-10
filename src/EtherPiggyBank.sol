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
        registeredUsers[bankManager] = true;
    }

    modifier onlyBankManager () {
        require (bankManager == msg.sender, "Only bank manager can perform this action");
        _;
    }

    modifier onlyRegisteredMember() {
        require(registeredUsers[msg.sender], "Must be a member");
        _;
    }

    function deposit () public payable {
        
        
        
    }

    function addMember (address addy) public onlyBankManager {
        require(msg.sender != address(0), "Address zero not allowed");
        require(msg.sender != bankManager, "Bank manager is a member");
        require(!registeredUsers[addy], "is a member");
        registeredUsers[addy] = true;
        members.push(addy);
    }

    function getMembers() public view returns (address[] memory){
        return members;
    }

    function depositAmount () public onlyRegisteredMember payable{
        require (msg.value > 0, "Amount must be greater than zero");
        balance[msg.sender] += msg.value;
    }

    function getBalanceByManager (address _member) public view onlyBankManager returns (uint256){
       require(_member != address(0), "Address zero not allowed");
       return  balance[_member];
    }

    function withdraw (uint256 _amount) public onlyRegisteredMember {
        require(msg.sender != address(0), "Address zero not allowed");
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed");

    }

    function getBalanceByUser () public view returns (uint256){
       require(msg.sender != address(0), "Address zero not allowed");
       return  balance[msg.sender];
    }
}