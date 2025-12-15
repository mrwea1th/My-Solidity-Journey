// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract receiveeETH{
    event Log(uint amount,uint gas);

    receive() external payable{
        emit Log(msg.value,gasleft());
    }

    function chayue() external view returns(uint balance){
        balance = address(this).balance;
    }
}

contract sendETH{
    constructor() payable{}

    receive() external payable{}

    // 用transfer()发送ETH
    function transferETH(address payable _to, uint256 amount) external payable{
        _to.transfer(amount);
    }

    error SendFailed(); // 用send发送ETH失败error

// send()发送ETH
    function send1ngETH(address payable _to, uint256 amount) external payable{
    // 处理下send的返回值，如果失败，revert交易并发送error
        bool success = _to.send(amount);
        if(!success){
            revert SendFailed();
        }
    }
}
