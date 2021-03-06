//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0;

contract Coin {
    address public minter;
    mapping(address => User) public user;
    address [] userAddresses;

    struct User {
        uint balance;
        string name;
        uint phoneNumber;
    }

    constructor() public {
        minter = msg.sender;
		users[msg.sender] = User(0, "minter", 99999999); //initialise the contract creator
		userAddresses.push(msg.sender);
    }

    function addUser(address userAddress, string memory name, uint phoneNumber) public {
        require(phoneNumber > 9999999 && phoneNumber < 100000000, "Please enter a valid Singapore number without country code.");
        userAddresses.push(userAddress);
        user[userAddress] = User(0, name, phoneNumber);
    }

    function mint(address receiver, uint amount) public onlyMinter {
        user[receiver].balance += amount;
    }

    modifier onlyMinter() {
        require(msg.sender == minter, "Only minter can mint coin.");
        _;
    }

    function send(address receiver, uint amount) public checkIfUserExist(receiver) checkIfBalanceSufficient(amount) {
        user[msg.sender].balance -= amount;
        user[receiver].balance += amount;
    }

    modifier checkIfBalanceSufficient(uint amount) {
        require(amount <= user[msg.sender].balance, "Insufficient balance.");
        _;
    }

    modifier checkIfUserExist(address receiver) {
        require(user[receiver].phoneNumber != 0, "User not yet added to friends");
        //phoneNumber default to 0 but not possible during creation
        _; //stacked modifier
    }
}
