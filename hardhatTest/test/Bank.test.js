const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleBank 模拟测试", function () {
  it("应该能存钱、取钱并打印日志", async function () {
    // 1. 获取模拟账户 (Hardhat 也就是传说中的上帝模式，送你20个账户)
    // owner 是你的主号，addr1 是我们要模拟的客户
    const [owner, addr1] = await ethers.getSigners();

    console.log("\n================ 🎬 模拟开始 🎬 ================");
    console.log("模拟用户地址:", addr1.address);

    // 2. 部署合约
    const BankFactory = await ethers.getContractFactory("SimpleBank");
    const bank = await BankFactory.deploy(); // 部署实例
    await bank.waitForDeployment(); // 等待部署完成 (Ethers v6 写法)
    
    const bankAddress = await bank.getAddress();
    console.log("✅ 银行合约已部署到:", bankAddress);
    console.log("--------------------------------------------------\n");

    // 3. 模拟存钱 (存 1 ETH)
    // parseEther("1") 会把 "1" 变成 10000000000000000000 (18个0)
    const depositAmount = ethers.parseEther("1");
    
    console.log(">>> 动作: 用户正在存入 1 ETH...");
    // connect(addr1) 意思是用 addr1 的手去按 deposit 按钮
    await bank.connect(addr1).deposit({ value: depositAmount });
    
    console.log("\n"); // 空一行

    // 4. 模拟取钱 (取 0.5 ETH)
    const withdrawAmount = ethers.parseEther("0.5");
    
    console.log(">>> 动作: 用户正在取出 0.5 ETH...");
    await bank.connect(addr1).withdraw(withdrawAmount);

    console.log("\n================ 🏁 模拟结束 🏁 ================");
  });
});