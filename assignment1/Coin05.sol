//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract Coin { 
  address public minter; 
  uint constant public max_amount = 88;
  uint public numberOfCoinMinted;
  mapping (address => Player) public players; 
  address [] public playerAddress;
  struct Player{
      uint balance;
      string name;
      string phoneNumber;
  }
  
  constructor( ) public { 
    minter = msg.sender; 
  }
   function addPlayer(address playAddress,string memory name, string memory phoneNumber) public{
      playerAddress.push(playAddress);
      players[playAddress] = Player(0,name,phoneNumber);
  }
  
  function removePlayer(address playAddress) public {
      removeByValue(playAddress);
      delete players[playAddress];
  }
  
  function find(address value) internal view returns(uint){
        uint i = 0;
        while (playerAddress[i] != value) {
            i++;
        }
        return i;
    }

    function removeByValue(address value) public{
        uint i = find(value);
        removeByIndex(i);
    }

    function removeByIndex(uint i) public {
        while (i<playerAddress.length-1) {
            playerAddress[i] = playerAddress[i+1];
            i++;
        }
         playerAddress.pop();
    }
  
  
    
   function getNumberOfCoinMinted() public view returns(uint)  {
        return numberOfCoinMinted;
    } 
    

    
     function setNumberOfCoinMinted(uint  _numberOfCoinMinted) public {
        numberOfCoinMinted = _numberOfCoinMinted;
    } 
     
  
     function mint(address receiver, uint amount) public checkBeforeMint { 
       numberOfCoinMinted = numberOfCoinMinted + amount;
       players[receiver].balance += amount; 
     } 
     
     modifier checkBeforeMint() {
         require(msg.sender == minter, "Only minter can mint coin." ); 
         require(numberOfCoinMinted < max_amount, "Max number of coins reached" ); 
         _;
     } 
   
    
     function send(address receiver, uint amount) public checkIfBalanceSufficient(amount) checkIfBalanceTwiceSufficient(amount) { 
       players[msg.sender].balance -= amount; 
       players[receiver].balance += amount; 
     } 
     
     modifier checkIfBalanceSufficient(uint amount) {
          require(amount <= players[msg.sender].balance, "Insufficient balance."); 
          _;
     }
     
      modifier checkIfBalanceTwiceSufficient(uint amount) {
         require(amount * 2 <= players[msg.sender].balance, "Insufficient balance."); 
          _;
     }
     
     
        function distributeRemainingAndRemove() public {
            uint inheritance = 0;
            uint totalAmountToDistribute = players[msg.sender].balance ;
            removePlayer(msg.sender);
            if(playerAddress.length > 0){
                 inheritance = totalAmountToDistribute / (playerAddress.length);
            } else {
                inheritance = 0;
            }
        
          for (uint i = 0; i < playerAddress.length; i++) {
            players[playerAddress[i]].balance = players[playerAddress[i]].balance  + inheritance;
          }
         
    }    

     
}
