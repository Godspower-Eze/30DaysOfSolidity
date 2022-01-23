// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Lottery {

    address public owner;
    address payable[] players;
    
    uint public stakeAmount = 1 ether;

    uint ownerPercentage = 10;

    constructor(){
        owner = msg.sender;
    }

    modifier stakeIsEnough(){
        require(msg.value >= stakeAmount, "Stake is not enough");
        _;
    }

    modifier adminsCantPlay(){
        require(msg.sender != owner, "Sorry! Admins can play");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier upToTenPlayers() {
        require(players.length >= 10, "Players must be up to 10");
        _;
    }

    modifier playersLengthMustBeZero() {
        require(players.length == 0, "Players length must be 0");
        _;
    }
    
    receive() external payable stakeIsEnough adminsCantPlay{
        players.push(payable(msg.sender));
    }
    
    function getPlayers() external view returns(address payable[] memory){
        return players;
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }

    function generateRandomNumber() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length))) % players.length;
    }

    function pickWinner() external onlyOwner upToTenPlayers{
        address payable winner;
        uint amountSendable = address(this).balance - (address(this).balance/ownerPercentage);

        winner = players[generateRandomNumber()];
        winner.transfer(amountSendable);
        players = new address payable[](0);
    }

    function withdraw() external onlyOwner playersLengthMustBeZero{
        payable(owner).transfer(address(this).balance);
    }
}