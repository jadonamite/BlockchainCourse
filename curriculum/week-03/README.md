# Week 3: Writing & Deploying Your First Smart Contract

Week 2 gave you the conceptual model — what decentralization buys you, what a DAO is, and a first, code-free look at what a smart contract is and how it works. This week is where that becomes real: you'll write, compile, test, deploy, and verify an actual one.

This week has four topics, and — unlike a reference manual — each one is written as a **teaching sequence**, not a glossary. Every topic follows the same shape:

1. **A question or problem first** — before any jargon, something you'd genuinely wonder.
2. **Notice it, before we name it** — a real, runnable example where you observe the behavior yourself.
3. **Now it has a name** — the technical term arrives as a label for something you already have a feel for, not cold.
4. **Check your understanding** — a question with a pause built in. Try to answer before reading on.
5. **Connect it** — where this shows up in the real world, and what it sets up for later.

| # | Topic | Doc |
| --- | --- | --- |
| 1 | What A Smart Contract Actually Is | [01-what-is-a-smart-contract.md](./01-what-is-a-smart-contract.md) |
| 2 | Solidity Fundamentals | [02-solidity-fundamentals.md](./02-solidity-fundamentals.md) |
| 3 | Tooling — Remix to Foundry | [03-tooling-remix-to-foundry.md](./03-tooling-remix-to-foundry.md) |
| 4 | Deploying & Verifying | [04-deploying-and-verifying.md](./04-deploying-and-verifying.md) |

**Every worked example this week comes from one real contract**, `Counter.sol`, that was actually written, compiled, tested, deployed to a local chain, and interacted with while writing these docs — not typed up from memory. The contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter {
    uint256 public count;
    address public immutable owner;

    error NotOwner(address caller);

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
```

By the end of the week, you should be able to write, test, deploy, and verify something like this yourself — and, more importantly, explain *why* each line is written the way it is.

**Week 3 deliverable:** write, test locally, and deploy this (or your own similar) contract to a public testnet. Verify it on a block explorer.
