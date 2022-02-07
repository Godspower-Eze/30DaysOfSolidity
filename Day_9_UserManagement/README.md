# Project Overview

We are doing something a bit different today, A `Conceptual User Management System for a Custodial Wallet`.

This basically means, we are building smart contracts that manages user information in a custodial wallet software. Check out [this thread](https://twitter.com/The_python_dev_/status/1448667228283580417) for what a custodial and non-custodial wallet is.

Today, we'll be seeing how to `import` smart contracts, how deploy smart contracts from inside another smart contract called a `Factory` contract, and how to `call` other contracts in yours using `interfaces`.

We'll be working with three files `User.sol`, `IUser.sol` and `UserManager.sol`(the `Factory` contract).

Let's go through each of them respectively.

# `User.sol`

In this system, every user who registers on the custodian wallet platform has a smart contract. So, every `User` smart contract deployed has informations about a single user.

Let's go through the code.

## `address public owner;`

Here, we declare an `owner` variable of `address` type and visibility of `public`.

In our previous smart contracts, the owner of our smart contract has always been an EOA(Externally Owned Account) but in this case, the deployer is a CA(Contract Account) because the `UserManager` will be deploying the `User` contract. We'll see it later in this guide.

EOAs and CAs are two types of accounts on Ethereum and other similar chains like Binance Smart Chain(BSC).

EOAs have users like you and I while CAs are smart contracts deployed.

## `address public userAddress;`

Here, we declare an `userAddress` variable of `address` type and visibility of `public`.

This variable stores the address of this particular `User` smart contract.

## `uint public id;`

Here, we declare an `id` variable of `uint` type and visibility of `public`.

This stores the `id` of this user.

## `string public name;`

Here, we declare an `name` variable of `string` type and visibility of `public`.

This stores the name of this user.

## `uint public age;`

Here, we declare an `age` variable of `unsigned integer` type and visibility of `public`.

This stores the `age` of this user.

## `string public location;`

Here, we declare an `location` variable of `string` type and visibility of `public`.

This stores the location of this user.

## `mapping(string => uint) public tokenBalances;`

A `mapping` is like a hash-table or dictionary that stores data in a key-value pair format. In this case, the type of the key would be a `string` and the value would be an `unsigned integer`.

This maps the symbol of a token to the amount of that token owned by that user and stores it in the variable `tokenBalances`.

## `mapping(string => bool) public tokenAdded;`

This maps the symbol of a token added to `tokenBalances` to a boolean value and stores it in the variable `tokenAdded`.

This helps in checking that a token symbol has already been added to the `tokenBalances` mapping or not.

## `constructor(uint _id, string memory _name, uint _age, string memory _location){...}`

A constructor in Object Oriented Programming is a function that is run when an object is initialized. That is, when an instance of that object is created.

In this case, the constructor is executed when a contract is deployed.

That means, any code inside the constructor is run when the contract is deployed. Let's see what's inside the constructor.

### `owner = msg.sender;`

The `owner` variable is set to the deployer of the contract which in this case, it is the `UserManager` contract.

The lines that follows: `id = _id;`, `name = _name;`, `age = _age;` and `location = _location;` are doing the same as `owner = msg.sender;`; setting the variables declared above.

### `tokenBalances["ETH"] = 0;`

Adds the token symbol of Ether: `ETH` as the key and `0` as the balance in the `tokenBalances` mapping.

### `tokenAdded["ETH"] = true;`

Adds the token symbol of Ether: `ETH` as the key and `true` as the balance in the `tokenAdded` mapping to ensure that it's not added again.

### `tokenBalances["BTC"] = 0;`

Adds the token symbol of Bitcoin: `BTC` as the key and `0` as the balance in the `tokenBalances` mapping.

### `tokenAdded["BTC"] = true;`

Adds the token symbol of Bitcoin:`BTC` as the key and `true` as the balance in the `tokenAdded` mapping to ensure that it's not added again.

### `tokenBalances["USDT"] = 0;`

Adds the token symbol of Tether: `USDT` as the key and `0` as the balance in the `tokenBalances` mapping.

### `tokenAdded["USDT"] = true;`

Adds the token symbol of Tether: `USDT` as the key and `true` as the balance in the `tokenAdded` mapping to ensure that it's not added again.

## `modifier onlyOwner(){ require(msg.sender == owner, "Only owner can call this function"); _;}`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition.

It works similarly to how decorators work in programming languages like Python.

In this case, `require(msg.sender == owner, "Only owner can call this function")` checks whether the caller of a function(`msg.sender`) is equal to the `owner` set above. If it passes, `_;` signifies that it should go ahead and run the function it is modifying else it would throw an error and revert with the message `Only owner can call this function`. We'll see it in practice below.

## `modifier tokenAddedAlready(string memory _tokenName){ require(!tokenAdded[_tokenName], "Token already been added"); _;}`

Here, the modifier takes in a string `_tokenName` as an argument and checks that it has not been added to the `tokenAdded` mapping by checking that the value of `tokenAdded[_tokenName]` is false else it reverts and throws the error message `Token already been added`.

## `modifier tokenNotAdded(string memory _tokenName){ require(tokenAdded[_tokenName], "Token has not been added"); _; }`

Here, the modifier takes in a string `_tokenName` as an argument and checks that it has been added to the `tokenAdded` mapping by checking that the value of `tokenAdded[_tokenName]` is true else it reverts and throws the error message `Token has not been added`.

## `function updateName(string memory _newName) external onlyOwner{ name = _newName; }`

### `external`

This is a visibility modifier that ensures that this function can only we called outside the contract.

The statement above is not entirely correct because we could call this function inside this contract using the `this` keyword but it's expensive to do so. Better still use the `public` keyword instead if you want to be able to call the function both outside and inside the contract.

### `onlyOwner`

A `modifier`. Check above for what it does.

### `name = _newName;`

Sets the `name` to `_newName` passed to the function.

`updateAge` and `updateLocation` below works in the same way.

## `function addToken(string memory _tokenName, uint balance) external onlyOwner tokenAddedAlready(_tokenName){...}`

This function adds a new to the token a user has.

### `tokenAddedAlready(_tokenName)`

A `modifier`. Check above for what it does.

### `tokenBalances[_tokenName] = balance;`

Adds the new token symbol with its balance to the `tokenBalances` mapping.

### `tokenAdded[_tokenName] = true;`

Adds the token symbol that was just added to the `tokenBalances` mapping as key in `tokenAdded` and sets its value to `true` so that it can't be added to the `tokenBalances`

## `function updateTokenBalance(string memory _tokenName, uint _amount) external onlyOwner tokenNotAdded(_tokenName) {tokenBalances[_tokenName] += _balance; }`

This function updates the balance of a user's token.

### `tokenNotAdded`

A `modifier`. It makes sure that token symbol(`_tokenName`) passed in is existing in the `tokenBalances` mapping. Check above for more explanation.

### `tokenBalances[_tokenName] += _amount;`

This gets the token using the token symbol(`_tokenName`) as key and increments the existing token balance by the amount passed as argument(`_amount`).

# `IUser.sol`

This is not a smart contract rather it's an `interface`.

Interfaces are not unique to Solidity rather it's a general programming concept.

In Solidity, interfaces are used as a blueprint for another contract to follow or used similarly to an intermediary or an APT between two smart contracts i.e used as a way for a smart contract to call another.

In this example, we use it as the latter. Later in this series, we'll see it used as a blueprint.

Here are some rules for defining an interface

- They only define functions but they don't implement any logic inside of them. You will see it below.

- Functions in interfaces must be declared with the visibility modifier; `external`.

- Variables cannot be declared in interfaces

- Apart from functions, only `enums` and `structs` can be defined inside of interfaces.

Moving on, let's see how it works in our case.

Here, it serves as an intermediary between the `User` and the `UserManager` contract; helping the `UserManager` contract to talk to the `User` contract.

So, it defines the function for the `User` contract.

Assuming you have already noticed how an interface is created, let's go through the code.

## `function id() external view returns(uint);`

Earlier in this series, we stated that when a variable is declared with the `public` visibility modifier, Solidity provides a getter function that would be used in getting the value of that variable.

For example, if we declare and assign a value to a variable like so:

`string name = "Godspower"`

We will get a getter function `name()` that returns `"Godspower"`.

In this case, this line: `function id() external view returns(uint);` is an interface for the variable `id` declared like so:

`uint public id;`

Breaking it down

### `external`

This is the only visibility modifier allowed in an interface and it must be used just as stated in the rules.

### `view`

This declares that the function we are interfacing doesn't change any state variables.

### `returns(uint)`

This declares that the function we are interfacing returns an `unsigned integer` as output.

The next three functions: `name()`, `age()` and `location()` works in the same as `id()`.

## `function tokenBalances(string memory) external view returns(uint);`

This is an interface for the mapping `tokenBalances`.

When we declared `tokenBalances` as `public` in the `User` contract, this is what the getter function that Solidity provides for us looks like:

`function tokenBalances(string symbol) public view returns(uint){return tokenBalances[symbol];}`

So, this is what we are interfacing.

`tokenAdded` works the same way as `tokenBalances`

## `function updateName(string memory _newName) external;`

This interfaces the `updateName` function. See how we went as far as defining the argument name(`_newName`) that the function would recieve. That's not really necessary but it's possible.

`updateAge`, `updateLocation`, `addToken`, and `updateTokenBalance` works in the same way as `updateName`.

# `UserManager.sol`

## `import "./User.sol";`

Imports the `User` contract into the `UserManager` contract.

## `import "./IUser.sol";`

Imports the `IUser` interface into the `UserManager` contract.

## `address public owner;`

Here, we declare an `owner` variable of `address` type and visibility of `public`.

## `uint public contractCount = 0;`

Keeps track of the number of `User` contracts managed by this contract.

## `address[] public contractsAddresses;`

This is a dynamic array of contract addresses.

## `constructor(){ owner = msg.sender;}`

Sets the `owner` variable to the address that deployed the contract(`msg.sender`).

## `modifier onlyOwner(){ require(msg.sender == owner, "Only owner can call this function"); _;}`

Check the `User` contract above.

## `function create(string memory _name, uint _age, string memory _location) external onlyOwner{....}`

This function spawns/creates a new contract.

This function is the reason why the `UserManager` contract is called a `Factory` contract because a `Factory` contract creates new contracts.

### `contractCount += 1;`

Increments the `contractCount` by 1.

### `User user = new User(contractCount, _name, _age, _location);`

Creates a new `User` contract passing in the neccessay arguments that should be passed into the constructor(`contractCount`, `_name`, `_age`, and `_location`) and then stores it in the `user` variable.

The `User` keyword before `user` declares that `user` is a datatype of the `User` contract.

### `contractsAddresses.push(address(user));`

Adds the address of the new contract created to the `contractsAddresses` array.

`address(user)` returns the address of the contract.

## `function updateName(uint _index, string memory _newName) external onlyOwner {....}`

This function updates the name of a user inside a particular `User` contract.

### `address contractAddress = contractsAddresses[_index];`

Uses the index(`_index`) passed into the function to get the contract address from `contractAddress` array and stores it in the `contractAddress` variable.

### `IUser(contractAddress).updateName(_newName);`

Uses the contract address(`contractAddress`) assigned above to call the `updateName` function inside the `User` contract.

As shown above, to call a contract using an interface, pass the contract address as an argument to the interface then dot(`.`) the function you want to call while passing the necessary arguments where necessary.

`updateAge`, `updateLocation`, `addToken`, `updateTokenBalance`, `getId`, `getName`, `getAge`, `getLocation`, `tokenAvailable`, and `tokenBalance` all works in the same way as `updateName`.

## `function getContracts() external view returns(address[] memory){ return contractsAddresses;}`

This function returns the array of contract addresses: `contractsAddresses`.

