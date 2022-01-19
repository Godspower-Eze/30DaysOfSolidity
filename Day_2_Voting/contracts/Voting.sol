// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Voting {
    address owner;

    constructor(){
        owner = msg.sender;
    }

    uint public candidateCount = 0;

    uint public votersCount = 0;

    struct Voters{
        uint id;
        string name;
        bool voted;
    }

    struct Candidate{
        uint id;
        string name;
    }

    mapping(address => Candidate) public candidates;
    mapping(address => bool) public candidateInserted;
    mapping(address => uint) public votes;

    mapping(address => Voters) public voters;
    mapping(address => bool) public voterInserted;

    function addCandidate(address _addr, string memory _name) public{
        require(msg.sender == owner, "Only owner can call this function");
        require(candidateInserted[_addr] == false, "Candidate can't be added");
        candidateCount = candidateCount + 1;
        candidates[_addr] = Candidate(candidateCount, _name);
        candidateInserted[_addr] = true;
    }

    function addVoter(address _addr, string memory _name) public{
        require(msg.sender == owner, "Only owner can call this function");
        require(voterInserted[_addr] == false, "Voters can't be added");
        votersCount = votersCount + 1;
        voters[_addr] = Voters(votersCount, _name, false);
        voterInserted[_addr] = true;
    }

    function vote(address _candidateAddress) public{
        require(voterInserted[msg.sender] == true, "You are not among the voters");
        Voters storage voter = voters[msg.sender];
        require(voter.voted == false, "You can't vote twice");
        votes[_candidateAddress] = votes[_candidateAddress] + 1;
        voter.voted = true;
    }

}