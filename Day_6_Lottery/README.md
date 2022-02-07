# Project Overview

This is a `Lottery` contract.

So, this is how it works basically; a group of people stake an amount of ether into the contract and a lucky random person out of them takes all the money.

This currently has some flaws that would be addressed in an `AdvancedLottery` contract later in this series. But, for now, let's go with this.

Take a look at the previous contracts for some prequisite knowledge.

## `address public owner;`

Here, we declare an `owner` variable of `address` type and visibility of `public`

## `address payable[] players;`

Here, we declare an empty array of `payable` addresses with the variable `players`.

A `payable` address is one that can receive ether.

## `uint public stakeAmount = 1 ether;`

This sets the least amount of ether that a user must send to the contract address before he/she can be added to the players and therefore eligible for the lottery.

Any amount less than the this will be returned back to the user.

Notice how the way we specified `1 ether`. We could also define it like so `1000000000000000000 wei`/`1e18 wei` or `1000000000 gwei`/`1e9 wei`.

They all represent 1 ether in different denominations. And, they can be defined like that because they are the main units of value on the blockchain among others.

## `uint ownerPercentage = 10;`

This sets the percentage the owner of this contract should get after a winner has been selected and paid.

## `modifier stakeIsEnough(){ require(msg.value >= stakeAmount, "Stake is not enough"); _;}`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition.

It works similarly to how decorators work in programming languages like python.

In this case, `require(msg.value >= stakeAmount, "Stake is not enough")` checks whether the `msg.value` which is the amount of ether sent to the contract is equal to or more than the `stakeAmount` set above. If it passes, `_;` signifies that it should go ahead and run the function
it is modifying else it would throw an error and revert with message `Stake is not enough`. We'll see it in practice below.

I trust you would be able to figure out what the remaining four `modifiers` does. You can do it.

## `receive() external payable stakeIsEnough adminsCantPlay{ players.push(payable(msg.sender));}`

### `receive()`

An in-built function that handles the recieving of ether into a contract.

`fallback()` is another in-built function that does the same thing with little modifications. This is used when data is being passed while sending ether into the contract. We'll see this in practice later in this series.

### `external`

A visibility modifier that allows for a function to only be accessed outside the smart contract. Well, not exactly.

A function defined with the `external` keyword can be called inside the contract using `this.functionName` but it's consumes more gas so it's not adviced.

### `payable`

Makes it possible for a function to recieve ether.

### `stakeIsEnough`

As explained above, this `modifier` checks that the ether sent to the transaction is more than or equal to the `stakaAmount`. If it passes, it goes on to the next modifier, else it throws an error and reverts the transaction thereby returning the ether sent.

### `adminsCantPlay`

This checks that the owner of the contract isn't trying to play the lottery by sending in ether.

### `players.push(payable(msg.sender));`

If all the modifiers above passes, it goes on to make the address `payable` and adds it to the `players` array making them eligible to participate in the lottery round.

## `function getPlayers() external view returns(address payable[] memory){ return players; }`

This returns the `players`.

### `view`

This signifies that the function doesn't change any `state variables` which are variables stored in `storage` or outside the function

### `returns(address payable[] memory)`

This signifies that the function must return an array of `payable` addresses as output.

## `function getBalance() external view returns(uint){ return address(this).balance; }`

This returns the total ether in the contract.

### `address(this).balance`

Gives the `balance` of the contract.

## `function generateRandomNumber() internal view returns(uint){ return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length))) % players.length; }`

This function generates a random number within the values of `0` and `players.length - 1`.

### `internal`

This signifies that the function must only be called inside the contract or inside a contract calling this contract(the child of the contract).

### `return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length))) % players.length;`

This returns an `unsigned integer` amongst `0` and `players.length - 1`.

#### `block.difficulty`

This returns an `unsigned integer` which is the `block difficulty` of the current block.

The difficulty of a block is the measure of how difficult it is to mine a block.

Due to the fact that this number is a dynamic value, It helps to increase the randomness of the value generated.

#### `block.timestamp`

This returns an `unsigned integer` which is the `block timestamp` of the current block. Basically, time as seconds since unix epoch

Due to the fact that this number is a dynamic value, It helps to increase the randomness of the value generated.

#### `players.length`

The length of the `players` array.

#### `abi.encodePacked(block.difficulty, block.timestamp, players.length)`

This encodes the values of `block.difficulty`, `block.timestamp` and `players.length` into bytes because `keccak256` only accepts bytes.

#### `keccak256(...)`

This hashes the value of `abi.encodePacked(block.difficulty, block.timestamp, players.length)` into a `bytes32` hex value.

#### `uint(keccak256(...))`

This casts the hash generated by `keccak256(...)` into an `unsigned integer`.

#### `uint(keccak256(...)) % players.length`

The value of `uint(keccak256(...))` could either be `0` or a very large number so we perform a `modulo` operation on the value of `uint(keccak256(...))` to make sure the value is amongst `0` and `players.length - 1`.

Follow this [link](https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/what-is-modular-arithmetic) to read more about the `modulo` operator.

## `function pickWinner() external onlyOwner upToTenPlayers{....}`

Picks a winner, sends `90%`(leaves `10%` out of the total ether in the contract for the `owner`) of the total ether in the contract and empties the `players` array.

### `onlyOwner`

This `modifier` makes sure that only the `owner` can call the function.

### `upToTenPlayers`

This `modifier` makes sure the number of addresses in the `players` array is up to `10`.

### `address payable winner;`

Declares a variable of `payable address` type as `winner`.

### `uint amountSendable = address(this).balance - (address(this).balance/ownerPercentage);`

Calculates the amount that would be sent to the winner by subtracting the owner's share(`ownerPercentage`). Then, stores it in the variable `amountSendable`.

### `winner = players[generateRandomNumber()];`

Uses the random value from `generateRandomNumber()` to get an address out of the `players` array and assigns it to the `winner` variable.

### `winner.transfer(amountSendable);`

Sends out the `amountSendable` to the winner.

### `players = new address payable[](0);`

Empties the `players` array to prepare for another round.

## `function withdraw() external onlyOwner playersLengthMustBeZero { payable(owner).transfer(address(this).balance); }`

After every round, the `owner` of the contract must withdraw his/her share of that round.

### `playersLengthMustBeZero`

This `modifier` makes sure that the length of the `players` array is `0`. That is, the `winner` must have received their winning and the `players` array emptied before the `owner` can withdraw to make sure that the `owner` doesn't withdraw the winner's money.

### `payable(owner).transfer(address(this).balance);`

Casts the `owner` into a `payable` address and sends his/her share of the lottery round.