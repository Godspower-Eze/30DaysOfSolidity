# Project Overview

In `Day 10`, we saw an ERC20 Token. Today, we will be looking at how to swap between two ERC20 Tokens.

This is meant to be a simple way of swapping and not an ideal exchange mechanism.

Here's how it works:

`Eze` has `1000,000,000` of `Token1` and `Kelechi` has `1,000,000,000` of `Token2`. Without considering the value of these tokens in the market, they decide to exchange all of their tokens between themselves.

They both have to approve the address of the `Exchange` contract to spend `1,000,000,000` of their tokens using the `approve` function in the token contract.

After approval, the `Exchange` contract has the ability to move the `1,000,000,000` from both user's addresses.

After the swapping, Eze should have `1,000,000,000` of `Token2` and `Kelechi` should have `1,000,000,000` of `Token1`.

I will be using the names `Eze` and `Kelechi` throughout this guide.

Let's see how the contracts work.

# Exchange.sol

There are four contracts for this project; `Token1.sol`, `Token2.sol`, `IERC20.sol` and `Exchange.sol`.

I'll be explaining only the last because we have already talked about the others in `Day 10`. Check them out.

## `modifier onlyApproved( address token1, address token2, address ownerOfToken1, address ownerOfToken2, uint amountOfToken1, uint amountOfToken2){....}`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition. They can accept arguments.

It works similarly to how decorators work in programming languages like Python.

The modifier takes in the following arguments as shown above: contract address of `Token1`(`token1`), contract address of the `Token2`(`token2`), address of the `Eze`(`ownerOfToken1`), `address` of `Kelechi`(`ownerOfToken2`), amount `Eze` wants to send(`amountOfToken1`) and amount `Kelechi` wants to send(`amountOfToken2`).

### `require(IBasicERC20Token(token1).allowance(ownerOfToken1, address(this)) >= amountOfToken1, "This contract is not approved to spend this amount from token 1");`

Here, we used the interface `IBasicERC20Token`(`Day 9` and `Day 10`) to instantiate the contract (`IBasicERC20Token(token1)`) of the first token where `token1` is its contract address. 

Using the `allowance` function, it then checks whether the owner of token `ownerOfToken1` has approved the address of this contract `address(this)` to spend tokens equal or greater than the amount(`amountOfToken1`) that `Eze` wants to send.

If this condition passes, it runs next the statement. Otherwise, it reverts with an error message `"This contract is not approved to spend this amount from token 1"`.

Check `Day 10` to see more on how `allowance` function works.

### `require(IBasicERC20Token(token2).allowance(ownerOfToken2, address(this)) >= amountOfToken2,"This contract is not approved to spend this amount from token 2");`

 Similar the statement above, this statement used the interface `IBasicERC20Token` to instantiate the contract (`IBasicERC20Token(token2)`) of the second token where `token2` is its contract address. 

Using the `allowance` function, it then checks whether the owner of token `ownerOfToken2` has approved the address of this contract `address(this)` to spend tokens equal or greater than the amount that(`amountOfToken2`) `Kelechi` wants to send. And, If this condition passes, it runs the next statement. Otherwise, it reverts with an error message `"This contract is not approved to spend this amount from token 2"`.

### `_;`

This specifies that the function modified should be run.

## `function _safeTransferFrom( address tokenAddress, address sender, address recipient, uint amount) private {....}`

This function is a modification of the `transferFrom` function in token contract so that the sender is the `Exchange` contract not a normal user(`Externally Owned Account`).

### `private`

This is a visibility modifier that restricts this function from being called outside this contract; even inside of child contracts(Contracts inheriting from it) unlike `internal`.

From the beginning of this series we have talked about the four visibility modifier; `private` being the last. But, let's do a quick recap.

- `public`: Makes it possible for a function to be called both inside and outside the contract including child contracts.

    Also, when used in a variable it provides a getter function to get the value of that variable.

- `external`: Makes it possible for a function to be called both inside and outside the contract including child contracts.

    But, it is not advisiable to use this for functions that would be called inside the contract. Instead of calling the function directly, `this.someFunction()` would be used and it's not gas efficient.

- `internal`: Makes it possible for a function to be called only inside of a contract and its child contracts.

### `bool sent = IBasicERC20Token(tokenAddress).transferFrom(sender, recipient, amount);`

The `transferFrom` returns a boolean value so its saved in the `sent` boolean variable.

`IBasicERC20Token(tokenAddress)` like above instantiates an instance of the token contract where `tokenAddress` is the token contract address. Then, calls the `transferFrom` function with neccassary arguments making this `Exchange` contract the caller of this function.

### `require(sent, "Token transfer failed");`

This checks that the value of `sent` is true else it reverts and throws an error message `"Token transfer failed"`.

## `function swap (address token1, address token2, address ownerOfToken1, address ownerOfToken2, uint amountOfToken1, uint amountOfToken2) external onlyApproved(....) {....}}`

This uses the `_safeTransferFrom` defined above to perform the swap.

### `onlyApproved(....)`

The modifier explained above.

### `safeTransferFrom(token1, ownerOfToken1, ownerOfToken2, amountOfToken1);`

Transfers the tokens from `Eze` to `Kelechi`

### `_safeTransferFrom(token2, ownerOfToken2, ownerOfToken1, amountOfToken2);`

Transfers the tokens from `Kelechi` to `Eze`
