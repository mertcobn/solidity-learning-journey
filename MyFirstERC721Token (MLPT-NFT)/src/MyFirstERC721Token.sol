// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "@openzeppelin/contracts/utils/Strings.sol";

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract MyFirstERC721Token {
    using Strings for uint256;

    string public name = "Random Strokes";
    string public symbol = "RSMNC";
    string private _baseTokenURI;

    uint256 public maxSupply = 20;
    uint256 private _currentTokenId = 0;

    IERC20 public paymentToken;
    uint256 public mintPrice = 6e18;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    constructor() {
        _baseTokenURI = "ipfs://QmXBC6qm7zyR12kNm1gWDzxBX9mwaUdvRmTXssu7AJzhRe/";
        paymentToken = IERC20(0xF2F86Cc8035adFe33116f238Da0861fd3AAf7d3d);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "Invalid address");
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        address _owner = _owners[_tokenId];
        require(_owner != address(0), "Invalid address");
        return _owner;
    }

    function mint() public {
        require(_currentTokenId < maxSupply, "Max supply reached");

        bool success = paymentToken.transferFrom(
            msg.sender,
            address(this),
            mintPrice
        );
        require(success, "Payment failed");

        _balances[msg.sender]++;
        _owners[_currentTokenId] = msg.sender;
        emit Transfer(address(0), msg.sender, _currentTokenId);
        _currentTokenId++;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        require(_owners[_tokenId] != address(0), "Token doesn't exist");
        return
            string(
                abi.encodePacked(_baseTokenURI, _tokenId.toString(), ".json")
            );
    }
}
