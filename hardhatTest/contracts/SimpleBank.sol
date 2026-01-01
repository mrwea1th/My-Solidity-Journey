// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 🔥 核心科技：引入 Hardhat 的打印工具
import "hardhat/console.sol";

contract SimpleBank {
    mapping(address => uint256) public balance;

    // 存钱事件
    event Deposit(address indexed user, uint256 amount);
    
    // 取钱事件
    event Withdraw(address indexed user, uint256 amount);

    // 【存钱函数】
    function deposit() external payable {
        // 👇 这行代码会让你的终端显示绿色的字！
        console.log("LOG: User %s is depositing %s wei", msg.sender, msg.value);

        balance[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 【取钱函数】
    function withdraw(uint256 want) external {
        console.log("LOG: User %s wants to withdraw %s wei", msg.sender, want);
        
        require(balance[msg.sender] >= want, "Not enough money!");

        balance[msg.sender] -= want;
        payable(msg.sender).transfer(want);
        
        console.log("LOG: Withdraw success! Remaining balance: %s", balance[msg.sender]);
        emit Withdraw(msg.sender, want);
    }

    // 【查余额】
    function getBalance() external view returns (uint256) {
        return balance[msg.sender];
    }
}