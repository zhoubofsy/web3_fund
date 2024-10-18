// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内，达到目标值，生产商可以提款，提款后，给投资人返回响应的通证
// 4. 在锁定期内，没有达到目标值，投资人在锁定期以后退款
// 5. 增加Fund基础信息，及信息获取、编辑接口

contract Fund {
    mapping(address => uint256) public fundersToAccount;
    address[] public funders;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        funders.push(msg.sender);
        fundersToAccount[msg.sender] = msg.value;
    }

    function refund() external {
        require(fundersToAccount[msg.sender] != 0, "Sorry, you have no coins to refund.");
        bool result = false;
        (result, ) = payable(msg.sender).call{value: fundersToAccount[msg.sender]}("");
        require(result, "Refund tx failed");
        fundersToAccount[msg.sender] = 0;
    }

    function autoRefund() public {
        for(uint i=0; i<funders.length; i++) {
            address refunder = funders[i];
            bool refundResult = false;
            (refundResult, ) = payable(refunder).call{value: fundersToAccount[refunder]}("");
            require(refundResult, "Refund tx failed "); // + addressToString(refunder)
            fundersToAccount[refunder] = 0;
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getFund() public onlyOwner {
        bool result = false;
        (result, ) = payable(msg.sender).call{value: this.getBalance()}("");
    }

    function setOwner(address _addr) public onlyOwner validAddress(_addr) returns (address _owner) {
        _owner = owner;
        owner = _addr;
    }

    modifier validAddress(address _addr) {
        require(address(0) != _addr, "The address is invalid.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "This function can only be called by owner.");
        _;
    }
}

// contract Utils {
//         function addressToString(address _addr) public pure returns (string _str) {
//         bytes memory b = new bytes(20);
//         for (uint i = 0; i < 20; i++) {
//             b[i] = bytes(uint8(uint160(_addr) / (2**(8*(19-i)))));
//         }
//         _str = string(b);
//     }
// }