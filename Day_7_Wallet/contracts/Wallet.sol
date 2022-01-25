// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Wallet {

    mapping(address => uint) public balances;

    event Withdraw(address receiver, uint amount);
    event Sent(address sender, address receiver, uint amount);

    bool locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    receive() external payable{
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external noReentrant{
        uint balance = balances[msg.sender];
        require(amount <= balance, "You don't have enough ether in your balance");
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send Ether");
        emit Withdraw(msg.sender, amount);
    }

    function send(address payable receiver, uint amount) external{
        uint balance = balances[msg.sender];
        require(amount <= balance, "You don't have enough ether in your balance");
        balance -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}