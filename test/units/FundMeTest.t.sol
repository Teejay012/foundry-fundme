// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 1 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumUsd() view public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() view public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersion() view public {
        uint256 theVersion = fundMe.getVersion();
        assertEq(theVersion, 6);
    }

    function testFundFailedWithLessThanMinUsd() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdates() public {
        vm.prank(USER);

        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);

        assertEq(amountFunded, SEND_VALUE);

        // assertEq();
    }

    function testFundersArray() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunders(0);
        assertEq(funder, USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        uint256 theOwnerBalance = fundMe.getOwner().balance;
        uint256 theFunderBalance = address(fundMe).balance;

        // Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 gasStop = gasleft();
        uint256 gasUsed = (gasStart - gasStop) * tx.gasprice;
        console.log(gasUsed);

        // Assert
        uint256 theOwnerBalanceAfter = fundMe.getOwner().balance;
        uint256 theFunderBalanceAfter = address(fundMe).balance;
        assertEq(theFunderBalanceAfter, 0);
        assertEq(theOwnerBalanceAfter, theOwnerBalance + theFunderBalance);
    }

    function testWithdrawFromMultipleFunders() public {
        uint160 theFunders = 10;
        uint160 startingFunders = 1;

        for(uint160 i = startingFunders; i < theFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 theOwnerBalance = fundMe.getOwner().balance;
        uint256 theFunderBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(fundMe.getOwner().balance == theOwnerBalance + theFunderBalance);
        assertEq(address(fundMe).balance, 0);

    }

    function testcheaperWithdrawFromMultipleFunders() public {
        uint160 theFunders = 10;
        uint160 startingFunders = 1;

        for(uint160 i = startingFunders; i < theFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 theOwnerBalance = fundMe.getOwner().balance;
        uint256 theFunderBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(fundMe.getOwner().balance == theOwnerBalance + theFunderBalance);
        assertEq(address(fundMe).balance, 0);

    }
    
}