// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/Strings.sol";

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract MyFirstERC721Token {
    using Strings for uint256;

    string public name;
    string public symbol;
    string private baseTokenURI;

    uint256 public currentTokenId = 0;
    uint256 public maxSupply;

    IERC20 public paymentToken;

    uint256 public constant MINT_PRICE = 6e18;
    uint256 public constant MAX_MINT = 1;

    mapping(uint256 => address) private owners;
    mapping(address => uint256) private balances;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor(string memory _name, string memory _symbol, string memory _baseTokenURI, uint256 _maxSupply) {


        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        baseTokenURI = _baseTokenURI;

        paymentToken = IERC20(0xF2F86Cc8035adFe33116f238Da0861fd3AAf7d3d);
    }

    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Invalid address");
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        address owner = owners[tokenId];
        require(owner != address(0), "Invalid address");
        return owner;
    }

    function mint() public {
        require(currentTokenId < maxSupply, "Max supply reached");
        require(balances[msg.sender] < MAX_MINT, "Just 1 mint per address");

        bool success = paymentToken.transferFrom(msg.sender, address(this), MINT_PRICE);
        require(success, "Payment failed");

        balances[msg.sender]++;
        owners[currentTokenId] = msg.sender;
        emit Transfer(address(0), msg.sender, currentTokenId);
        currentTokenId++;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(owners[tokenId] != address(0), "Token doesn't exist");
        return string(abi.encodePacked(baseTokenURI, tokenId.toString(), ".json"));
    }
}
