//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract FundMe{
    mapping(address => uint256) public addressToAmountfunded;

    function fund() public payable{
        addressToAmountfunded[msg.sender] += msg.value;

        
    }
}