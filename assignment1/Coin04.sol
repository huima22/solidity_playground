//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract Coin { 
  address public minter; 
  uint constant public max_amount = 88;
  uint public numberOfCoinMinted;
  mapping (address => Player) public players; 
  address [] playerAddress;
   
  struct Player{
      uint balance;
      string name;
      string phoneNumber;
  }
  
 
  constructor( ) public { 
    minter = msg.sender; 
  }
  
    function addPlayer(address playAddress,string memory name, string memory phoneNumber) internal{
      playerAddress.push(playAddress);
      players[playAddress] = Player(0,name,phoneNumber);
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
     
}
