// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract User{
    address public owner;
    address public userAddress;

    uint public id;

    string public name;

    uint public age;

    string public location;

    mapping(string => uint) public tokenBalances;
    mapping(string => bool) public tokenAdded;

    constructor(uint _id, string memory _name, uint _age, string memory _location){
        owner = msg.sender;
        userAddress = address(this);
        id = _id;
        name = _name;
        age = _age;
        location = _location;
        tokenBalances["ETH"] = 0;
        tokenAdded["ETH"] = true;
        tokenBalances["BTC"] = 0;
        tokenAdded["BTC"] = true;
        tokenBalances["USDT"] = 0;
        tokenAdded["USDT"] = true;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this contract");
        _;
    }

    modifier tokenAddedAlready(string memory _tokenName){
        require(tokenAdded[_tokenName], "Token already added");
        _;
    }

    function updateName(string memory _newName) external onlyOwner{
        name = _newName;
    }

    function updateAge(uint _newAge) external onlyOwner{
        age = _newAge;
    }

    function updateLocation(string memory _newLocation) external onlyOwner{
        location = _newLocation;
    }

    function addToken(string memory _tokenName, uint balance) external onlyOwner tokenAddedAlready(_tokenName){
        tokenBalances[_tokenName] = balance;
        tokenAdded[_tokenName] = true;
    }

    function updateTokenBalance(string memory _tokenName, uint _balance) external onlyOwner{
        tokenBalances[_tokenName] += _balance;
    }
}