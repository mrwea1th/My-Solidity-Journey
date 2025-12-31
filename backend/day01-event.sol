// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract TransferEventTest {
    
    // 【关键缺失 1】定义账本
    // 这是一个状态变量，名字叫 _balances
    // 它的作用是：输入地址(key) => 返回余额(value)
    mapping(address => uint256) public _balances;

    // 定义事件（大喇叭）
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 【关键缺失 2】构造函数（可选）
    // 为了演示方便，我得先给合约转点初始资金，不然谁都没钱
    constructor() {
        // 这里的 address(this) 代表合约自己的地址
        _balances[address(this)] = 10000000;
    }

    // 执行转账逻辑
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) external {
        // 为了演示，这行代码很暴力：每次调用都强制把 from 的余额设为 1000万
        // 在真实业务中绝对不能这么写！这里是为了防止你因为余额不足报错
        _balances[from] = 10000000; 

        // 正常的转账逻辑
        _balances[from] -= amount; // 扣钱
        _balances[to] += amount;   // 加钱

        // 【大喇叭响了】释放事件
        // 前端监听到这个事件，就会更新界面显示
        emit Transfer(from, to, amount);
    }
}
