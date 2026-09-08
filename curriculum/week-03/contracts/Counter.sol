// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter {
    // "public" auto-generates a free getter function — anyone can read this.
    uint256 public count;

    // "immutable" is set once, in the constructor, and baked into the
    // deployed bytecode — cheaper to read than a regular storage variable.
    address public immutable owner;

    // Custom errors are cheaper than revert strings and show up by name
    // in tools like Etherscan and Foundry's trace output.
    error NotOwner(address caller);

    // Events are how a contract "logs" something happened — free for
    // anyone to read via a node or block explorer, without being stored
    // in the contract's own accessible state.
    event CountIncremented(address indexed by, uint256 newCount);
    event CountReset(address indexed by);

    constructor() {
        owner = msg.sender;
    }

    function increment() public {
        count += 1;
        emit CountIncremented(msg.sender, count);
    }

    function reset() public {
        if (msg.sender != owner) {
            revert NotOwner(msg.sender);
        }
        count = 0;
        emit CountReset(msg.sender);
    }
}
