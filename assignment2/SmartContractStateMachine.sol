//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.7.0; 

contract StateMachine { 
    enum State { A, B, C, D, E }
    State public state; 
    mapping(string => bool) messageValid;
    
     constructor( ) public { 
            messageValid["m1"]=true;
            messageValid["m2"]=true;
            messageValid["m3"]=true;
            messageValid["m4"]=true;
            messageValid["m5"]=true;
            messageValid["m6"]=true;
            messageValid["m7"]=true;
    }
    
    modifier checkIfMessageValid(string memory message) {
        require(messageValid[message], "Invalid message"); 
         _;
     }
     
     modifier checkIfEnd() {
        require(state != State.E, "ProcessEnd");
        _;
     }
     
     
    function nextState(string memory message) public checkIfMessageValid(message) checkIfEnd{
        if(state == State.A){
            processStateA(message);
        }
        if(state == State.B){
            processStateB(message);
        }
        if(state == State.C){
            processStateC(message);
        }
         if(state == State.D){
            processStateD(message);
        }
        
    }
    
    function processStateA(string memory message) internal{
        if(compareStrings(message, "m1")){
            state = State.B;
        } 
        
        if(compareStrings(message, "m8")) {
            state = State.E;
        }
    }
    
      function processStateB(string memory message) internal{
        if(compareStrings(message, "m2")){
            state = State.E;
        } 
        
        if(compareStrings(message, "m3")) {
            state = State.C;
        }
     }
    
       function processStateC(string memory message) internal{
        if(compareStrings(message, "m4")){
            state = State.E;
        } 
        
        if(compareStrings(message, "m5")) {
            state = State.D;
        }
     }
    
       function processStateD(string memory message) internal{
        if(compareStrings(message, "m6")){
            state = State.B;
        } 
        
        if(compareStrings(message, "m7")) {
            state = State.E;
        }
     }
    function compareStrings(string memory a, string memory b) internal view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
 
}