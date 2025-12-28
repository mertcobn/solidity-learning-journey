// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {MyFirstERC721Token} from "../src/MyFirstERC721Token.sol";
import {MyFirstERC721TokenScript} from "../script/MyFirstERC721TokenScript.s.sol";
import {MyFirstERC20Token} from "erc20/src/MyFirstERC20Token.sol";

contract MyFirstERC721TokenTest is Test {
    MyFirstERC721Token myFirstERC721Token;
    MyFirstERC20Token myFirstERC20Token;

    address user = makeAddr("user");
    address emptyAddress = address(0);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() external {
        myFirstERC20Token = new MyFirstERC20Token();

        address expectedERC20 = 0xF2F86Cc8035adFe33116f238Da0861fd3AAf7d3d;
        vm.etch(expectedERC20, address(myFirstERC20Token).code);
        myFirstERC20Token = MyFirstERC20Token(expectedERC20);

        vm.prank(user);
        myFirstERC20Token.mint();
        MyFirstERC721TokenScript myFirstERC721TokenScript = new MyFirstERC721TokenScript();
        myFirstERC721Token = myFirstERC721TokenScript.run();
    }

    function testInitialBalanceIsZero() public view {
        assertEq(myFirstERC721Token.balanceOf(user), 0);
    }

    function testBalanceOfRevertsWithInvalidAddress() public {
        // require(owner != address(0), "Invalid address");
        vm.prank(emptyAddress);
        vm.expectRevert("Invalid address");
        myFirstERC721Token.balanceOf(emptyAddress);
    }

    function testOwnerOfReturnsCorrectOwner() public {
        vm.startPrank(user);
        myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
        myFirstERC721Token.mint();
        assertEq(myFirstERC721Token.ownerOf(0), user);
        vm.stopPrank();
    }

    function testOwnerOfRevertsWithInvalidAddress() public {
        // require(owner != address(0), "Invalid address");
        vm.startPrank(emptyAddress);
        myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
        vm.expectRevert("ERC20: insufficient balance");
        myFirstERC721Token.mint();
        vm.expectRevert("Invalid address");
        myFirstERC721Token.ownerOf(0);
        vm.stopPrank();
    }

    function testMintIncreasesBalance() public {
        vm.startPrank(user);
        myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
        myFirstERC721Token.mint();
        assertEq(myFirstERC721Token.balanceOf(user), 1);
        assertEq(myFirstERC721Token.ownerOf(0), user);
        vm.stopPrank();
    }

    function testMintRevertsWhenMaxSupplyReached() public {
        // require(currentTokenId < maxSupply, "Max supply reached");
        address[] memory users = new address[](myFirstERC721Token.maxSupply());

        for (uint256 i = 0; i < myFirstERC721Token.maxSupply(); i++) {
            users[i] = makeAddr(vm.toString(i));

            vm.prank(users[i]);
            myFirstERC20Token.mint();

            vm.startPrank(users[i]);
            myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
            myFirstERC721Token.mint();
            vm.stopPrank();
        }

        address lastUser = makeAddr("lastUser");
        vm.startPrank(lastUser);
        myFirstERC20Token.mint();
        myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
        vm.expectRevert("Max supply reached");
        myFirstERC721Token.mint();
        vm.stopPrank();
    }

    function testMintRevertsWhenAlreadyMinted() public {
        // require(balances[msg.sender] < MAX_MINT, "Just 1 mint per address");
        vm.startPrank(user);
        myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
        myFirstERC721Token.mint();

        vm.expectRevert("Just 1 mint per address");
        myFirstERC721Token.mint();
        vm.stopPrank();
    }

    function testTokenURIRevertsWithNonExistentToken() public {
        // require(owners[tokenId] != address(0), "Token doesn't exist");
        vm.expectRevert("Token doesn't exist");
        myFirstERC721Token.tokenURI(0);
    }

    function testMintEmitsEvent() public {
        vm.startPrank(user);
        myFirstERC20Token.approve(address(myFirstERC721Token), type(uint256).max);
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), user, myFirstERC721Token.currentTokenId());
        myFirstERC721Token.mint();
        vm.stopPrank();
    }
}
