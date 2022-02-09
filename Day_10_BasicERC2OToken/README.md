# Project Overview

If you have been following this series for a while, I would guess you have been anticipating me building a `Token`. Well, now you have one.

Today, we'll be building an `Basic ERC20 Token`. A fungible token.

Let's get some basics.

`ERC` stands for `Ethereum Request for Comment` and `20` is the identifier.

It's a standard that defines how a fungible token should be built for easy integration and compatibility accross multiple platforms. Read more on it [here](https://eips.ethereum.org/EIPS/eip-20)

There are a set of `functions` and `events` a smart contract must contain before it is eligible to be called an `ERC20 Token`. The `IBasicERC20Token` interface in the `IERC20Token.sol` file defines these functions and events.

In `Day 9`, we talked extensively about how interfaces can be used as a blueprint for another contract to follow or used similarly to an intermediary or an API between two smart contracts i.e used as a way for a smart contract to call another. There, it was used as an API, but here it would be used a blueprint so we let's go through it before going through the contract that would implement it.

Also, we stated that `interfaces` do not implement functions(define the logic of the function) rather they define how the function should look.

Check `Day 9` for more on interfaces.

Let's look at it.

# `IBasicERC20Token`

`name()`, `symbol()` and `decimals()` are optional based on the standard but for the purpose of this guide, we defined it.

## `function name() external view returns(string memory);`

This is the name of the token. For example, `Shiba Inu`, `Uniswap` and `Axie Infinity Shard`.

## `function symbol() external view returns(string memory);`

This is the symbol of the token which is usually from two letter words up to four letter words. For example, `SHIB`, `UNI` and `AXS`.

## `function decimals() external view returns(uint8);`

Solidity does not support decimal numbers so for tokens be able to be represented as decimals, the `decimals` variable is introduced.

Most ERC20 Tokens use `18` making it possible for tokens be represented to up to 18 decimal places(`0.000000000000000001`).

If an ERC20 Token has a decimal of `18` and a total supply of 1 Billion(`1,000,000,000`) then while passing in the total supply to the contract we use: `1,000,000,000 * (10 ** 18)`and we do the reverse(`1,000,000,000 / (10 ** 18)`) while trying to display a user balance in a wallet. So, this is just for display purposes and doesn't affect the smart contract.

