  
//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0;

contract Coin {
    address public minter;
    uint constant maxAmount = 88;
    uint public numberOfCoinMintedForMinter = 0;
    mapping(address => User) public users;
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
        users[userAddress] = User(0, name, phoneNumber);
    }
    
    function mint(address receiver, uint amount) public onlyMinter checkIfUserExist(receiver) {
        if (receiver == minter) {
            require(numberOfCoinMintedForMinter + amount <= maxAmount, "Max number of 88 coins for minter reached");
            numberOfCoinMintedForMinter = numberOfCoinMintedForMinter + amount;
        } 
        users[receiver].balance += amount;
    }


    modifier onlyMinter() {
        require(msg.sender == minter, "Only minter can mint coin.");
        _;//stacked modifiers, this will now contain the next modifier - checkBeforeMint
    }

    function send(address receiver, uint amount) public checkIfUserExist(receiver) checkIfBalanceSufficient(amount) {
        users[msg.sender].balance -= amount;
        users[receiver].balance += amount;
    }

    modifier checkIfBalanceSufficient(uint amount) {
        require(amount <= users[msg.sender].balance, "Insufficient balance.");
        _;
    }

    modifier checkIfUserExist(address receiver) {
        require(users[receiver].phoneNumber != 0, "User not yet added to user list.");//phoneNumber default to 0 but not possible during creation
        _;//stacked modifier
    }
}
