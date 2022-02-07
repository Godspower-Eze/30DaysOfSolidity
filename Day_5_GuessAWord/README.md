# Project Overview

This is a `GuessAWord` contract which is simple contract that allows users to guess words set the owner of a contract.

Take a look at the previous contracts for some prequisite knowledge.

## `address public owner;`

Here, we declare an `owner` variable of `address` type and visibility of `public`

## `bytes32 public correctWord = 0x3bf63e344ceb27303a6c41784b087cf05d1fea6f2cfa8e1d0a79dfb54a98c671`

Here, we declared a `correctWord` variable as `public` with the `bytes32` datatype.

`bytes32` is a data type in solidity that stores values of 32 bytes size and below. It stores values in hexadecimal.

## `constructor(){owner = msg.sender;}`

### `constructor(){....}`

A constructor in Object Oriented Programming is a function that is run when an object is initialized. That is, when an instance of that object is created.
In this case, the constructor is executed when a contract is deployed. 

That means, any code inside the constructor is run when the contract is deployed. Let's see what's inside the constructor

### `owner = msg.sender;`

The `owner` variable that was declared above is assigned the value `msg.sender`.

`msg` is an object with a number of attributes in every smart contract and `sender` is one them. `msg.sender` returns the address of the caller of a smart contract.
In the case of `constructor`, the deployer is the caller so the `owner` is set to the address of the user that deployed the smart contract.

## `modifier onlyOwner(){require(owner == msg.sender, "You are not the owner"); _;}`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition.

It works similarly to how decorators work in programming languages like python.

In this case, `require(owner == msg.sender, "You are not the owner")` checks whether the `owner` is same as the `msg.sender`(address of the user that would be calling the function that it would be `modifying`). If it passes, `_;` signifies that it should go ahead and run the function it is modifying. We'll see it in practice below.

## `function setWord(string memory word) external onlyOwner{ correctWord = keccak256(abi.encodePacked(word));}`

Check previous guide to see how functions work.

This function sets the correct word by allowing the `owner` pass a new word.

### `external`

Allows the function to only be called from outside the contract.

### `onlyOwner`

This is a modifier that makes sure that only the owner of this contract is able to call it.

### `correctWord = keccak256(abi.encodePacked(word))`

`abi.encodePacked(word)` converts the word passed to the function to `bytes32` because `keccak256` takes only bytes values as input. Then, `keccak256` as a hashing fuction hashes the value of `abi.encodePacked(word)` using `keccak256`.

A hashing function is a one-way function. That is, it hashes a value into another value. But, it cannot get the initial value using the new value.

It's also deterministic in nature. That is, the `keccak256` hash of a given value is always the same.

Check out [this website](https://emn178.github.io/online-tools/keccak_256.html) to see more on how hashing functions.

## `function guess(string memory word) external view returns (bool){return keccak256(abi.encodePacked(word)) == correctWord;}`

Here, players try to guess the correct word.

### `view`

States that the function does not modify any state variables.

`state variables` are variables stored in the contract `storage`.

### `returns (bool)`

Signifies that the function would return a `boolean` value

### `return keccak256(abi.encodePacked(word)) == correctWord;`

Compares the `keccak256` hash of the `word` passed by the player to the hash of the `correctWord` and returns `true` or `false`