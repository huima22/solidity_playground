//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract Coin { 
    address public minter; 
    uint constant public max_amount = 88;
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
    }
  
    function addUser(address userAddress, string memory name, uint phoneNumber) public {
        require(phoneNumber > 9999999 && phoneNumber < 100000000, "Please enter a valid Singapore number without country code.");
        userAddresses.push(userAddress);
        users[userAddress] = User(0, name, phoneNumber);
    }

    function removeUser(address userAddress) public {
        delete users[userAddress];
    }
  
    
    function mint(address receiver, uint amount) public onlyMinter checkIfUserExist(receiver) checkBeforeMint(amount) {
        numberOfCoinMinted = numberOfCoinMinted + amount;
        users[receiver].balance += amount;
    }
     
    modifier checkBeforeMint(uint amount) {
        require(numberOfCoinMinted + amount < max_amount, "Max number of 88 coins reached");
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
     
    function distributeRemainingAndRemove() public {
        uint inheritance = 0;
        uint totalAmountToDistribute = users[msg.sender].balance ;
        removeUser(msg.sender);
        if(userAddresses.length > 1){
            address[] memory temporaryUserAddress = new address[](userAddresses.length-1);
            inheritance = totalAmountToDistribute / (userAddresses.length-1);
            uint newsize = 0 ;
            for (uint i = 0; i < userAddresses.length; i++) {
                if(userAddresses[i] != msg.sender) {
                    temporaryUserAddress[newsize] = userAddresses[i];
                    newsize++;
                    users[userAddresses[i]].balance = users[userAddresses[i]].balance  + inheritance;
                } 
                userAddresses = temporaryUserAddress;
            }
            
        } else if (userAddresses.length == 1) {
            users[userAddresses[0]].balance = users[userAddresses[0]].balance  + totalAmountToDistribute;
        }
        
    }    

     
}
