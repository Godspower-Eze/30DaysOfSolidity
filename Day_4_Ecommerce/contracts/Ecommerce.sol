// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Ecommerce {
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    uint public userCount= 0;
    uint public productCount= 0;

    struct Product {
        uint id;
        address owner;
        string name;
        string description;
        uint price;
    }

    struct User{
        string name;
        uint age;
        string location;
        bool isMerchant;
        uint[] products;
    }

    event UserAdded(address userAddress, string name, bool isMerchant);
    event ProductAdded(uint id, address owner, string name, string description, uint price);
    event ProductBought(uint id, address newOwner, string name, string description, uint amountPaid);

    mapping(address => User) public users;
    mapping(address => bool) public userAdded;

    mapping(uint => Product) public products;
    mapping(uint => bool) public productAdded;

    modifier onlyOwner(){
        require(owner == msg.sender, "Only owner can call this function");
        _;
    }

    modifier addUserOnce(){
        require(userAdded[msg.sender] == false, "User can't be added twice");
        _;
    }

    modifier addProductOnlyByRegisteredUser(){
        require(userAdded[msg.sender] == true, "you are not a registered user");
        _;
    }

    modifier onlyMerchantCanAddProduct(){
        require(users[msg.sender].isMerchant == true, "Only merchants can add products");
        _;
    }

    function join(string memory _name, uint _age, string memory _location, bool _isMerchant) external addUserOnce{
        uint[] memory emptyProductsArray;
        users[msg.sender] = User({name:_name, location:_location, age:_age, isMerchant:_isMerchant, products:emptyProductsArray});
        userAdded[msg.sender] = true;
        userCount += 1;
        emit UserAdded(msg.sender, _name, _isMerchant);
    }

    function addProduct(string memory _name, string memory _description, uint _price) external addProductOnlyByRegisteredUser onlyMerchantCanAddProduct{
        productCount += 1;
        products[productCount] = Product({name:_name, description:_description, owner:msg.sender, id:productCount, price:_price});
        productAdded[productCount] = true;
        emit ProductAdded(productCount, msg.sender, _name, _description, _price);
    }

    function buyProduct(uint _id) external payable addProductOnlyByRegisteredUser{
        Product storage _product = products[_id];
        require(productAdded[_id] == true, "This product does not exist");
        require(msg.value >= _product.price, "You didn't send enough ether to buy this product");
        address payable addressOwner = payable(_product.owner);
        addressOwner.transfer(_product.price);
        _product.owner = msg.sender;
        emit ProductBought(_id, msg.sender, _product.name, _product.description, _product.price);
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }

    function withdraw() external onlyOwner{
        payable(owner).transfer(address(this).balance);
    }
 }