// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 引入MyERC20Token合约的接口
interface IMyERC20Token {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TransferManager {
    IMyERC20Token public token; // ERC20代币合约的实例

    // 构造函数，初始化代币合约地址
    constructor(address _tokenAddress) {
        token = IMyERC20Token(_tokenAddress);
    }

    // 转移代币的方法
    function transferTokens(address from, address to, uint256 amount) external {
        require(token.balanceOf(from) >= amount, "Insufficient balance");
        
        // 调用MyERC20Token的transferFrom方法
        bool success = token.transferFrom(from, to, amount);
        require(success, "Transfer failed");
    }
}
