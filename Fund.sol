// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内，达到目标值，生产商可以提款，提款后，给投资人返回响应的通证
// 4. 在锁定期内，没有达到目标值，投资人在锁定期以后退款

contract Fund {
    mapping(address => uint256) public fundersToAccount;
    address[] public funders;

    function fund() public payable {
        funders.push(msg.sender);
        fundersToAccount[msg.sender] = msg.value;
    }

    function refund() public {
        for(uint i=0; i<funders.length; i++) {
            address refunder = funders[i];
            bool refundResult = false;
            (refundResult, ) = payable(refunder).call{value: fundersToAccount[refunder]}("");
            require(refundResult, "Refund tx failed "); // + addressToString(refunder)
            fundersToAccount[refunder] = 0;
        }
    }

    function getFund() public {
        bool result = false;
        (result, ) = payable(msg.sender).call{value: address(this).balance}("");
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