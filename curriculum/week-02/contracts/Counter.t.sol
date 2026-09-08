// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address public alice = address(0xA11CE);

    function setUp() public {
        counter = new Counter();
    }

    function test_StartsAtZero() public view {
        assertEq(counter.count(), 0);
    }

    function test_IncrementAddsOne() public {
        counter.increment();
        assertEq(counter.count(), 1);
    }

    function test_OwnerCanReset() public {
        counter.increment();
        counter.increment();
        counter.reset();
        assertEq(counter.count(), 0);
    }

    function test_NonOwnerCannotReset() public {
        counter.increment();
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Counter.NotOwner.selector, alice));
        counter.reset();
    }

    function testFuzz_IncrementNTimes(uint8 n) public {
        for (uint256 i = 0; i < n; i++) {
            counter.increment();
        }
        assertEq(counter.count(), n);
    }
}
