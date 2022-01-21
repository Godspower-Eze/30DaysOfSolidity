// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract GuessAWord {
  address public owner;
  bytes32 public correctWord;

  constructor(){
      owner = msg.sender;
  }
  
  modifier onlyOwner(){
      require(owner == msg.sender, "You are not the owner");
      _;
  }

  function setWord(string memory word) external onlyOwner{
      correctWord = keccak256(abi.encodePacked(word));
  }
  
  function guess(string memory word) external view returns (bool){
      return keccak256(abi.encodePacked(word)) == correctWord;
  }

}
