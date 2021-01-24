//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract Coin { 
  address public minter; 
  mapping (address => uint) public balances; 
 
  constructor( ) public { 
    minter = msg.sender; 
  }


  function mint(address receiver, uint amount) public onlyMinter { 
    balances[receiver] += amount; 
  } 
  
  modifier onlyMinter() {
      require(msg.sender == minter, "Only minter can mint coin." ); 
      _;
  }
 
  function send(address receiver, uint amount) public checkIfBalanceSufficient(amount) { 
    balances[msg.sender] -= amount; 
    balances[receiver] += amount; 
  } 
  
  modifier checkIfBalanceSufficient(uint amount) {
    require(amount <= balances[msg.sender], "Insufficient balance."); 
    _;
  }
}
