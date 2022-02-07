# Project Overview

This is a `Crowdfunding` contract. This is a contract that allows individuals to support a cause by donating funds. Just like `Go FundMe`.

Here's how it works:

A user joins the platform, creates a fundraiser, individuals can donate to the cause and then, when the target is reached, the creator of the fundraiser can then redeem the funds.

Take a look at the previous contracts for some prequisite knowledge on contracts.

## `address public owner;`

Here, we declare an `owner` variable of `address` type and visibility of `public`

## `uint public ownerBalance = 0;`

Here, we declare and assign the `ownerBalance` variable to `0`.

This stores the amount withdrawable by the `owner` of the contract.

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

## `struct FundRaiser{ address owner; string title; string description; uint target; uint amountRaised; uint balance; bool targetReached; }`

A  `struct` is a data type used in solidity for grouping together related data and it is defined as shown in the code; the `struct` keyword, the name of the struct
mostly capitalised, a curly bracket, type, variable and a semi-column and so on, then closing curly bracket. It could accept multiple data types just as shown above.

Just like an object in Object Oriented Programming, Instances are created out of it for grouping related data as you will see later in this guide.
It's very similar to a database table.

This `struct` has attributes as defined above:

- `owner`: The address who created the fundraiser and who is the only one eligible to redeem the funds generated from the fundraiser.
- `title`: This is the title of the fundraiser
- `description`: This is the cause the fundraiser is trying to tackle
- `target`: This is the amount of funds that is willing to be raised. This takes the value in `wei`. `wei` is the smallest denomination of `ether` where `1 ether = 1000000000000000000 wei`.
- `amountRaised`: This tracks the amount of ether that has been raised so far.
- `balance`: This tracks that the amount of ether that is withdrawable by the `owner` of the fundraiser. When a withdrawal occurs, this value is deducted and vice-versa.
- `targetReached`: This is a boolean value(`true` or `false`) that checks that the `target` amount has been reached.

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

## `constructor(){ owner = msg.sender; }`

A constructor in Object Oriented Programming is a function that is run when an object is initialized. That is, when an instance of that object is created.
In this case, the constructor is executed when a contract is deployed.

That means, any code inside the constructor is run when the contract is deployed. Let's see what's inside the constructor.

Here, the `owner` variable is set to the caller of the contract(`msg.sender`).

## `modifier onlyOwner(){ require(msg.sender == owner, "Only owner can call this function"); _;}`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition.

It works similarly to how decorators work in programming languages like python.

In this case, `require(msg.sender == owner, "Only owner can call this function")` checks whether the caller of a function(`msg.sender`) is equal to the `owner` set above. If it passes, `_;` signifies that it should go ahead and run the function it is modifying else it would throw an error and revert with message `Only owner can call this function`. We'll see it in practice below.

## `function join() external {....}`

Using this function, a user can join the Crowdfunding smart contract.

### `external`

This is a visibility modifier that ensures that this function can only we called outside the contract.

The statement above is not entirely true because we could call this function using the `this` keyword but it's expensive to do that. Or, better still use the `public` keyword instead if you want to be able to call the function both outside and inside the contract.

### `require(userAdded[msg.sender] == false, "You are already registered");`

This checks that the caller of the function is not already registered.

It reverts with an error message `You are already registered` if the check fails.

### `userCount += 1;`

This increments the `userCount` by `1` which in turn serves as an `id` for the mapping `users` in the next line.

The value of `userCount` is incremented before using it as an `id` in the `users` mapping and not after because we want the `id` to start from `1` not `0`.

### `users[msg.sender] = userCount;`

Adds the caller(`msg.sender`) as the key in the `users` mapping and the `userCount` as the value

### `userAdded[msg.sender] = true;`

Adds the caller(`msg.sender`) as the key in the `userAdded` mapping and the `true` as the value.

This helps to check that the user is not already registered or otherwise.

### `emit UserAdded(msg.sender);`

Emits the `UserAdded` event.

## `function startFundRaiser(string memory _title, string memory _desc, uint target) external {....}`

Using this function, a registered user could start a fundraiser.

### `require(userAdded[msg.sender], "Sorry. You are not a registered user");`

Works similarly to how that of the `join` function works but here, it does the opposite.

It checks that the caller of the function is already registered.

It reverts with an error message `Sorry. You are not a registered user` if the check fails.

### `fundsRaisersCount += 1;`

This increments the `fundsRaisersCount` by `1` which in turn serves as an `id` for the mapping `users` in the next line.

### `fundsRaisers[fundsRaisersCount] = FundRaiser(msg.sender, _title, _desc, target, 0, false, false);`

Uses the variable `fundsRaisersCount` as the key of the mapping `fundsRaisers` and an instance of the `FundRaiser` struct as the value.

Adds a new fundraiser to the `fundsRaisers` mapping.

### `fundsRaiserAdded[fundsRaisersCount] = true;`

Adds the id(`fundsRaisersCount`) as the key in the `fundsRaiserAdded` mapping and the `true` as the value.

This helps to check that the fundsRaiser exists. We'll set it below.

### `emit FundRaiserCreated(msg.sender, _title, _desc, target);`

Emits the `FundRaiserCreated` event.

## `function fund(uint _id) external payable{....}`

Using this function, anyone can fund a `fundraiser` using it's `id`.

### `require(msg.value > 0, "Not enough ether");`

Checks that the amount of ether sent(`msg.value`) to the function is more than `0` else it reverts with the error message `Not enough ether`.

It makes sure that anyone calling the function is sending in ether and not just calling the function.

### `require(fundsRaiserAdded[_id], "This IDs does not exist in the fundraiser list");`

