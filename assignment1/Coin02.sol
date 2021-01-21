//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract Coin { 
  address public minter; 
  mapping (address => Player) public players; 
  address [] playerAddress;
  
  struct Player {
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
  
  
  function mint(address receiver, uint amount) public onlyMinter { 
    players[receiver].balance += amount; 
  } 
  
  modifier onlyMinter() {
      require(msg.sender == minter, "Only minter can mint coin." ); 
      _;
  }
 
  function send(address receiver, uint amount) public checkIfBalanceSufficient(amount) { 
    players[msg.sender].balance -= amount; 
    players[receiver].balance += amount; 
  } 
  
  modifier checkIfBalanceSufficient(uint amount) {
       require(amount <= players[msg.sender].balance, "Insufficient balance."); 
       _;
  }
}
