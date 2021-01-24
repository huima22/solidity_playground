//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract Coin { 
    address public minter; 
    uint constant public maxAmount = 88;
    uint public numberOfCoinMinted;
    mapping (address => User) public users; 
    address [] public userAddresses;
      
    struct User{
        uint balance;
        string name;
        uint phoneNumber;
    }
  
    constructor( ) public { 
        minter = msg.sender; 
        users[msg.sender] = User(0, "minter", 99999999); //initialise the contract creator
	userAddresses.push(msg.sender);
    }
  
    function addUser(address userAddress, string memory name, uint phoneNumber) public {
       userAddresses.push(userAddress);
       users[userAddress] = User(0, name, phoneNumber);
    }

    function removeUser(address userAddress) public {
        delete users[userAddress];
    }
  
    
    function mint(address receiver, uint amount) public onlyMinter { //removed checkBeforeMint modifier else coins will not go above 88
        numberOfCoinMinted = numberOfCoinMinted + amount;
        users[receiver].balance += amount;
    }
     
    modifier checkBeforeMint(uint amount) {
        require(numberOfCoinMinted + amount < maxAmount, "Max number of 88 coins reached");
        _;
    }

    modifier onlyMinter() {
        require(msg.sender == minter, "Only minter can mint coin.");
        _;//stacked modifiers, this will now contain the next modifier - checkBeforeMint
    }
    
    function send(address receiver, uint amount) public checkIfBalanceSufficient(amount){ 
       users[msg.sender].balance -= amount; 
       users[receiver].balance += amount; 
    } 
     
    modifier checkIfBalanceSufficient(uint amount) {
        require(amount * 2 <= users[msg.sender].balance, "Insufficient balance."); 
        _;
    }
     
    modifier checkIfUserExist(address receiver) {
        require(users[receiver].phoneNumber != 0, "User not yet added to");//phoneNumber default to 0 but not possible during creation
        _;//stacked modifier
    }
    
    modifier checkCoinsInCirculation {
        uint count;
        for (uint i = 0; i < userAddresses.length; i++) {
            count = users[userAddresses[i]].balance + count;
        }
        require(count>=8888, "Total number of coins in circulation is not yet 8888.");
        _;
    }
     
     
    function distributeRemainingAndRemove() public checkCoinsInCirculation{
        uint inheritance = 0;
        uint totalAmountToDistribute = users[msg.sender].balance ;
        removeUser(msg.sender);
        if(userAddresses.length > 1){
            address[] memory temporaryUserAddress = new address[](userAddresses.length-1);
            inheritance = totalAmountToDistribute / (userAddresses.length-1);
            uint newSize = 0 ;
            for (uint i = 0; i < userAddresses.length; i++) {
                if(userAddresses[i] != msg.sender) {
                    temporaryUserAddress[newSize] = userAddresses[i];
                    newSize++;
                    users[userAddresses[i]].balance = users[userAddresses[i]].balance  + inheritance;
                } 
            }
            userAddresses = temporaryUserAddress;
            
        } else if (userAddresses.length == 1) {
            users[userAddresses[0]].balance = users[userAddresses[0]].balance  + totalAmountToDistribute;
        }
        
    }    
}
