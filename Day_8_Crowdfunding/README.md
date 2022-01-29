# Project Overview

This is a `Crowdfunding` contract. This is a contract that allows individuals to support a cause by donating funds. Just like `Go FundMe`.

Here's how it works:

A user joins the platform, creates a fundraiser, individuals can donate to the cause and then, when the target is reached or passed, the creator of the fundraiser can then be redeemed.

Take a look at the previous contracts for some prequisite knowledge on contracts.

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

This is a mapping that maps an address of a donor to a amount that has been donated by that donor and stores it in the variable `donations`.

This helps to keep track how much a donor has donated.

## `uint public donationsCount = 0;`

Declares and assigns the value of `donationsCount` to 0 and it is used to keep track of the number of `donations` in the contract.

## `struct FundRaiser{ address owner; string title; string description; uint target; uint amountRaised; bool targetReached; bool redeemed;}`

A  `struct` is a data type used in solidity for grouping together related data and it is defined as shown in the code; the `struct` keyword, the name of the struct
mostly capitalised, a curly bracket, type, variable and a semi-column and so on, then closing curly bracket. It could accept multiple data types just as shown above.

Just like an object in Object Oriented Programming, Instances are created out of it for grouping related data as you will see later in this guide.
It's very similar to a database table.

This `struct` has attributes as defined above:

- `owner`: The address who created the fundraiser and who is the only one eligible to redeem the funds generated from the fundraiser.
- `title`: This is the title of the fundraiser
- `description`: This is the cause the fundraiser is trying to tackle
- `target`: This is the amount of funds that is willing to be raised. This takes the value in `wei`. `wei` is the smallest denomination of `ether` where `1 ether = 1000000000000000000 wei`.
- `amountRaised`: This tracks the amount of money that has been raised so far.
- `targetReached`: This is a boolean value(`true` or `false`) that checks that the `target` amount has been reached.
- `redeemed`: This is another boolean value(`true` or `false`) that checks that the fundraiser has been redeemed or withdrawn after the `target` has been reached.

## `event FundRaiserCreated( address owner, string title, string description, uint target );`

This event emits the `user's address`,`title`, `description` and `target` when a user is creates a fundraiser.

## `mapping(uint => FundRaiser) public fundsRaisers;`

This is a mapping that maps an id of `unsigned integer` to the `FundRaiser` struct and stores it in the variable `fundsRaisers`.

It keeps track of the fundraisers in the contract.

## `mapping(uint => bool) public fundsRaiserAdded;`

This is a mapping that maps an id of `unsigned integer` to a boolean value and stores it in the variable `fundsRaiserAdded`.

It helps checks that a fundrasier has been added.

## `event Funded( address sender, uint amountSent, uint fundId, string fundTitle );`

This event emits the `donor's address`,`amountSent`(amount donated), `fundId`(fundraiser id) and `fundTitle`(title of a fundraiser) when a fundraiser recieves funds from a donor.

## `uint fundsRaisersCount = 0;`

Declares and assigns the value of `fundsRaisersCount` to 0 and it is used to keep track of the number of `fundsRaisers` in the contract.

## `event Redeemed( address owner, uint amount, uint fundRaiserId, string fundTitle );`

This event emits the `owner's address`,`amount`(amount redeemed), `fundRaiserId`(fundraiser id) and `fundTitle`(title of a fundraiser) when the owner of a fundraiser redeems a fundraiser after the target has been reached.
