# Project Overview

This is an `Ecommerce`contract. And, it works similarly to how an eccommerce website would work.

Whether it's a good idea to use a smart contract for ecommerce is out of the scope of this guide. We are focusing more on how the code works rather than its use case.

Take a look at the previous contracts for some prequisite knowledge.

## `uint public userCount= 0;`
 
Keeps track of the number of users in the store
 
## `uint public productCount= 0;`

Keeps track of the number of products in the store

## `struct Product { uint id; address owner; string name; string description; uint price; }`

This `struct` defines a product. It's `id`, `owner`(the person who added it to the store or the person who has bought it from an owner),`name`,`description` and `price`

A  `struct` is a data type that groups together related data. It's like a database record.

## `struct User{ string name; uint age; string location; bool isMerchant; uint[] products;}`

This `struct` defines a user. The user's `age`, `location`,`isMerchant`(This sets where the user is a seller or not), and `products`(An array of product ids by a user)

## `event UserAdded(address userAddress, string name, bool isMerchant);`

An event used for logging in the smart contract. These logs are stored on blockchain and are accessible using address of the contract. An event generated is not
accessible from within contracts, not even the one which have created and emitted them.

This event emits the `address`, `name` and `isMerchant` status of a new user that joins the platform.

## `event ProductAdded(uint id, address owner, string name, string description, uint price);`

This event emits the `id`, `owner`, `name`, `description` and `price` of a new product added by user on the platform.

## `event ProductBought(uint id, address newOwner, string name, string description, uint amountPaid);`

This event emits the `id`, `newOwner`(The person who just bought the product), `name`, `description` and `amountPaid`(The price of the product) for a product
that has just been bought.

## `mapping(address => User) public users;`

A `mapping` is like a hash-table or dictionary that stores data in a key-value pair format. In this case, the type of the key would an `address` type and the type
of the value would be the `struct` called `User` created above.

You can't get all the key-value pairs of `mapping` at once rather you use the key to get specific value. Also, you can't get the length of a mapping

## `mapping(address => bool) public userAdded;`

We need a way to track that a user has been added to the `mapping` of `users` above we use `userAdded`.

It maps addresses to boolean(`true` or `false`) so that once an address is added to `user`, we add that address to `userAdded` and set it to `true`
unlike it's default `false` so we could use it to check that the user has been added. We'll set that later in this guide.

## `mapping(uint => Product) public products;`

This maps ids to the `Product` struct that stores the information of products.

## `mapping(uint => bool) public productAdded;`

This works exactly the way `userAdded` works.

## `modifier onlyOwner(){require(owner == msg.sender, "Only owner can call this function"); _;}`

A `modifier` in solidity is like a function that runs before the functions it is attached to. It helps to avoid code repetition.

It works similarly to how decorators work in programming languages like python.

In this case, `require(owner == msg.sender, "Only owner can call this function")` checks whether the `owner` is same as the `msg.sender`(address 
of the user that would be calling the function that it would be `modifying`). If it passes, `_;` signifies that it should go ahead and run the function
it is modifying. We'll see it in practice below.

## `modifier addUserOnce(){require(userAdded[msg.sender] == false, "User can't be added twice"); _;}`

Makes sure that a user can only be added once for the function it is modifying.

Check previous contracts to see how `require` works.

## `modifier addProductOnlyByRegisteredUser(){ require(userAdded[msg.sender] == true, "you are not a registered user"); _;}`

Makes sure that users adding products must be registered users.

## `modifier onlyMerchantCanAddProduct(){require(users[msg.sender].isMerchant == true, "Only merchants can add products"); _;}`

Makes sure that only users who are merchants can add products.

## `function join(string memory _name, uint _age, string memory _location, bool _isMerchant) external addUserOnce{....}`

Check previous contract for how functions are defined and how `external` works.

### `addUserOnce`

This is the `modifier` discussed above. It modifies the function by performing a check before running the function.

### `uint[] memory emptyProductsArray;`

Creates an empty array of `unsigned integers`.

This is a dynamic array because the length is not specified.

A static array will be defined like so `uint[5] memory emptyProductsArray;`.

