// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployERC20Token} from "../script/DeployERC20Token.s.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

contract ERC20TokenTest is Test {
    DeployERC20Token public deployScript;
    ERC20Token public token;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() external {
        deployScript = new DeployERC20Token();
        token = deployScript.run();

        vm.prank(msg.sender);
        token.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() external {
        assertEq(STARTING_BALANCE, token.balanceOf(bob));
    }

    function testAliceAllowance() external {
        uint256 initailAllowance = 100 ether;
        uint256 transferAmount = 50 ether;

        // Bob approves Alice to transfer 50 tokens
        vm.prank(bob);
        token.approve(alice, initailAllowance);

        // Alice transfers 50 tokens from Bob to herself
        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount);

        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(token.balanceOf(alice), transferAmount);
    }

    //////////////////// AI Generated ////////////////////

    function testDeployerBalance() external {
        assertEq(token.balanceOf(msg.sender), 0); // all tokens were transferred to bob
    }

    function testTotalSupply() external {
        assertEq(token.totalSupply(), STARTING_BALANCE);
    }

    function testSymbol() external {
        assertEq(token.symbol(), "DEV");
    }

    function testName() external {
        assertEq(token.name(), "DevToken");
    }

    function testTransferToZeroAddress() external {
        // Attempt to transfer tokens to the zero address should revert
        (bool success, ) = address(token).call(
            abi.encodeWithSignature("transfer(address,uint256)", address(0), 100 ether)
        );
        assertEq(success, false, "Transfer to zero address should revert");
    }

    function testTransferFromToZeroAddress() external {
        // Attempt to transferFrom tokens from zero address should revert
        (bool success, ) = address(token).call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", address(0), bob, 100 ether)
        );
        assertEq(success, false, "TransferFrom from zero address should revert");
    }

    function testApproveToZeroAddress() external {
        // Attempt to approve tokens to the zero address should revert
        (bool success, ) = address(token).call(
            abi.encodeWithSignature("approve(address,uint256)", address(0), 100 ether)
        );
        assertEq(success, false, "Approve to zero address should revert");
    }

    function testAllowanceAfterTransferFrom() external {
        // Bob approves Alice to transfer 50 tokens
        vm.prank(bob);
        token.approve(alice, 1000 ether);

        // Alice transfers 50 tokens from Bob to herself
        vm.prank(alice);
        token.transferFrom(bob, alice, 50 ether);

        // Allowance remaining should be 950 ether
        assertEq(token.allowance(bob, alice), 950 ether);
    }
}