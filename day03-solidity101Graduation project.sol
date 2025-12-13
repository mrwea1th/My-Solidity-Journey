// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Ownable{
    address owner;

    event log(string mmsg);
    constructor (){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Insufficient privileges");
        _;
    }

    function withdrawOwner() public virtual{}

}


contract Bank is Ownable{
    error moneyShortage();
 
    event Deposit(address indexed user,uint256 amount);
    event Withdraw(address indexed user,uint256 amount);

    // 账本
    mapping(address => uint256) public balance;
    
    // 【存钱】
    // 不需要传入 amount 参数，因为 payable 函数会自动接收 ETH，数量就是 msg.value
    function deposit() external payable {
        // 1. 记账：必须用 +=，累加余额
        // 2. 身份：用 msg.sender，谁调用的就记谁
        // 3. 金额：用 msg.value，这是真金白银的数量
        balance[msg.sender] += msg.value;
        emit Deposit(msg.sender,msg.value);
    }

    // 【取钱】
    // 只需要传入想取多少钱
    function withdraw(uint256 want) external {
        // 1. 检查：检查【调用者】自己的余额够不够
        if (balance[msg.sender] < want){
            revert moneyShortage();
        }
        // 2. 扣款：先改账本（防重入攻击的最佳实践，以后会细讲）
        balance[msg.sender] -= want;

        // 3. 【最关键一步】给钱！
        // 把合约里的 ETH 转给调用者
        payable(msg.sender).transfer(want);

        emit Withdraw(msg.sender,want);
    }

    function withdrawOwner() public override onlyOwner{
        (bool status,) = payable(owner).call{value:address(this).balance}("");
        require(status,"transfer failure");
        emit log("!!!Attention!!!");
    }

    function getBankBalance() external view onlyOwner returns(uint256 totalbalance){
        totalbalance = address(this).balance;
    }
}

interface Ibank{
    function deposit() external payable;
    function withdraw(uint256 want) external;
}

contract ATM{
    address public familybank; // 建议加上 public 方便查看地址对不对
    Ibank public atm;          // 建议加上 public 方便查看 atm 实例对不对

    constructor(address _familybank){
        // 1. 先保存地址
        familybank = _familybank;
        
        // 2. ✅ 必须在这里初始化 atm 接口实例
        // 此时 _familybank 已经是真实地址了，所以 atm 指向也就对了
        atm = Ibank(_familybank);
    }

    function atmDeposit() external payable {
        // 此时 atm 已经指向了正确的银行合约
        atm.deposit{value: msg.value}();
    }
}
