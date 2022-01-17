## `pragma solidity >=0.4.22 <0.9.0;`

This defines the version of solidity been used. It means the contract would be compiled using rules from version `0.4.22` to versions lower that `0.9.0`.

It could also be defined in this way:

`pragma solidity 0.8.0;` or `pragma solidity ^0.8.7;`; the former meaning version `0.8.0` strictly and the latter meaning version `0.8.7` and above.

## `contract TodoList {.....}`

This creates a contract object just like classes are created in other languages. All the logic of the smart contract is written inside the block created by the contract.

## `uint public count;`

This creates a variable of `count`. Let's break this down.

### `uint` 

Solidity is a statically typed language which means variable types are defined during development unlike dynamically typed languages where the types are gotten on 
runtime. Types are defined explicitly rather than implicitly.

`uint` is a type called unsigned integer which is used to store numbers from 0 and above. It cannot store negative numbers.

### `public`

This is called a visibility modifier in solidity. When used in a variable, it creates and exposes a getter function from variable allowing users to get variable data 
by calling a function with the variable name. In this case, it would provide a function `count()`.

### `count`

This is the variable name.

So, together, we declare a variable by defining the type, the visibility modifier which is optional and the variable name.

## `struct Task { uint id; string content; bool completed;}`

A  `struct` is a data type used in solidity for grouping together related data and it is defined as shown in the code; the `struct` keyword, the name of the struct
mostly capitalised, a curly bracket, type, variable and a semi-column and so on, then closing curly bracket. It could accept multiple data types just as shown above.

Just like an object in Object Oriented Programming, Instances are created out of it for grouping related data as you will see later in this guide.
It's very similar to a database table.

## `mapping(uint => Task) public tasks;`

Let's break it down

### `mapping(uint => Task)`

mapping is data type in solidity similar to hash tables and dictionaries in other programming languages. It stores data in form of key-value pairs. In this case,
 `uint` is the key of type unsigned integer and `Task` is the value of the type Struct. So, uint maps to Task.
 
 mappings are not iterable. That is, you can't loop through them. You can only get the values using the key.
 
### `public`

This is the visibility modifier just as explained above

### `tasks`

This is the variable name of the mapping.

## `event TaskCreated(uint id, string content, bool completed);`

An event used for logging in the smart contract. These logs are stored on blockchain and are accessible using address of the contract till
the contract is present on the blockchain. An event generated is not accessible from within contracts, not even the one which have created and emitted them.

This event emits an id of unsigned integer(`uint`) type, content of string type(`string`) and boolean(`bool`) value of completed 

## `function createTask(string memory _content) public{...}`

Functions in solidity are defined in a similar way to that of javascript with a few differences.
The type of function arguments are explicitly defined just like `string` above. Then, `memory` is the location where the data would be stored. Functions arguments are
stored temporarily so they are stored in the memory unlike state variables like `count` above that is stored in the `storage`(more on this later).

`_content` is the function argument. `public` like above, enables users to call the function from outside the contact. More implications of `public` and the other
visibility modifier would be discussed later in this series.

Let's look at the codes inside the function.

### `count = count + 1;`

This is an increment of the value of `count`. It is used in the next line.

### `tasks[count] = Task(count, _content, false);`

This adds an instance of the `Task` Struct to the `tasks` mapping while using `count` as the key.

### `emit TaskCreated(count, _content, false);`

This emits the event `TaskCreated` using the `emit` keyword

## `function checkTask(uint _id) public{...}`

### `Task memory _task = tasks[_id];`

Using the `_id` passed into the function as a key for the mapping, the value is stored in memory as `Task` struct is created and stored into memory.

### `_task.completed = true;`

The value of `completed` in the Struct is updated to `true` marking the task as completed

### `tasks[_id] = _task;`

The new  `_task` with the updated value of `completed` as `true` is added back into the mapping

### `emit TaskCompleted(_id, true);`

This emits the event TaskCompleted using the `emit` keyword
