// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./User.sol";
import "./IUser.sol";

contract UserManager{

    address public owner;

    uint public contractCount = 0;
    address[] public contractsAddresses;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call contract");
        _;
    }

    function create(string memory _name, uint _age, string memory _location) external onlyOwner{
        contractCount += 1;
        User user = new User(contractCount, _name, _age, _location);
        contractsAddresses.push(address(user));
    }

    function updateName(uint _index, string memory _newName) external onlyOwner {
        address contractAddress = contractsAddresses[_index];
        IUser(contractAddress).updateName(_newName);
    }

    function updateAge(uint _index, uint _newAge) external onlyOwner {
        address contractAddress = contractsAddresses[_index];
        IUser(contractAddress).updateAge(_newAge);
    }

    function updateLocation(uint _index, string memory _newLocation) external onlyOwner {
        address contractAddress = contractsAddresses[_index];
        IUser(contractAddress).updateLocation(_newLocation);
    }

    function addToken(uint _index, string memory _tokenName, uint balance) external onlyOwner{
        address contractAddress = contractsAddresses[_index];
        IUser(contractAddress).addToken(_tokenName, balance);
    }

    function updateTokenBalance(uint _index, string memory _tokenName, uint _balance) external onlyOwner{
        address contractAddress = contractsAddresses[_index];
        IUser(contractAddress).updateTokenBalance(_tokenName, _balance);
    }

    function getId(uint _index) external view returns(uint){
       address contractAddress = contractsAddresses[_index];
       return IUser(contractAddress).id();
    }

    function getName(uint _index) external view returns(string memory){
       address contractAddress = contractsAddresses[_index];
       return IUser(contractAddress).name();
    }

    function getAge(uint _index) external view returns(uint){
       address contractAddress = contractsAddresses[_index];
       return IUser(contractAddress).age();
    }

    function getLocation(uint _index) external view returns(string memory){
        address contractAddress = contractsAddresses[_index];
        return IUser(contractAddress).location();
    }

    function tokenAvailable(uint _index, string memory tokenName) external view returns(bool){
        address contractAddress = contractsAddresses[_index];
        return IUser(contractAddress).tokenAdded(tokenName);
    }

    function tokenBalance(uint _index, string memory tokenName) external view returns(uint){
        address contractAddress = contractsAddresses[_index];
        return IUser(contractAddress).tokenBalances(tokenName);
    }

    function getContracts() external view returns(address[] memory){
        return contractsAddresses;
    }
}
