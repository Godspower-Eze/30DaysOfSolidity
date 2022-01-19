# Project Overview

This is a `piggybank`contract also known as a `saving box`.

In real life, a `saving box` is structured in a way that anyone could slide money into it but only the owner has the right to break it open and collect the money
inside of it. That's how our contract works.

Take a look at the previous contracts for some prequisite knowledge.

## `address public owner;`

Here, we declare an `owner` variable of `address` type of visibility `public`

## `constructor(){owner = msg.sender;}`

### `constructor(){....}`

A constructor in Object Oriented Programming is a function that is run when an object is initialized. That is, when an instance of that object is created.
In this case, the constructor is executed when a contract is deployed. 

That means, any code inside the constructor is run when the contract is deployed. Let's see what's inside the constructor

### `owner = msg.sender;`

The `owner` variable that was declared above is assigned the value `msg.sender`.

`msg` is an object with a number of attributes in every smart contract and `sender` is one them. `msg.sender` returns the address of the caller of a smart contract.
In the case of `constructor`, the deployer is the caller so the `owner` is set to the address of the user that deployed the smart contract.

## `event Deposit(uint amount);`

An event used for logging in the smart contract. These logs are stored on blockchain and are accessible using address of the contract. An event generated is not
accessible from within contracts, not even the one which have created and emitted them.

This event emits the `amount` of ether that is deposited into a smart contract.

## `event Withdraw(uint amount);`

This event emits the `amount` of ether that is withdrawn from the smart contract.

## `receive() external payable{ emit Deposit(msg.value); }`

### `receive()`

An in-built function that handles the recieving of ether into a contract.

`fallback()` is another in-built function that does the same thing with little modifications. We'll talk more on this later in this series.

### `external`

A visibility modifier that allows for a function to only be accessed outside the smart contract. Well, not exactly but see it in this way for now.

### `payable`

Makes it possible for a function to recieve ether.

### `emit Deposit(msg.value);`

emits the amount of ether that was deposited into the smart contract. `msg.value` is the amount of ether that was sent into the smart contract in that transaction

## `function getBalance() external view returns(uint){....}`

Returns the total balance of ether in a smart contract

### `view`

Specifies that the function doesn't modify the state variables.

### `returns(uint)`

Specifies that the function return value must be of `unsigned integer` type

### `uint balance;`

Declared the variable `balance` with `unsigned integer` type

### `balance = address(this).balance;`

Assigns the total number of ether to `balance`

### `return balance;`

Returns the `balance`

## `function withdraw() external {....}`

### `require(owner == msg.sender, "Only owner can call this function");`

Checks that the person calling the function `msg.sender` is same as the `owner` of the contract. Else, it throws an error with the message
`Only owner can call this function`

### `emit Withdraw(address(this).balance);`

If the first line passes, it emits the total ether in the contract that's about to be withdrawn.

### `selfdestruct(payable(msg.sender));`

This function sends the total ether in the contract to the owner(`msg.sender`) and destroys the contract. `payable` in `payable(msg.sender)` makes it possibe for 
the owner address to be able to receive ether.
