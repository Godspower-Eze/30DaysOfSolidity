# Project Overview

This is a `Crowdfunding` contract. This is a contract that allows individuals to support a cause by donating funds. Just like `Go FundMe`.

Here's how it works:

A user joins the platform, creates a fundraiser, individuals can donate to the cause and then, when the target is reached or passed, the creator of the fundraiser can then be redeemed.

Take a look at the previous contracts for some prequisite knowledge.

## `address public owner;`

Here, we declare an `owner` variable of `address` type of visibility `public`

## `mapping(address => uint) public users;`

A `mapping` is like a hash-table or dictionary that stores data in a key-value pair format. In this case, the type of the key would an `address` type and the value would be an `unsigned integer`.

This maps an address of a user to an id and stores it in the variable `users`.

## `mapping(address => bool) public userAdded;`

This maps an address of a user to a boolean value and stores it in the variable `userAdded`.

This helps in checking that a user exists.

## `uint userCount = 0;`

Declares and assigns the value of `userCount` to 0 and it is used to keep track of the number of `users` in the contract.

## `event UserAdded( address user );`

An event is used for logging in the smart contract. These logs are stored on blockchain and are accessible using address of the contract. An event generated is not accessible from within contracts, not even the one which have created and emitted them.

This event emits the `user's address` when a user is added.

## `mapping(address => uint) public donations;`

This maps an address of a donor to a amount that has been donated by that donor and stores it in the variable `donations`.

This helps to keep track how much a donor has donated.
