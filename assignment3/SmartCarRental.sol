//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract SmartCarRental { 
     enum ContractState {RENTED, COMPLETED}
     enum CarState {IN_USE, IS_BROKEN, AVAILABLE_FOR_RENT}
     struct Car {
         uint carIndex;
         string carName;
         uint rentalPrice;
         uint fixCost;
         CarState currentCarState;
     }
     
     struct Contract {
         uint carIndex;
         address customer;
         ContractState currentContractState;
     }
      mapping (uint => Car) public inventoryList; 
      mapping (address => Contract) public contractManagementList; 
  
      address payable shopOwner;  
      
      constructor(address payable _shopOwner) public{
       // initialize the cars available for rental for the shop
       Car memory yellowCar = Car(1, 'Yellow Car', 10, 20, CarState.AVAILABLE_FOR_RENT);
       Car memory redCar = Car(2, 'Red Car', 20, 30, CarState.AVAILABLE_FOR_RENT);
       Car memory blueCar = Car(3, 'Blue Car', 30, 40, CarState.AVAILABLE_FOR_RENT);
        
        inventoryList[yellowCar.carIndex] = yellowCar;
        inventoryList[redCar.carIndex] = redCar;
        inventoryList[blueCar.carIndex] = blueCar;
        shopOwner = _shopOwner;
      }
      
      // check if car available, this action is free of charge and open to everyone
      function  checkIfCarAvailable(uint carIndex)  public view returns(bool){
          return inventoryList[carIndex].currentCarState == CarState.AVAILABLE_FOR_RENT;
      }
      
      modifier preRentalCheck(uint carIndex) {
          require(contractManagementList[msg.sender].carIndex == 0  || contractManagementList[msg.sender].currentContractState == ContractState.COMPLETED, "Please close your existing contract." );
          require(inventoryList[carIndex].currentCarState == CarState.AVAILABLE_FOR_RENT, "This car is taken");
          require(msg.value >= inventoryList[carIndex].rentalPrice, "Insufficient money in request");
          _;
      }
      
      // rent a car, must pay rental upfront
      function applyForRent(uint carIndex)  preRentalCheck(carIndex) public payable{
           shopOwner.transfer(msg.value);
           inventoryList[carIndex].currentCarState = CarState.IN_USE;
           contractManagementList[msg.sender] = Contract (carIndex, msg.sender, ContractState.RENTED); 
      }
      
      // one can only break the rental car
      modifier isCustomer() {
          require(contractManagementList[msg.sender].currentContractState == ContractState.RENTED, "You cant operate on cars which are not rented by you");
          _;
      }
      
      function breakMyRentedCar() isCustomer public {
          inventoryList[contractManagementList[msg.sender].carIndex].currentCarState = CarState.IS_BROKEN;
      }
      
        function fixMyRentedCar() isCustomer public payable returns (bool) {
          if(msg.value >=  inventoryList[contractManagementList[msg.sender].carIndex].fixCost) {
              shopOwner.transfer(msg.value);
              inventoryList[contractManagementList[msg.sender].carIndex].currentCarState = CarState.IN_USE;
              return true;
          } else {
              return false;
          }
      }
     
     
     modifier preReturnCheck() {
         require(inventoryList[contractManagementList[msg.sender].carIndex].currentCarState != CarState.IS_BROKEN, "Any broken car must be fixed before return.");
         _;
     }  
     
      function returnCar() preReturnCheck public returns(bool){
            contractManagementList[msg.sender].currentContractState = ContractState.COMPLETED;
            inventoryList[contractManagementList[msg.sender].carIndex].currentCarState = CarState.AVAILABLE_FOR_RENT;
      }
      
    
}