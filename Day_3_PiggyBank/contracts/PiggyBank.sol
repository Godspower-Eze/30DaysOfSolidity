// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PiggyBank {

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    event Deposit(uint amount);
    event Withdraw(uint amount);

    receive() external payable{
        emit Withdraw(msg.value);
    }

    function getBalance() external view returns(uint){
        uint balance;
        balance = address(this).balance;
        return balance;
    }

    function withdraw() external {
        require(owner == msg.sender, "Only owner can call this function");
        emit Deposit(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}