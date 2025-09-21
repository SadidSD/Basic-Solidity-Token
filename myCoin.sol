// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Cryparion{
   string public Token_Name = "Cryparion";
   uint public Total_supply= 1000;

   address public owner; 
   mapping (address=> uint) balances; 
   mapping (address=> mapping(address=>uint)) allowance;

  constructor() {
        owner = msg.sender;
        balances[owner]= 1000;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    function Check_balance(address _address) public view returns(uint){
        return balances[_address];
    }

   function transfer(  address to, uint amount) public {
        require(balances[msg.sender]>=amount);
        balances[msg.sender]-=amount;
        balances[to]+=amount;
   }
    
   function allow(address spender, uint amount) public{
       allowance[msg.sender][spender]=amount;
   }

   function check_allowance(address allower, address spender) public view returns(uint){
       return allowance[allower][spender];
   
   }

   function transfer_from(address from, uint amount) public{
        require(allowance[from][msg.sender]>=amount);
        allowance[from][msg.sender]-=amount;
        balances[from]-=amount;
        balances[msg.sender]+=amount;
    }



}