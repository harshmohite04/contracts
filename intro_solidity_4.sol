// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Parent {
    //conditionals
    int256 public num;

    function conditionals(int256 a) public returns (int256) {
        num = 100;
        if (a > 0) {
            return 0;
        } else if (a < 0) {
            return -1;
        } else {
            return 1;
        }
    }

    function requireCheck(int256 a) public {
        require(a > 0, "a is greater than 0");
        num = a;
    }

    // modifier will act as a middleware
    modifier onlyTrue() {
        // must have modifier as a keyword
        require(true == true, "false is true");
        _; // underscore is necessary
    }

    function check1() public pure onlyTrue returns (int256) {
        return 1;
    }

    function check2() public pure onlyTrue returns (int256) {
        return 2;
    }

    function check3() public pure onlyTrue returns (int256) {
        return 3;
    }

    //Modifier with parameters
    modifier checkSum(
        uint256 _value,
        uint256 _min,
        uint256 _max
    ) {
        require(_value >= _min && _value <= _max, "Value is out of range");
        _;
    }

    function doSomething(uint256 _value)
        public
        checkSum(_value, 10, 100)
        returns (int256)
    {
        return 1;
    }

    // public , private , internal, external
    function f1() public returns (int256) {
        f2();
        f3();
        f1();
        // f4();  , it is not accessable because it is external which we cannot access from Within Contract
        return 1;
    }

    function f2() private returns (int256) {
        return 2;
    }

    function f3() internal returns (int256) {
        return 3;
    }

    function f4() external returns (int256) {
        return 4;
    }
}

//Dervied Contract
contract Child is Parent {

// Here you have see f1,f3,f4 but you cant access f4 because it external , and f2 is private so it is not visible in Derived Contract

    // function f1() public returns (int256) {
    //     f2();
    //     f3();
    //     f1();
    //     // f4();  , it is not accessable because it is external which we cannot access from Within Contract
    //     return 1;
    // }

    // function f2() private returns (int256) {
    //     return 2;
    // }

    // function f3() internal returns (int256) {
    //     return 3;
    // }

    // function f4() external returns (int256) {
    //     return 4;
    // }
}

// contract otherContract{
//     Parent obj = new Parent();
//     uint public y = obj.f4();
// }
