// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Crowdfunding{
    address public owner;
    uint public ownerBalance = 0;

    mapping(address => uint) public users;
    mapping(address => bool) public userAdded;
    uint userCount = 0;

    event UserAdded(
        address user
    );

    mapping(address => uint) public donations;
    uint public donationsCount = 0;

    struct FundRaiser{
        address owner;
        string title;
        string description;
        uint target;
        uint amountRaised;
        uint balance;
        bool targetReached;
    }

    event FundRaiserCreated(
        address owner,
        string title,
        string description,
        uint target
    );

    mapping(uint => FundRaiser) public fundsRaisers;
    mapping(uint => bool) public fundsRaiserAdded;

    event Funded(
        address sender,
        uint amountSent,
        uint fundId,
        string fundTitle
    );

    uint fundsRaisersCount = 0;

    event Redeemed(
        address owner,
        uint amount,
        uint fundRaiserId,
        string fundTitle
    );

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function join() external {
        require(userAdded[msg.sender] == false, "You are already registered");
        userCount += 1;
        users[msg.sender] = userCount;
        userAdded[msg.sender] = true;
        emit UserAdded(msg.sender);
    }

    function startFundRaiser(string memory _title, string memory _desc, uint target) external {
        require(userAdded[msg.sender], "Sorry. You are not a registered user");
        fundsRaisersCount += 1;
        fundsRaisers[fundsRaisersCount] = FundRaiser(msg.sender, _title, _desc, target, 0, 0, false);
        fundsRaiserAdded[fundsRaisersCount] = true;
        emit FundRaiserCreated(msg.sender, _title, _desc, target);
        
    }

    function fund(uint _id) external payable{
        require(msg.value > 0, "Not enough ether sent");
        require(fundsRaiserAdded[_id], "This IDs does not exist in the fundraiser list");
        FundRaiser storage _fund = fundsRaisers[_id];
        _fund.balance += msg.value;
        _fund.amountRaised += msg.value;
        if(_fund.targetReached == false){
            if(_fund.amountRaised >= _fund.target){
                _fund.targetReached = true;
            }
        }
        donations[msg.sender] += msg.value;
        donationsCount += 1;
        emit Funded(msg.sender, msg.value, _id, _fund.title);
    }

    function redeemFunds(uint _fundRaiserId, uint amount) external{
        require(fundsRaiserAdded[_fundRaiserId], "This IDs does not exist in the fundraiser list");
        FundRaiser storage _fund = fundsRaisers[_fundRaiserId];
        require(msg.sender == _fund.owner, "You are not the owner of this fundraiser");
        require(_fund.balance >= amount, "Insufficient balance");
        require(_fund.targetReached, "Target has not been reached");
        uint ownerShare = amount/10;
        uint amountSendable = amount - ownerShare;
        (bool sent, ) = payable(msg.sender).call{value: amountSendable}("");
        require(sent, "Failed to send Ether");
        _fund.balance -= amount;
        ownerBalance += ownerShare;
        emit Redeemed(msg.sender, amountSendable, _fundRaiserId, _fund.title);
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    function withdraw() external onlyOwner{
        (bool sent, ) = payable(msg.sender).call{value: ownerBalance}("");
        require(sent, "Failed to send Ether");
        ownerBalance = 0;
    }
}