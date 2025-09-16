// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthWallet {
    address public owner;
    

  
    
    constructor() payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    receive() external payable { }

   function sendToAddress(address to, uint amount) public {
    payable(to).transfer(amount*1000000000000000000);
}

    function contractBalance() public view returns (uint) {
        uint balance_In_Eth =address(this).balance/1000000000000000000;
        return balance_In_Eth;
    }


    function Contract_address() public view returns (address) {
        return address(this);
    }
    }

