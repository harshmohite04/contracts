// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Harsh{
    int public counter=10; //state variable

    // function localVar() public pure{
    //     int val=10; //local variable
    // }

    constructor(int _counter){
        counter=_counter;
    }

    function changeStateVariable()public{
        counter=20;
    }

    function returnStateVariable() public view returns(int){
        return counter;
    }

    function readAndWriteStateVariable() public returns(int){
        counter=100;
        return counter;
    }

    function returnLocalVariable() public pure returns(bool){
        bool value=true;
         return value;
    }

    function params(int _number)public returns(int) {
        counter = _number;
        return counter;
    }


}

// contract - 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8 