// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./User.sol";

contract UserManager{

    address public owner;

    uint public contractCount = 0;
    User[] public contracts;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this contract");
        _;
    }

    function create(string memory _name, uint _age, string memory _location) external onlyOwner{
        contractCount += 1;
        User user = new User(contractCount, _name, _age, _location);
        contracts.push(user);
    }

    function updateName(uint _index, string memory _newName) external onlyOwner {
        User user = contracts[_index];
        user.updateName(_newName);
    }

    function updateAge(uint _index, uint _newAge) external onlyOwner {
        User user = contracts[_index];
        user.updateAge(_newAge);
    }

    function updateLocation(uint _index, string memory _newLocation) external onlyOwner {
        User user = contracts[_index];
        user.updateLocation(_newLocation);
    }

    function addToken(uint _index, string memory _tokenName, uint balance) external onlyOwner{
        User user = contracts[_index];
        user.addToken(_tokenName, balance);
    }

    function updateTokenBalance(uint _index, string memory _tokenName, uint _balance) external onlyOwner{
        User user = contracts[_index];
        user.updateTokenBalance(_tokenName, _balance);
    }

    function getId(uint _index) external view returns(uint){
       User user = contracts[_index];
       return user.id();
    }

    function getName(uint _index) external view returns(string memory){
       User user = contracts[_index];
       return user.name();
    }

    function getAge(uint _index) external view returns(uint){
       User user = contracts[_index];
       return user.age();
    }

    function getLocation(uint _index) external view returns(string memory){
       User user = contracts[_index];
       return user.location();
    }

    function tokenAvailable(uint _index, string memory tokenName) external view returns(bool){
       User user = contracts[_index];
       return user.tokenAdded(tokenName);
    }

    function tokenBalance(uint _index, string memory tokenName) external view returns(uint){
       User user = contracts[_index];
       return user.tokenBalances(tokenName);
    }

    function getContracts() external view returns(User[] memory){
        return contracts;
    }
}
