# Topic 4: What A Smart Contract Is, Looks Like, And How It Works

## Start here: a question, not a definition

Three topics in, you've now used the phrase "smart contract" a dozen times without actually looking at one. The DAO was "a smart contract." DeFi protocols are "smart contracts." But what does one actually look like, physically, and how does a network with no central computer manage to "run" code at all? Let's look at one before defining anything.

## Notice it, before we name it

Here is a small, real smart contract — you don't need to understand every symbol yet, that's next week's job. For now, just look at its *shape*:

```solidity
pragma solidity ^0.8.24;

contract Counter {
    uint256 public count;

    function increment() public {
        count += 1;
    }
}
```

Notice a few things, just from looking:

- It's a plain text file. Nothing exotic, no special hardware, no proprietary format — you could write this in Notepad.
- `contract Counter { ... }` looks a lot like a class definition in any object-oriented language you may already know — a named container with some data (`count`) and some behavior (`increment`).
- `function increment() public { count += 1; }` is a function, doing one obvious thing: adding 1 to a stored number. There's no hidden magic in the syntax itself.

If that's all a smart contract were — a file that looks like ordinary code — it wouldn't be interesting. The interesting part is what happens *after* this file is written, and that's genuinely different from a normal program.

An ordinary program runs on one computer (or one company's servers) when someone launches it, and stops when it's closed. This file, once deployed, gets compiled into bytecode (Week 1's hashing, applied to code instead of transactions) and stored at a permanent address on the blockchain. From that moment on, *every single node on the network* — thousands of independently operated computers, per Topic 1 — is capable of executing that exact bytecode, and whenever someone sends a transaction calling `increment()`, every node that processes that transaction runs the *same* computation and must arrive at the *identical* result. There's no "the server is down" — as long as the network exists, the contract exists and behaves identically everywhere.

## Now it has a name

A **smart contract** is:

1. **Code**, written in a language like Solidity, that describes some data (state) and some functions that can read or change that state.
2. **Compiled to bytecode** and **deployed** via a transaction — the same signed, broadcast, mined-into-a-block process from Week 1, just with "here is a program" as the payload instead of "send Alice 1 ETH."
3. **Executed identically by every node** that processes a transaction calling it — which is *why* execution has to be fully deterministic and metered by gas (so a computation can't run forever and stall the whole network) — this connects directly to Week 1's consensus topic: thousands of independent computers can only stay in agreement if they're all guaranteed to compute the exact same result from the exact same input, every time.
4. **Enforced by the network's rules, not a company's internal policy** — nobody can quietly patch a bug in a deployed contract's logic the way a company patches a live app, unless that capability was deliberately, explicitly built in (Topic 3's DAO lesson, again).

## Check your understanding

If a smart contract has a bug that lets anyone drain its funds, can the team that wrote it just push a fix overnight, the way a normal app pushes a bug-fix update?

...

**Not by default.** You already know this answer — it's the exact lesson from The DAO in Topic 3. Once deployed, a contract's logic is fixed unless it was specifically designed with an upgrade mechanism in mind, which is itself a deliberate, non-default design decision with real trade-offs (you'll meet this properly in Week 7). "We'll just patch it later" is not a plan that works here the way it does for ordinary software — which is exactly why Ground Rule #4 ("every contract gets at least a basic test") and Ground Rule #2 ("testnet first, always") exist.

## Connect it

Next week, you stop reading about this and start doing it. You'll write a contract like the one above yourself, compile it, and then use real tools to look at exactly the things described here in the abstract: the actual compiled bytecode (not just "it gets compiled," but the literal hex), the actual storage slot holding `count` (not just "state persists," but the literal value sitting on-chain), and the actual deployment transaction (not just "it gets deployed," but a real transaction hash you can look up). Everything in this topic is a preview; Week 3 is where it becomes something you can hold and inspect.

## Real-world uses

- **Vending machines**, as Nick Szabo (who coined the term "smart contract" in the 1990s, well before blockchains existed) originally used as the analogy: put in the right amount, select an option, and the machine mechanically guarantees the outcome — no cashier, no trust required, the rules are enforced by the mechanism itself. A blockchain smart contract is the same idea, with a global network standing in for the vending machine's internal mechanics.
- **Escrow services** — traditionally a trusted third party holds funds until conditions are met; a smart contract can hold funds and release them automatically once on-chain conditions are verified, removing the third party entirely.
- **Every DeFi protocol, NFT marketplace, and DAO treasury** you'll encounter for the rest of this course is, underneath, exactly the "code + storage + address" model from this topic — nothing about them is conceptually different from the six-line `Counter` above, just larger and more carefully engineered.

## Common misconceptions

- **"A smart contract is a legal contract."** Not inherently — it's a program that automatically enforces rules. Whether that program's behavior is also legally binding depends on jurisdiction and context, and is a separate (and still-evolving) question from whether it's technically enforced.
- **"Smart contracts can access anything on the internet."** They can't, by default — a contract can only see data that's been submitted to it in a transaction, or that already exists on-chain. Getting real-world data (like a price feed) on-chain requires a deliberate mechanism (an oracle), which you'll meet in Week 7.

## Recommended videos

- [Smart contracts - Simply Explained](https://www.youtube.com/watch?v=ZE2HxTmxfrI)
- [What is a Smart Contract - Coinbase Crypto University](https://www.youtube.com/watch?v=KO9mdk8CSpo)

## Practice

1. Find a verified smart contract on Etherscan (search for any well-known token or protocol) and just read its source code — don't worry about understanding every line, just notice the shape: `contract`, state variables, functions — the exact pattern from this topic, at real-world scale.
2. Write, on paper or in a text file (no need to compile anything yet), a rough sketch of what a smart contract for a simple raffle might look like: what state would it need to track, and what functions would it need.

## Take-home

**Written (5–6 sentences):** Using the vending-machine analogy, explain in your own words why "no cashier required" and "no company can quietly change the rules after the fact" are really the same underlying property, viewed from two different angles.
