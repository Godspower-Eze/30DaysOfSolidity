
# Project Overview

This is a voting smart contract. It allows for a fair election.

Here are conditions met in this project

- Only one person has control over the contract; the person who deployes the contract.
- Only the controller can add an electoral candidate.
- Only the controller can add a potential voter.
- A candidate can only be added once.
- A voter can only be added or registered.
- A voter can only vote once; obviously, lol.

Here's a challenge

- Make the contract a multi-signature contract.

Let's go through the smart contract

## `pragma solidity >=0.4.22 <0.9.0;`

This defines the version of solidity been used. It means the contract would be compiled using rules from version `0.4.22` to versions lower that `0.9.0`.

It could also be defined in this way:

`pragma solidity 0.8.0;` or `pragma solidity ^0.8.7;`; the former meaning version `0.8.0` strictly and the latter meaning version `0.8.7` and above.

## `contract Voting {.....}`

This creates a contract object just like classes are created in other languages. All the logic of the smart contract is written inside the block created by the contract.

## `address owner;`

Here, we declare an `owner` variable of `address` type

### `address`

This is a data type that holds 20 bytes addresses like `0x205aE213B67751fa825C8F3A5903Ab2c1D7B1B77`

## `constructor(){owner = msg.sender;}`

### `constructor(){....}`

A constructor in Object Oriented Programming is a function that is run when an object is initialized. That is, when an instance of that object is created.
In this case, the constructor is executed when a contract is deployed. 

That means, any code inside the constructor is run when the contract is deployed. Let's see what's inside the constructor

### `owner = msg.sender;`

The `owner` variable that was declared above is assigned the value `msg.sender`.

`msg` is an object with a number of attributes in every smart contract and `sender` is one them. `msg.sender` returns the address of the caller of a smart contract.
In the case of `constructor`, the deployer is the caller so the `owner` is set to the address of the user that deployed the smart contract. Remember above where we 
mentioned the controller. The person who deploys the smart contract is the controller.

## `uint public candidateCount = 0;`

This sets the value of the number of electoral candidates. 

As we talked about in `Day 1`, `uint` is the unsigned integer type, `public` is the visibility modifier that exposes the variable by providing a getter function;
in this case `candidateCount()`. And, `candidateCount` the variable name set to `0`.

## `uint public votersCount = 0;`

This is the same as `uint public candidateCount = 0;` above

## `struct Voters { uint id; string name; bool voted;}`

A `struct` is a data type that groups together related data. It's like a database record.

This is a `struct` called `Voters` that stores information of potential voters. Check `Day 1` for more on `struct`

## `struct Candidate{uint id; string name;}`

A `struct` that stores the informations of electoral candidates.

## `mapping(address => Candidate) public candidates;`

A `mapping` is like a hash-table or dictionary that stores data in a key-value pair format. In this case, the type of the key would an `address` type and the type
of the value would be the `struct` called `Candidate` created above.

You can't get all the key-value pairs of `mapping` at once rather you use the key to get specific value. Also, you can't get the length of a mapping

## `mapping(address => bool) public candidateInserted;`

We need a way to track that a candidate has been added to the `mapping` of `candidates` above so we use `candidateInserted`.

It maps addresses to boolean(`true` or `false`) so that once an address is added to `candidates`, we add that address to `candidateInserted` and set it to `true`
unlike it's default `false` so we could use it to check that the candidate has been added. We'll set that later in this guide.

## `mapping(address => uint) public votes;`

This maps addresses of `candidates` to the number of votes they have gotten from their voters.

## `mapping(address => Voters) public voters;`

This maps addresses to the `Voters` struct that stores the information of potential voters.

## `mapping(address => bool) public voterInserted;`

This does the same thing as `mapping(address => bool) public candidateInserted;` above; keeping track of the addresses added to the `voters` mapping by setting them
as either `true` or `false`(default). `true` signifies that the voter has been added to the `voters` mapping and would be used to check that a voter is not added twice.

## `function addCandidate(address _addr, string memory _name) public{....}`

This function is responsible for adding new electoral candidates to the `candidates` mapping.

Let's quickly go through as the function definition

- `function` is the keyword creating a function like Javascript.
- `addCandidate` is the name of the function.
- `address _addr`: `address` is the datatype of the argument and `_addr` is the name of the argument which is the address of the candidate.
- `string memory _name`: `string` is the datatype of the argument, `memory` is the data location of the argument and `_name` is the argument which is the name of 
the candidate
- `public` is the visibility modifier as I said previously 

Let's go through the logic inside the function

### `require(msg.sender == owner, "Only owner can call this function");`

`require` is an in-built function in solidity that can take two arguments; a condition that must be met and an error message that would be thrown if the condtion is
not met. This line checks that the person calling(`msg.sender`) the function `addCandidate` is same as the `owner` we defined above. That means, only the deployer can
call this function.

It throws an error and reverts with the message `Only owner can call this function` if the conditions are not met.

### `require(candidateInserted[_addr] == false, "Candidate can't be added");`

This checks that the candidate address in the `candidateInserted` mapping is `false`. That is, it checks that the candidate has not been added before. Else, it throws an error and reverts
the message `Candidate can't be added`.

### `candidateCount = candidateCount + 1;`

This value is incremented and used as the `id` in the `Candidate` struct in the next line. We want the `id` to start from `1` rather than `0` that's why we increment
it before using it for the first time.

Note that `candidateCount` is a state variable and it is stored in the `storage` of the smart contract so it persists throughout the lifetime of the smart contract.

### `candidates[_addr] = Candidate(candidateCount, _name);`

The `Candidate` struct with `id` as `candidateCount` and `name` as `_name` is added to the mapping `candidates` with the key as `_addr`

### `candidateInserted[_addr] = true;`

The value of `_addr`(address of the candidate) is updated to `true` so that it can't be added to the `mapping`of `candidates` for the second time.

## `function addVoter(address _addr, string memory _name) public{....}`

It's same as `function addCandidate(address _addr, string memory _name) public{....}` with a few modifications. I know you will figure it out.

## `function vote(address _candidateAddress) public{....}`

Let's go through the logic inside the smart contracts.

### `require(voterInserted[msg.sender] == true);`

Makes sure that the voter is in `mapping` of `voterInserted`. Else, it throws an error and reverts with an error message `You are not among the voters`

### `Voters storage voter = voters[msg.sender];`

Uses the `msg.sender` as key to get the value in the mapping `voters` in the `storage` which is a `struct` of the `Voters` type. And, then stores it in the variable 
`voter`

### `require(voter.voted == false, "You can't vote twice");`

Checks the value of `voted` in `voter` is `false` which means they haven't voted before. Else, it throws an error and reverts with an error message
`You can't vote twice`

### `votes[_candidateAddress] = votes[_candidateAddress] + 1;`

Increments the number of votes by 1 for the candidate that the `voter` just voted for.

### `voter.voted = true;`

Sets the value of `voted` in `voter` to `true` so they wouldn't vote for a second time.

