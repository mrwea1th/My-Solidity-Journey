// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 1. 外部合约：只有这一个功能，除法
contract Math {
    function division(uint256 a, uint256 b) external pure returns (uint256) {
        require(b != 0, "Can not divide by zero"); // 如果b是0，抛出错误字符串
        return a / b;
    }
}

// 2. 你的合约：尝试调用
contract Student {
    event Log(string message);       // 记录普通信息
    event LogError(string reason);   // 记录错误原因

    // 实例化一个 Math 合约
    Math public mathInstance;

    constructor(address _mathAddr) {
        mathInstance = Math(_mathAddr);
    }

    // 核心函数
    function tryToCalculate(uint256 a, uint256 b) external {
        
        // 【格式重点】：try 外部合约.函数(参数) returns (返回值) { ... }
        try mathInstance.division(a, b) returns (uint256 result) {
            // ✅ 情况A：成功了！
            emit Log("Success! We got the result.");
        } 
        catch Error(string memory reason) {
            // ❌ 情况B：捕获到了 require/revert 抛出的 "文字报错"
            // reason 就是 "Can not divide by zero"
            emit LogError(reason);
        }
        catch Panic(uint errorCode) {
            // ❌ 情况C：捕获到了 assert/除以0 等 "严重恐慌"
            emit Log("Panic error happened!");
        }
        catch (bytes memory lowLevelData) {
            // ❌ 情况D：捕获到了以上都没接住的 "自定义错误" (兜底)
            emit Log("Unknown error");
        }
        
        // 🌟 关键点：无论上面 catch 到了什么，这行代码依然会执行！
        // 交易没有回滚！
        emit Log("Function finished."); 
    }
}