Read more about it [here](https://docs.openzeppelin.com/contracts/3.x/erc20#a-note-on-decimals).

## `function totalSupply() external view returns (uint256);`

This function returns total amount of this token in existence.

## `function balanceOf(address account) external view returns (uint256);`

Takes in an address(`account`) and returns the amount of token owned by this address.

## `function allowance(address owner, address spender) external view returns (uint256);`

On special occassions, a token holder would have to `approve` another address to spend some of tokens their tokens on their behalf.

The best example of this scenario is when trying to perform a swap on a `Decentralized Exchange(DEX)` like `Uniswap` and `PancakeSwap`. You have to `approve` that they are able to `spend` the amount of token you would want to swap.

This `allowance` function basically allows us to check the amount of token that the `owner` has approved the `spender` to spend on their behalf.

As the `spender` uses this allowance, it reduces until the amount allowed is `0`.

## `function transfer(address recipient, uint256 amount) external returns (bool);`

This is a function that allows for the sending of tokens from one address to another.

Returns a boolean value of `true` if successful.

## `function approve(address spender, uint256 amount) external returns (bool);`

This is the function responsible for approving that an address(`spender`) should be able a spend a certain amount(`amount`) of your token as explained in the `allowance` function above.

Returns a boolean value of `true` if successful.

## `function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);`

Unlike the `transfer` above, `transferFrom` is used by a `spender` who has been approved by an `owner`.

The `sender` is the owner of the token, `recipient` is the reciever and `amount` is the amount of token that the `spender` wants to send out of the owner's balance.

Note that for this to run, the `amount` has to be less than or equal to the `amount` the `owner` has approved for the `spender` to spend.

## `event Transfer(address indexed from, address indexed to, uint256 value);`

This is an `event` emitted when a transfer occurs either using the `transfer` function or the `transferFrom` function.

We have been talking about events from the beginning of this series but we haven't looked at events using the `indexed` keyword.

The `indexed` keyword helps for easily filtering through events. Using the `indexed` keyword, it is possibe to get all event with a `from` value of `0x36FDE....`. You can have up to three `indexed` elements in a single event.

# `BasicERC20Token`

Notice something different about how this contract was defined.

We used `contract BasicERC20Token is IBasicERC20Token{...}`. Why is that?

Remember we talked about how interfaces could be used as a blueprint and we also explained the function blueprints above.

To use an `interface` as a blueprint, the `is` keyword is used. And, this is the same keyword used when inheriting from another contract but we'll see that later in this series.

The `is` keyword allows us to use the `functions` and `events` in the `IBasicERC20Token` interface.

Let's go through the code.

## `string public override name = "BasicERC20Token";`

This sets the name of the token to `"BasicERC20Token"`

The only new thing here is the `override` keyword.

For you to use a function blueprint from an interface, you would need to `override` it. That's why we used it here.

We are overriding the `name()` function defined in the `interface`.

You may be wondering why `name()` was defined as a function in the interface and here it is defined as a variable.

This is because when you declare a variable as `public`, Solidity provides you with a getter function that would be called from outside the contract to get the value of that variable. So therefore, the `name()` function defined in the interface is the same as the variable here declared as `public`.

## `string public override symbol = "BE2T";`

Overrides the `symbol` function defined in the interface and sets it to `BE2T`.

## `uint8 public override decimals = 18;`

Overrides the `decimals` function defined in the interface and sets it to `18`.

## `mapping(address => uint256) balances;`

A `mapping` is like a hash-table or dictionary that stores data in a key-value pair format. In this case, the type of the key would be a `address` and the value would be an `unsigned integer(uint)`.

This is a mapping that maps `addresses` to their `balance`. It stores the balances of different addresses.

## `mapping(address => mapping (address => uint256)) allowed;`

This is a `mapping` of `mappings`. Yeah, it's possible.

Here, an `address` maps to another mapping with an `address` mapped to an `unsigned integer(uint)` value.

This stores the amount of token that a user has approved for another address to spend by the `spender`.

## `uint256 totalSupply_;`

Declares a variable to store the total supply with a slightly different name from the `totalSupply` function declared in the `interface` so that it doesn't clash.

## `constructor(uint256 total) { totalSupply_ = total;balances[msg.sender] = totalSupply_; }`

A constructor in Object Oriented Programming is a function that is run when an object is initialized. That is, when an instance of that object is created.

In this case, the constructor is executed when a contract is deployed.

That means, any code inside the constructor is run when the contract is deployed. Note that this constructor takes an argument(`total`) so you need you pass it on deployment.

The value of `total` is the total supply of the token. Remember you need to pass it in multiple of `10 ** decimals`.

So, if you wanted to have a total supply of `1 Billion` and a `decimals` value of `18`. Then, you would pass in `1 Billion * (10 ** 18)` just like it's explained above.

### `totalSupply_ = total;`

Set the `totalSupply_` declared above to the `total` passed.

### `balances[msg.sender] = totalSupply_;`

This allocates the total supply of this token to the deployer of this contract.

Therefore, for every ERC20 token, at the time of deployment all the token in existence is owned by a single address(`deployer address`).

## `function totalSupply() public override view returns (uint256) { return totalSupply_; }`

Overrides(`override`) and implements the `totalSupply` function defined in the interface while returning an actual value(the `totalSupply_` set above in the constructor).

## `function balanceOf(address tokenOwner) public override view returns (uint256) { return balances[tokenOwner]; }`

Overrides(`override`) and implements the `balanceOf` function defined in the interface.

## `function transfer(address receiver, uint256 amount) public override returns (bool) {....}`

Overrides(`override`) and implements the `transfer` function defined in the interface.

Let's go through it line by line.

### `require(amount <= balances[msg.sender], "You don't have enough balance");`

This checks that the balance of the user(`balances[msg.sender]`) is greater than or equal to the `amount` that wants to be sent.

If it is not, it reverts with an error message `"You don't have enough balance"`. Else, it goes to the next line.

### `balances[msg.sender] -= amount;`

Deducts the `amount` being sent from the sender's(`balances[msg.sender]`) balance.

### `balances[receiver] += amount;`

Adds the `amount` being sent to the reciever's(`balances[receiver]`) balance.

### `emit Transfer(msg.sender, receiver, amount);`

Emits the `Transfer` event with the sender address(`msg.sender`), receiver address(`receiver`) and amount sent(`amount`).

This event was gotten from the `IBasicERC20Token` interface.

## `function approve(address delegate, uint256 amount) public override returns (bool) {....}`

Overrides(`override`) and implements the `approve` function defined in the interface.

### `require(amount <= balances[msg.sender], "You don't have enough balance");`

This checks that the balance of the user(`balances[msg.sender]`) is greater than or equal to the `amount` that wants to be approved.

If it is not, it reverts with an error message `"You don't have enough balance"`. Else, it goes to the next line.

### `allowed[msg.sender][delegate] = amount;`

This sets the caller of the function(`msg.sender`) who is the owner of a certain amount of token as the key and then, mapping it to the mapping with spender(`delegate`) as the key and the amount approved(`amount`) as the value.

### `emit Approval(msg.sender, delegate, amount);`

Emits the `Approval` event with the owner address(`msg.sender`), spender address(`delegate`) and amount approved(`amount`).

This event was gotten from the `IBasicERC20Token` interface.

## `function allowance(address owner, address delegate) public override view returns (uint) { return allowed[owner][delegate];}`

Overrides(`override`) and implements the `allowance` function defined in the interface.

### `return allowed[owner][delegate]`

Queries for the amount of token approved and returns it.

## `function transferFrom(address owner, address receiver, uint256 amount) public override returns (bool) {....}`

Overrides(`override`) and implements the `transferFrom` function defined in the interface.

The logic inside this is similar to that of the `transfer` function except that here, we have to deduct the amount sent(`amount`) from the amount of token approved(`allowed[owner][msg.sender]`):

`allowed[owner][msg.sender] -= amount;`
