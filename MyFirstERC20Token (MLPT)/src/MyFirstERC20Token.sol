// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MyFirstERC20Token {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Minted(address indexed minter, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    string public name = "My Learning Progress Token";
    string public symbol = "MLPT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint256 private constant MINT_AMOUNT = 10 * 10 ** 18;

    mapping(address => uint256) private balances;
    mapping(address => bool) private minters;
    mapping(address => mapping(address => uint256)) private allowances;

    constructor() {
        totalSupply = 0;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function mint() public {
        require(!minters[msg.sender], "Already minted");

        totalSupply += MINT_AMOUNT;
        balances[msg.sender] += MINT_AMOUNT;

        minters[msg.sender] = true;
        emit Minted(msg.sender, MINT_AMOUNT);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "ERC20: transfer to zero address");
        require(balances[msg.sender] >= value, "ERC20: insufficient balance");

        balances[msg.sender] -= value;
        balances[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(to != address(0), "ERC20: transfer to zero address");
        require(balances[from] >= value, "ERC20: insufficient balance");
        require(
            allowances[from][msg.sender] >= value,
            "ERC20: insufficient allowance"
        );

        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "ERC20: approve to zero address");

        allowances[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return allowances[owner][spender];
    }
}
