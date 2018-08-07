pragma solidity ^0.4.23;

import "../token/ERC20/ERC20Interface.sol";
contract EnaDrop
{
//設定
address token_contract_address;
address pool_owner;
uint256 withdraw_value;

//記録
address[] public withdrawed_addresses;

constructor() public {
token_contract_address = 0x00;//仮
pool_owner = 0x00;//仮
withdraw_value = 1;//仮
}

//管理者がトークンをプールする
function pool(uint256 value) external
{
ERC20Interface token = ERC20Interface(token_contract_address);
token.transfer(this, value);//このコントラクト自身にプールする
}

//プール残高は？
function get_pool_balance() public view returns (uint256)
{
ERC20Interface token = ERC20Interface(token_contract_address);
return token.balanceOf(this);
}

//プールから管理者にトークンを返還する
function withdraw_all() public
{
require(msg.sender==pool_owner);
ERC20Interface token = ERC20Interface(token_contract_address);
token.transfer(pool_owner, token.balanceOf(this));
}

//引き出し額
function set_withdraw_value(uint256 value) public
{
require(msg.sender==pool_owner);
withdraw_value = value;
}

//引き出せる？
function can_withdraw(address addr) public view returns (bool)
{
require(withdraw_value <= get_pool_balance());//残高足りているか
for (uint i = 0; i < withdrawed_addresses.length; i++)
{
if(withdrawed_addresses[i]==addr)
{
return false;//一人一回
}
}
return true;
}

//引き出す☆
function withdraw() external returns (bool)
{
require(can_withdraw(msg.sender));
ERC20Interface token = ERC20Interface(token_contract_address);
token.transfer(msg.sender, withdraw_value);
withdrawed_addresses.push(msg.sender);
}
}