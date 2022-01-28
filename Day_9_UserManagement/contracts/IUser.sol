// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IUser{
    
    function id() external view returns(uint);

    function name() external view returns(string memory);

    function age() external view returns(uint);

    function location() external view returns(string memory);

    function tokenBalances(string memory) external view returns(uint);
    function tokenAdded(string memory) external view returns(bool);


    function updateName(string memory) external;

    function updateAge(uint _newAge) external;

    function updateLocation(string memory) external;

    function addToken(string memory, uint) external;

    function updateTokenBalance(string memory, uint) external;
}