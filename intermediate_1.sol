// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract FixedArray {
    uint256[5] public fixedArray;

    function getLength() public view returns (uint256) {
        return fixedArray.length;
    }

    function insertElement(uint256 _element, uint256 _index) public {
        fixedArray[_index] = _element;
    }

    function getElementByIndex(uint256 _index) public view returns (uint256) {
        return fixedArray[_index];
    }

    function getArray() public view returns (uint256[5] memory) {
        return fixedArray;
    }
}

contract DynamicArray {
    uint256[] public dynamicArray;

    function insertElement(uint256 _element) public {
        dynamicArray.push(_element);
    }

    function removeLastElement() public {
        dynamicArray.pop();
    }

    function getLength() public view returns (uint256) {
        return dynamicArray.length;
    }

    function getArray() public view returns (uint256[] memory) {
        return dynamicArray;
    }
}

// // struct data type
// struct Student {
//     string name;
//     uint roll;
//     bool pass;
// }

// // to access we use this
// Student public s1;

contract StructureJustLikeC {
    struct Student {
        string name;
        uint256 rollno;
        bool pass;
    }

    Student public s1;

    function insertData(
        string memory _name,
        uint256 _rollNo,
        bool _pass
    ) public {
        //alternative
        s1 = Student(_name, _rollNo, _pass);

        // s1.name=_name;
        // s1.rollno=_rollNo;
        // s1.pass=_pass;
    }

    function getData() public view returns (Student memory) {
        return s1;
    }

    function getName() public view returns (string memory) {
        return s1.name;
    }

    function getRollNo() public view returns (uint256) {
        return s1.rollno;
    }
}

contract Mapping {
    mapping(uint256 => string) public studentDetails;

    function insertData(uint _key,string memory _value) public {
        studentDetails[_key]=_value;
    }

    function returnData(uint _key)public view returns(string memory){
        return studentDetails[_key];
    }
}


//nested mapping

contract NestedMapping{
    mapping(uint=>mapping(uint=>bool)) public studentDetails;
    function insertData(uint _row,uint _column,bool _value)public {
        studentDetails[_row][_column]=_value;
    }

    function returnData(uint _row,uint _column) public view returns(bool){
        return studentDetails[_row][_column];
    }
}