// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";

contract Token2 is IBasicERC20Token{

    string public override name = "Token2";
    string public override symbol = "TK2";
    uint8 public override decimals = 18;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

   constructor(uint256 total) {
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 amount) public override returns (bool) {
        require(amount <= balances[msg.sender], "You don't have enough balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function approve(address delegate, uint256 amount) public override returns (bool) {
        require(amount <= balances[msg.sender], "You don't have enough balance");
        allowed[msg.sender][delegate] = amount;
        emit Approval(msg.sender, delegate, amount);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address receiver, uint256 amount) public override returns (bool) {
        require(amount <= balances[owner], "Owner don't have enough balance");
        require(amount <= allowed[owner][msg.sender], "The amount approved is not enough");

        balances[owner] -= amount;
        allowed[owner][msg.sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(owner, receiver, amount);
        return true;
    }
}
