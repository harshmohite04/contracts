// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Vote{

    function getTime()public view returns(uint){
        return block.timestamp;
    }

    
}