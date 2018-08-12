pragma solidity ^0.4.23;

import "../token/ERC20/MintableToken.sol";
import "../ownership/Ownable.sol";

contract EnaToken is MintableToken {

    string public name;
    string public symbol;
    uint8 public decimals;

    constructor (string _name, string _symbol, uint8 _decimals) public Ownable() {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
}
