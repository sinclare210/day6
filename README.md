# EtherPiggyBank Smart Contract

## Overview
The EtherPiggyBank contract allows users to deposit and withdraw Ether while managing a list of registered members. The contract includes features such as adding/removing members, deposit functionality, and secure withdrawal processes. The bank manager has special permissions for certain operations like managing members and withdrawing Ether from the contract.

## Table of Contents
1. [Installation](#installation)
2. [Contract Overview](#contract-overview)
3. [Testing](#testing)
4. [Functionality](#functionality)
5. [Error Handling](#error-handling)
6. [Security](#security)
7. [License](#license)

## Installation
Instructions to set up the project and get started:

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/EtherPiggyBank.git
    cd EtherPiggyBank
    ```

2. Install dependencies:
    ```bash
    npm install
    ```

### Requirements
- Solidity v0.8.19
- Foundry (Forge and Cast)

## Contract Overview
The `EtherPiggyBank` contract allows Ether deposits, withdrawals, and member management.

### EtherPiggyBank Contract
- Manages member registrations and balance tracking.
- Only the bank manager can add or remove members.
- Members can deposit Ether, and withdrawals are tracked and controlled.

### RevertingReceiver Contract
- A simulated malicious contract used in tests.
- Reverts any Ether transfer to it using `fallback` and `receive` functions.

## Testing
The smart contract includes tests to verify functionality and error handling.

### Setup
To run tests using Foundry:

1. Install Foundry if you haven't already:
    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    ```

2. Run the tests:
    ```bash
    forge test
    ```

### Example Test Case
```solidity
function testDepositFailsIfNotRegistered() public {
    address sinc = address(0x1);
    vm.deal(sinc, 2 ether);

    vm.startPrank(sinc);
    vm.expectRevert(EtherPiggyBank.NotAMember.selector);
    etherPiggyBank.deposit{value: 1 ether}();
    vm.stopPrank();
}

## Functionality

### Adding a Member
- The bank manager can add new members.
- Members must not be zero addresses or already registered.

### Deposits
- Only registered members can deposit Ether.
- The deposit amount must be greater than zero.

### Withdrawals
- Only registered members can withdraw funds.
- Withdrawals must be greater than zero and not exceed the available balance.

### Bank Manager
- The bank manager has special privileges, such as viewing any member's balance and withdrawing Ether from the bank.

## Error Handling

### Custom Errors
- **NotAMember**: Raised when a non-member tries to perform a restricted action.
- **AmountMustBeGreaterThanZero**: Raised when the deposit or withdrawal amount is zero.
- **InsufficientFunds**: Raised when attempting to withdraw more than the available balance.
- **TransferFailed**: Raised if a transfer fails during a withdrawal.

#### Example usage of custom errors:
```solidity
if (amount == 0) revert AmountMustBeGreaterThanZero();

## Security
The contract is designed with several security features:
- Only the bank manager can add members to the contract.
- Only registered members can perform deposits and withdrawals.
- Malicious contracts that reject Ether transfers are handled by the `TransferFailed` error during withdrawals.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