Checks that the `_id` of the fundraiser passed as argument exists by calling the `fundsRaiserAdded` mapping.

If the check fails, it reverts with the message `This IDs does not exist in the fundraiser list`.

### `FundRaiser storage _fund = fundsRaisers[_id];`

This instantiates an instance of the `FundRaiser` struct and stores it in the variable `_fund` which is in the `storage`.

The difference between `storage` and `memory` is that using `storage` you can alter state variables while using `memory` you just use the value without altering anything.

`memory` is mainly used when you want to read values. It's less expensive(it costs less gas) compared to `storage`.

On the otherhand, use `storage` when you want to alter the value you are calling like you will see below.

### `_fund.balance += msg.value;`

Increments the balance(`_fund.balance`) of the fundraiser by the amount of ether sent(`msg.value`) by the donor.

### `_fund.amountRaised += msg.value;`

Increments the funds raised(`_fund.amountRaised`) by the fundraiser by the amount of ether sent(`msg.value`) by the donor.

### `if(_fund.targetReached == false){ if(_fund.amountRaised >= _fund.target){ _fund.targetReached = true; } }`

Conditionals in solidity is defined similar to that of javascript.

Here, a check is find out if the target of the fundraiser has been reached.

if it has not been reached, it checks if the amount raised(`_fund.amountRaised`) is more than or equal to the target(`_fund.target`). If yes, it sets that the fundraiser has reached it's target(`_fund.targetReached = true;`)

### `donations[msg.sender] += msg.value;`

This adds the donor(`msg.sender`) as key and the ether donated(`msg.value`) adding it up to any existing donations from this donor.

### `donationsCount += 1;`

Increments the amount of donations by `1`

### `emit Funded(msg.sender, msg.value, _id, _fund.title);`

Emits the event `Funded` with donor(`msg.sender`),amount donated(`msg.value`), fundraiser id(`_id`) and title of the fundraiser(`_fund.title`).

## `function redeemFunds(uint _fundRaiserId, uint amount) external{....}`

Using, an owner of a fundraiser can withdraw funds from the fundraiser.

### `require(fundsRaiserAdded[_fundRaiserId], "This IDs does not exist in the fundraiser list");`

Checks that the `_fundRaiserId` of the fundraiser passed as argument exists by calling the `fundsRaiserAdded` mapping.

If the check fails, it reverts with the message `This IDs does not exist in the fundraiser list`.

### `FundRaiser storage _fund = fundsRaisers[_fundRaiserId];`

This instantiates an instance of the `FundRaiser` struct and stores it in the variable `_fund` which is in the `storage`.

### `require(msg.sender == _fund.owner, "You are not the owner of this fundraiser");`

Checks that the caller of the function(`msg.owner`) is same as the owner of the fundraiser(`_fund.owner`).

If the check fails, it reverts with the message `You are not the owner of this fundraiser`.

### `require(_fund.balance >= amount, "Insufficient balance");`

Checks that the balance of the fundraiser(`_fund.balance`) is more than or equal to the amount(`_fund.balance`) the caller is trying to withdraw.

If the check fails, it reverts with the message `Insufficient balance`.

### `require(_fund.targetReached, "Target has not been reached");`

Checks that the target of the fundraiser has been reached.

If the check fails, it reverts with the message `Target has not been reached`.

### `uint ownerShare = amount/10;`

Calculates `10%` of the amount the caller wants to withraw and stores it in the `ownerShare` variable.

### `uint amountSendable = amount - ownerShare;`

Deducts the `ownerShare` from the amount the caller wants to withdraw and stores it in `amountSendable` variable.

### `(bool sent, ) = payable(msg.sender).call{value: amountSendable}("");`

This tries to send the `amountSendable` from the contract to the caller of the function.

`call` is similar to the `transfer` but it returns a boolean value(`sent`) and a bytes32 value.

Here `(bool sent, )`, we left the other side of the comma empty because there is no use for the value. Else, it would have been like so `(bool sent, bytes32 memory data)`.

### `require(sent, "Failed to send Ether");`

Depending on the value of `sent`, this line of code throws an error and revert or not.

### `_fund.balance -= amount;`

Deducts the `amount` from the fundraiser balance(`_fund.balance`)

### `ownerBalance += ownerShare;`

Adds the `ownerShare` to the `ownerBalance` which can later be withdrawn by the `owner` of the contract.

### `emit Redeemed(msg.sender, amountSendable, _fundRaiserId, _fund.title);`

Emits the event `Redeemed` with caller(`msg.sender`),amount(`amountSendable`), fundraiser id(`_fundRaiserId`) and title of the fundraiser(`_fund.title`).

## `function getBalance() external view returns(uint){ return address(this).balance;}`

`address(this)` is the address of the smart contract and `balance` is an attribute of every address which is the amount of ether the address contains.

Returns the ether balance of the smart contract in `wei`.

`wei` is the smallest unit of `ether`. `1 ether = 1000000000000000000 wei`

## `function withdraw() external onlyOwner{ (bool sent, ) = payable(msg.sender).call{value: ownerBalance}(""); require(sent, "Failed to send Ether");ownerBalance = 0; }`

### `onlyOwner`

A `modifier`. Check above for what it does.

### `(bool sent, ) = payable(msg.sender).call{value: ownerBalance}("");`

This tries to send the `ownerBalance` from the contract to the `owner`.

### `require(sent, "Failed to send Ether");`

Depending on the value of `sent`, this line of code throws an error and revert or not.

### `ownerBalance = 0;`

Resets the `ownerBalance` to `0`.
