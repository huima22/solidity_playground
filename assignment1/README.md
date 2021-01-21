The following smart contract, called Coin0.sol, is a simple currency system that allows someone (he/she who deploys the contract) to mint coins for himself/herself and then send the coins to his/her friends, who can then start to spend the coins among themselves.
pragma solidity >=0.5.0 <0.7.0; 
contract Coin { 
  address public minter; 
  mapping (address => uint) public balances; 
 
  constructor( ) public { 
    minter = msg.sender; 
  }
  function mint(address receiver, uint amount) public { 
    require(msg.sender == minter); 
    balances[receiver] += amount; 
  } 
 
  function send(address receiver, uint amount) public { 
    require(amount <= balances[msg.sender], "Insufficient balance."); 
    balances[msg.sender] -= amount; 
    balances[receiver] += amount; 
  } 
}

Question 1
Create a usage scenario of the Coin contract among a group of users.  Illustrate the scenario using Sequence Diagram.
Question 2
Convert the two require( ) statements into function modifiers.  Modify the contract to accommodate this.  The revised contract should be built upon Coin0.sol and be named Coin1.sol.
Question 3
Suppose we now want to store name and phone number of each user in the contract.  Modify the contract to accommodate this.  The revised contract should be built upon Coin1.sol and be named Coin2.sol.
Question 4
Suppose we now want to limit the number of coins a minter can make for himself/herself.  Let this number be 88.  Modify the contract to accommodate this.  The revised contract should be built upon Coin2.sol and be named Coin3.sol.
Question 5
Before anyone sends coins to another person, we want to check that he/she has at least twice the amount of coins he/she wants to send.  Modify the contract to accommodate this.  The revised contract should be built upon Coin3.sol and be named Coin4.sol.
Question 6
Suppose a minter decides to quit the coin contract after deploying and playing with the coin contract for a while.  Before he/she quits, there should be at least 8888 coins in circulation. 
After he presses the button and quits, his remaining coins in his possession should be distributed to the remaining users.  You can use equal distribution; i.e., everyone else receives more or less the same number of coins.  The number of coins received should be an integral number, no fractional parts.
Modify the contract to accommodate this.  The revised contract should be built upon Coin4.sol and be named Coin5.sol.