### `users[msg.sender] = User({name:_name, location:_location, age:_age, isMerchant:_isMerchant, products:emptyProductsArray});`

Creates a new instance of the `User` struct and adds it to the `user` mapping using the caller's address(`msg.sender`) as the key.

This is another way of instantiating a `struct`; by using key-value pair. Using this way, the order doesn't matter.

### `userAdded[msg.sender] = true;`

Sets the value the caller(`msg.sender`) in the `userAdded` to `true` so that this user cannot be added twice.

### `userCount += 1;`

Increments the number of users in the store by 1

### `emit UserAdded(msg.sender, _name, _isMerchant);`

Emits the `UserAdded` event signifying that a new user was created

## `function addProduct(string memory _name, string memory _description, uint _price) external addProductOnlyByRegisteredUser onlyMerchantCanAddProduct{....}`

### `addProductOnlyByRegisteredUser`

This is amongst the modifiers explained above. It makes sure that only registered users can add products.

### `onlyMerchantCanAddProduct`

This is amongst modifiers explained above. It makes sure that only users who are sellers can add products.

Notice that we can use more than one modifier in a single function.

### `productCount += 1;`

Increments the `productCount` because we want the first product to have an id of `1` not `0`

### `products[productCount] = Product({name:_name, description:_description, owner:msg.sender, id:productCount, price:_price});`

Creates a new instance of the `Product` struct and adds it to the `products` mapping using `productCount` as the key.

### `productAdded[productCount] = true;`

Sets the value the `productCount` in the `productAdded` to `true` so that this product cannot be added twice.

### `users[msg.sender].products.push(productCount);`

Adds the `productCount` which is the `id` to the array of product ids by a user.

`push` is an array method alongside `pop`. `push` adds while `pop` removes elements from an array

### `emit ProductAdded(productCount, msg.sender, _name, _description, _price);`

Emits the `ProductAdded` event signifying that a new product was added.

## `function buyProduct(uint _id) external payable addProductOnlyByRegisteredUser{....}`

### `payable`

Makes it possible for this function to be able to receive ether.

### `addProductOnlyByRegisteredUser`

This is amongst the modifiers explained above. In this case, it makes sure that only registered users can buy products.

### `Product storage _product = products[_id];`

Gets a product from the `products` mapping by using the `_id` passed as argument into the function.

It then stores it in `storage` using the variable `_products`

### `require(productAdded[_id] == true, "This product does not exist");`

This checks that product exists by checking the `productAdded` mapping. It throws an error with the message `This product does not exist` if the product does not
exists.

### `require(msg.value >= _product.price, "You didn't send enough ether to buy this product");`

Checks that the amount of ether sent while calling this function is greater or equal to the prize of the product about to be bought. It throws an error with
the message `You didn't send enough ether to buy this product` if ether sent is less.

`msg.value` is the amount of ether that was sent in the transaction. The ether sent is stored in the contract.

### `address payable addressOwner = payable(_product.owner);`

Cast the product owner's address into a `payable address` to enable it receive the ether sent by the buyer. Then, stores it in the variable `addressOwner`.

### `addressOwner.transfer(_product.price);`

Transfers the ether of the product to the product owner from the contract.

`transfer` is one amongst three methods for sending ether in solidity. `send` and `call` are the others and we'll see them later in this series.

### `_product.owner = msg.sender;`

Updates the owner(`_product.owner`) with the address of the new owner(`msg.sender`: the person who just paid for the product).

### `emit ProductBought(_id, msg.sender, _product.name, _product.description, _product.price);`

Emits the `ProductBought` event signifying that a product has been bought.

## `function getBalance() external view returns(uint){ return address(this).balance;}`

`address(this)` is the address of the smart contract and `balance` is an attribute of every address which is the amount of ether the address contains.

Returns the ether balance of the smart contract in `wei`.

`wei` is the smallest unit of `ether`. `1 ether = 1000000000000000000 wei`

## `function withdraw() external onlyOwner{ payable(owner).transfer(address(this).balance);}`

Withdraws all the ether in the smart contract while using the `onlyOwner` modifier to make sure that only the `owner` can call the function.
