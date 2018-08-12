pragma solidity ^0.4.23;

import "../token/ERC20/ERC20Interface.sol";
contract EnaDrop
{
//設定
address token_contract;
address pool_owner;
uint256 withdraw_value;

//記録
address[] public withdrawed_addresses;

//コンストラクタ
constructor(address token_contract_address, address pool_owner_address) public payable {
    token_contract = token_contract_address;
    pool_owner = pool_owner_address;
    withdraw_value = 1;//仮初期値
}

function get_token_contract_address() public view returns (address)
{
    return token_contract;
}

function get_pool_owner_address() public view returns (address)
{
    return pool_owner;
}


//管理者がトークンをプールする
function pool(uint256 value) external payable
{
    ERC20Interface token = ERC20Interface(token_contract);
    token.transfer(this, value);//このコントラクト自身にプールする
}

//プール残高は？
function get_pool_balance() public view returns (uint256)
{
    ERC20Interface token = ERC20Interface(token_contract);
    return token.balanceOf(this);
}

//プールから管理者にトークンを返還する
function withdraw_all() public
{
    require(msg.sender==pool_owner);
    ERC20Interface token = ERC20Interface(token_contract);
    token.transferFrom(this, pool_owner, token.balanceOf(this));
}

//引き出し額
function set_withdraw_value(uint256 value) public
{
    require(msg.sender==pool_owner);
    withdraw_value = value;
}

function get_withdraw_value() public view returns (uint256)
{
    return withdraw_value;
}

//引き出し権がまだある？
function has_right_to_withdraw(address addr) public view returns (bool)
{
    for (uint i = 0; i < withdrawed_addresses.length; i++)
    {
        if(withdrawed_addresses[i]==addr)
        {
            return false;//一人一回
        }
    }
    return true;
}

function is_sufficient_balance() public view returns (bool)
{
    return withdraw_value <= get_pool_balance();
}

//引き出す☆
function withdraw() external
{
    require(is_sufficient_balance());//残高足りているか
    require(has_right_to_withdraw(msg.sender));
    ERC20Interface token = ERC20Interface(token_contract);
    token.transfer(msg.sender, withdraw_value);
    withdrawed_addresses.push(msg.sender);
}
}//contract
