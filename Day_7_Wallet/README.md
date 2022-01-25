# Project Overview

This is a `Wallet` contract. A wallet where you can store, send and withdraw ether.

Take a look at the previous contracts for some prequisite knowledge.

## `mapping(address => uint) public balances;`

A `mapping` is like a hash-table or dictionary that stores data in a key-value pair format. In this case, the type of the key would an `address` type and the value would be an `unsigned integer`.

This maps an address to its balance and stores it in the variable `balances`.

## `event Withdraw(address receiver, uint amount);`

An event is used for logging in the smart contract. These logs are stored on blockchain and are accessible using address of the contract. An event generated is not accessible from within contracts, not even the one which have created and emitted them.

This event emits the `receiver's address` and the `amount` when a withdrawal occurs.

## `event Sent(address sender, address receiver, uint amount);`

This event emits the `sender's address`, `receiver's address` and the `amount` sent by a user.

## `bool locked;`

This declares a variable `locked` as a `boolean`.

This value would be used in `noReentrant` modifier below.

## `modifier noReentrant() { require(!locked, "No re-entrancy"); locked = true; _; locked = false; }`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition.

It works similarly to how decorators works in programming languages like python.

This modifier prevents reentrancy attack on a contract. 

I will be explaining the reentrancy attack on `Day 8` of this series but let's look at it from high level for now.

### `require(!locked, "No re-entrancy");`

In solidity, when a variable is declared it takes the default value of that data type.

So, in this case, `locked` takes a false by default.

This checks that the value of `locked` is false. That is, it checks that a function is not locked. Else, it throws an error and reverts with an error message `No re-entrancy`.

### `locked = true;`

Set's `locked` to `true`. That is, lock the function to prevent re-entrancy.

### `_;`

Runs the function.

### `locked = false;`

Set's the `locked` to false. That is, unlocking the function.

## `receive() external payable{ balances[msg.sender] += msg.value; }`

Handles the recieving of `ether` sent into a contract.

In this case, it saves the address of the sender(`msg.sender`) and the amount of ether sent(`msg.value`) to the `balances` mapping.

Notice how we used `+= msg.value` instead of `= msg.value`. This is because a user could send ether multiple times so we add up the ether balances not overwrite the former balance.

Also, by default the value of an `unsigned integer` is `0` so even though a user is sending money into the contract for the first time, it already has a value of `0`.

## `function withdraw(uint amount) external noReentrant{....}`

This function allow users withdraw their ether.

### `noReentrant`

The `modifier` specified above.

### `uint balance = balances[msg.sender];`

This gets the balance of the user calling the function from the `balances` mapping using the address of the sender(`msg.sender`) and stores it in th `balance` variable.

### `require(amount <= balance, "You don't have enough ether in your balance");`

Checks that the `amount` wanting to be withdrawn is less than or equal to the user's `balance`.

### `(bool sent, ) = payable(msg.sender).call{value: amount}("");`

This tries to send the ether from the contract to the user address.

`call` is similar to the `transfer` but it returns a boolean value(`sent`) and a bytes32 value.

Here `(bool sent, )`, we left the other side of the comma empty because there is no use for the value. Else, it would have been like so `(bool sent, bytes32 memory data)`.

### `require(sent, "Failed to send Ether");`

Depending on the value of `sent`, this line of code throws an error and revert or not.

### `emit Withdraw(msg.sender, amount);`

Emits the withdraw event.

## `function send(address payable receiver, uint amount) external{....}`

This functions sends ether from one address to another

### `uint balance = balances[msg.sender];`

This gets the balance of the user calling the function from the `balances` mapping using the address of the sender(`msg.sender`) and stores it in th `balance` variable.

### `require(amount <= balance, "You don't have enough ether in your balance");`

Checks that the `amount` wanting to be sent is less than or equal to the user's `balance`.

### `balance -= amount;`

Deducts the `amount` sent from the sender's balance.

### `balances[receiver] += amount;`

Adds the `amount` sent from the receiver's balance

### `emit Sent(msg.sender, receiver, amount);`

Emits the `Sent` event.

## `function getBalance() external view returns(uint){ return address(this).balance;}`

`address(this)` is the address of the smart contract and `balance` is an attribute of every address which is the amount of ether the address contains.

Returns the ether balance of the smart contract in `wei`.

`wei` is the smallest unit of `ether`. `1 ether = 1000000000000000000 wei`

