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
		userAddresses.push(userAddress);
		users[userAddress] = User(0, name, phoneNumber);
   }

  function removeUser(address userAddress) public {
		removeByValue(userAddress);
		delete users[userAddress];
  }
  
  function find(address value) internal view returns(uint){
        uint i = 0;
        while (userAddresses[i] != value) {
           i++;
        }
        return i;
    }

    function removeByValue(address value) public{
        uint i = find(value);
        removeByIndex(i);
    }

    function removeByIndex(uint i) public {
        while (i<userAddresses.length-1) {
            userAddresses[i] = userAddresses[i+1];
            i++;
        }
         userAddresses.pop();
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
    
    modifier checkCoinsInCirculation {
        require(numberOfCoinMinted >= 8888, "Insufficient coins minted before anyone can quit."); 
         _;
    }
     
    function distributeRemainingAndRemove() public checkCoinsInCirculation{
        uint inheritance = 0;
        uint totalAmountToDistribute = users[msg.sender].balance ;
        removeUser(msg.sender);
        if(userAddresses.length > 0){
            inheritance = totalAmountToDistribute / (userAddresses.length);
        } else {
            inheritance = 0;
        }
        
        for (uint i = 0; i < userAddresses.length; i++) {
            users[userAddresses[i]].balance = users[userAddresses[i]].balance  + inheritance;
        }
    }    

     
}
