// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Blockchain{
    
    function sum(uint a,uint b)public pure returns(uint) {
        return a+b;
    }




    receive() external payable returns(){ 
        return "Hello World";
    }
    fallback() external payable { }
}