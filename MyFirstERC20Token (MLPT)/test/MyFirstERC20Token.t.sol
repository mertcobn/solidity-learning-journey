// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {MyFirstERC20Token} from "../src/MyFirstERC20Token.sol";
import {MyFirstERC20TokenScript} from "../script/MyFirstERC20TokenScript.s.sol";

contract MyFirstERC20TokenTest is Test {
    MyFirstERC20Token myFirstERC20Token;

    uint256 mintAmount = 10 * 10 ** 18;

    address firstUser = makeAddr("firstUser");
    address secondUser = makeAddr("secondUser");
    address emptyAddress = address(0);

    function setUp() external {
        MyFirstERC20TokenScript myFirstERC20TokenScript = new MyFirstERC20TokenScript();
        myFirstERC20Token = myFirstERC20TokenScript.run();
    }

    function testEvents() public {}

    function testNameIsCorrect() public view {
        string memory tokenName = myFirstERC20Token.name();
        console.log("Token name:", tokenName);
        assertEq(keccak256(abi.encodePacked(tokenName)), keccak256(abi.encodePacked("My Learning Progress Token")));
    }

    function testSymbolIsCorrect() public view {
        string memory symbolName = myFirstERC20Token.symbol();
        console.log("Symbol name:", symbolName);
        assertEq(keccak256(abi.encodePacked(symbolName)), keccak256(abi.encodePacked("MLPT")));
    }

    function testDecimalsIsEighteen() public view {
        uint256 decimalValue = myFirstERC20Token.decimals();
        console.log("Decimal value:", decimalValue);
        assertEq(decimalValue, 18);
    }

    function testInitialTotalSupplyIsZero() public view {
        uint256 totalSupply = myFirstERC20Token.totalSupply();
        console.log("Total supply:", totalSupply);
        assertEq(totalSupply, 0);
    }

    function testMintIncreasesUserBalance() public {
        vm.prank(firstUser);
        myFirstERC20Token.mint();
        console.log("balanceOf(firstUser): ", myFirstERC20Token.balanceOf(firstUser));
        assertEq(myFirstERC20Token.balanceOf(firstUser), mintAmount);
    }

    function testHasMinted() public {
        vm.prank(firstUser);
        myFirstERC20Token.mint();
        assertTrue(myFirstERC20Token.hasMinted(firstUser));
    }

    function testMintRevertsWhenAlreadyMinted() public {
        vm.prank(firstUser);
        myFirstERC20Token.mint();
        vm.prank(firstUser);
        vm.expectRevert("Already minted");
        myFirstERC20Token.mint();
    }

    function testMintIncreasesTotalSupply() public {
        vm.prank(firstUser);
        myFirstERC20Token.mint();
        assertEq(myFirstERC20Token.totalSupply(), mintAmount);
    }

    function testMintSetsHasMintedFlag() public {
        assertFalse(myFirstERC20Token.hasMinted(firstUser));
        vm.prank(firstUser);
        myFirstERC20Token.mint();
        assertTrue(myFirstERC20Token.hasMinted(firstUser));
    }

    function testTransferRevertsToZeroAddress() public {
        vm.prank(firstUser);
        myFirstERC20Token.mint();
        vm.prank(firstUser);
        vm.expectRevert("ERC20: transfer to zero address");
        myFirstERC20Token.transfer(emptyAddress, mintAmount);
    }

    function testTransferRevertsWithInsufficientBalance() public {
        vm.prank(firstUser);
        vm.expectRevert("ERC20: insufficient balance");
        myFirstERC20Token.transfer(secondUser, mintAmount);
    }

    function testTransferUpdatesBalancesAndReturnsTrue() public {
        vm.startPrank(firstUser);
        myFirstERC20Token.mint();
        myFirstERC20Token.transfer(secondUser, (mintAmount / 2));
        assertEq(myFirstERC20Token.balanceOf(firstUser), (mintAmount / 2));
        assertEq(myFirstERC20Token.balanceOf(secondUser), (mintAmount / 2));
        assertTrue(myFirstERC20Token.transfer(secondUser, (mintAmount / 2)));
        vm.stopPrank();
    }

    function testTransferFromRevertsToZeroAddress() public {
        vm.startPrank(firstUser);
        myFirstERC20Token.mint();
        vm.expectRevert("ERC20: transfer to zero address");
        myFirstERC20Token.transferFrom(firstUser, emptyAddress, mintAmount);
        vm.stopPrank();
    }

    function testTransferFromRevertsWithInsufficientBalance() public {
        vm.prank(firstUser);
        vm.expectRevert("ERC20: insufficient balance");
        myFirstERC20Token.transferFrom(firstUser, secondUser, mintAmount);
    }

    function testTransferFromRevertsWithInsufficientAllowance() public {
        vm.startPrank(firstUser);
        myFirstERC20Token.mint();
        myFirstERC20Token.approve(secondUser, mintAmount / 2);
        vm.stopPrank();
        vm.prank(secondUser);
        vm.expectRevert("ERC20: insufficient allowance");
        myFirstERC20Token.transferFrom(firstUser, secondUser, mintAmount);
    }

    function testTransferFromUpdatesBalances() public {
        vm.startPrank(firstUser);
        myFirstERC20Token.mint();
        myFirstERC20Token.approve(secondUser, mintAmount);
        vm.stopPrank();
        vm.startPrank(secondUser);
        myFirstERC20Token.transferFrom(firstUser, secondUser, mintAmount / 2);

        assertEq(myFirstERC20Token.balanceOf(firstUser), mintAmount / 2);
        assertEq(myFirstERC20Token.balanceOf(secondUser), mintAmount / 2);
        assertTrue(myFirstERC20Token.transferFrom(firstUser, secondUser, mintAmount / 2));
        vm.stopPrank();
    }

    function testApproveIsZero() public {
        vm.expectRevert("ERC20: approve to zero address");
        myFirstERC20Token.approve(emptyAddress, mintAmount);
    }
    
    function testApproveUpdatesAllowance() public {
        vm.prank(firstUser);
        myFirstERC20Token.approve(secondUser, mintAmount);
        assertEq(myFirstERC20Token.allowance(firstUser, secondUser), mintAmount);
    }

}
