// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
// 【这是编译器生成的最终版 MyDEX，虽然你没这么写，但它实际长这样】
contract MyDEX_Final {
    
    // ----------- 这一块是从 Ownable 抄过来的 -----------
    address public owner; // 变量直接有了！
    
    // 构造函数逻辑也会被合并
    // 当你部署 MyDEX 时，它会先执行 Ownable 的构造逻辑，把你设为 owner
    
    modifier onlyOwner() { // 修饰器也直接抄过来了！
        require(msg.sender == owner, "Get out!");
        _;
    }
    // ------------------------------------------------
    
    // ----------- 这一块是你自己写的 -----------
    function setFee(uint _fee) external onlyOwner { 
        // 因为上面已经抄过来了 onlyOwner 和 owner，
        // 所以这里直接用，完全不报错！
    }
}