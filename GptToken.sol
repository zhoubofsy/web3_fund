// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyERC20Token {
    string public name;          // 代币名称
    string public symbol;        // 代币符号
    uint8 public decimals;       // 小数位数
    uint256 public totalSupply;  // 总供应量

    mapping(address => uint256) private balances;  // 账户余额
    mapping(address => mapping(address => uint256)) private allowances; // 授权额度

    // 事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 构造函数
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = 18; // 通常ERC20代币的默认小数位数
        totalSupply = _initialSupply * (10 ** uint256(decimals)); // 设置总供应量
        balances[msg.sender] = totalSupply; // 将总供应量分配给合约创建者
    }

    // 查询余额
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // 转账
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // 授权转账
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Invalid address");
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 从一个地址转账
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "Invalid from address");
        require(to != address(0), "Invalid to address");
        require(balances[from] >= amount, "Insufficient balance");
        require(allowances[from][msg.sender] >= amount, "Allowance exceeded");

        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    // 查询授权额度
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }
}
