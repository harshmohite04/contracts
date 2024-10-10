// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

//Transaction - from,to,timings,amount
contract SimpleWallet {
    struct Transaction {
        address from;
        address to;
        uint256 timestamp;
        uint256 amount;
    }
    Transaction[] public transactionHistory;

    address public owner;
    string public str;
    bool public stop;
    event Transfer(address receiver, uint256 amount);
    event Receive(address sender, uint256 amonut);
    event ReceiveUser(address sender, address receiver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You dont have access");
        _;
    }
    mapping(address => uint256) suspiciousUser;

    modifier getSuspiciousUser(address _sender) {
        _;
    }

    modifier isEmergencyDeclared() {
        _;
    }

    function toggleStop() external onlyOwner {}

    function changOwner(address newOwner)
        public
        onlyOwner
        isEmergencyDeclared
    {
        owner = newOwner;
    }

    /**Contract related functions**/
    function transferToContract() external payable {
        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );
    }

    function transferToUserViaContract(address payable _to, uint256 _weiAmount)
        external
        onlyOwner
    {
        require(address(this).balance >= _weiAmount, "Insufficient Balance");
        _to.transfer(_weiAmount);
        emit Transfer(_to, _weiAmount);

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: _to,
                timestamp: block.timestamp,
                amount: _weiAmount
            })
        );
    }

    function withdrawFromContract(uint256 _weiAmount) external onlyOwner {
        payable(owner).transfer(_weiAmount);
        transactionHistory.push(
            Transaction({
                from: address(this),
                to: owner,
                timestamp: block.timestamp,
                amount: _weiAmount
            })
        );
    
    }

    function getContractBalanceInWei() external view returns (uint256) {
        return address(this).balance;
    }

    /**User related functio ns**/
    function transferToUserViaMsgValue(address _to) external payable {
        require(address(this).balance >= msg.value, "Insufficient Balance");
        require(_to!= address(0), "Insufficient Balance");
        payable(_to).transfer(msg.value);

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: _to,
                timestamp: block.timestamp,
                amount: msg.value
            })
        );
    }

    //event - sender,receiver, amount
    function receiveFromUser() external payable {
        payable(address(this)).transfer(msg.value);
        emit ReceiveUser(msg.sender, address(this), msg.value);

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );
    }

    function getOwnerBalanceInWei() external view returns (uint256) {
        return owner.balance;
    }

    receive() external payable {
        emit Receive(msg.sender, msg.value);

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );
    }

    function suspiciousActivity(address _sender) public {}

    fallback() external payable {
        payable(msg.sender).transfer(msg.value);
    }

    function getTransactionHistory()
        external
        view
        returns (Transaction[] memory)
    {
        return transactionHistory;
    }

    function emergencyWithdrawl() external payable{
        payable(owner).transfer(address(this).balance);
    }
}

//Add the following features
//1.Setting and Changing Owner done
//2.Emergency Stop 
//3. Emergency Withdrawl
//4. Check for invalid address done
//5. Transaction history - from,to,amount,timestamp done
