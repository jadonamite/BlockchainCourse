# Topic 1: What A Smart Contract Actually Is

## Start here: a question, not a definition

You're about to spend a week writing "smart contracts." Before writing a single line, it's worth pausing on a question most tutorials skip past: when people say a contract "lives on the blockchain," what does that actually mean? Is it a file sitting on a server somewhere? A program that's running right now, waiting for you? Let's find out by looking at one that actually exists, instead of being told the answer first.

## Notice it, before we name it

A contract called `Counter.sol` (shown in full in this week's [README](./README.md)) was compiled and deployed to a real, running local Ethereum node. It now sits at this address:

```
0x5FbDB2315678afecb367f032d93F642f64180aa3
```

Here's the first thing worth noticing. Ask that address what code lives there:

```
$ cast code 0x5FbDB2315678afecb367f032d93F642f64180aa3 --rpc-url http://127.0.0.1:8545
0x608060405234801561000f575f5ffd5b506004361061004a575f3560e01c806306661abd1461004e5780638da5cb5b1461006c576...
```

That unreadable string of hex **is the contract.** Not the Solidity source code you'd write in an editor — that gets compiled away entirely before deployment. This wall of hex is what actually, literally exists on-chain. If you wrote `Counter.sol` in French with different variable names but it compiled to the exact same logic, this hex string could come out identical. The Solidity source is a human convenience; the bytecode is the reality.

Now the second thing worth noticing. Before anyone calls `increment()`, ask the contract what its `count` is:

```
$ cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "count()(uint256)" --rpc-url http://127.0.0.1:8545
0
```

Now actually call `increment()` — a real transaction, signed and sent:

```
$ cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "increment()" \
    --rpc-url http://127.0.0.1:8545 --private-key <a real private key>

status               1 (success)
blockNumber          2
gasUsed              45209
logs                 [{"topics":["0x66e68b0f...","0x000...f39fd6e5..."], "data":"0x000...0001", ...}]
```

Ask for `count` again:

```
$ cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "count()(uint256)" --rpc-url http://127.0.0.1:8545
1
```

And here's the part that matters most. Ask the blockchain directly what's sitting in the contract's raw storage, at slot 0 — not through the `count()` function, but the actual underlying storage:

```
$ cast storage 0x5FbDB2315678afecb367f032d93F642f64180aa3 0 --rpc-url http://127.0.0.1:8545
0x0000000000000000000000000000000000000000000000000000000000000001
```

That's a real, permanent value — `1` — sitting at a specific storage slot, at a specific address, on a specific chain. It didn't get returned by a function call and then discarded. It's *there*, the same way a value sitting in a spreadsheet cell is there whether or not anyone's currently looking at the spreadsheet.

## Now it has a name

What you just watched has three pieces, and this is the entire mental model of a smart contract:

1. **Bytecode** — the compiled program, permanently stored at an address. This is the "code" part.
2. **Storage slots** — permanent, named (well, numbered) values that persist between transactions. This is the "state" part. `forge inspect Counter storage-layout` will show you exactly which variable lives in which slot:

   ```
   ╭-------+---------+------+--------+-------+-------------------------╮
   | Name  | Type    | Slot | Offset | Bytes | Contract                |
   +===================================================================+
   | count | uint256 | 0    | 0      | 32    | src/Counter.sol:Counter |
   ╰-------+---------+------+--------+-------+-------------------------╯
   ```

   Notice `owner` isn't in this table at all, even though it's a state variable in the source code — more on that in Topic 02, when `immutable` comes up.

3. **An address** — where to find both of the above. `0x5FbDB2315678afecb367f032d93F642f64180aa3` isn't a label someone chose; it's deterministically derived from who deployed the contract and how many transactions they'd sent before (or, for some deployment methods, from other inputs entirely).

**A smart contract is bytecode + storage, sitting at an address.** That's it. There's no server running your Solidity source code somewhere. There's no interpreter reading your original `.sol` file at call-time. Every full node on the network stores that bytecode and that storage, and re-executes the bytecode locally whenever a transaction calls the contract.

## Check your understanding

If two different people each deploy the exact same `Counter.sol` — identical source code, identical compiler settings — do they end up with "the same contract"?

...

No. Same bytecode, yes — but two different addresses (because each deployer's address and transaction history differ), and two completely independent sets of storage. Alice's `Counter` and Bob's `Counter` don't share a `count`. Incrementing one does nothing to the other. They're two separate contracts that happen to run identical code, the same way two people can have the same job title without being the same person.

## Connect it

If you've written object-oriented code before, this maps almost exactly onto something you already know: **the Solidity source is like a class definition; a deployed contract is like an instance of it.** The class defines what fields exist and what methods are available; an instance has its own actual field values in memory.

The difference — and it's a significant one — is that this "instance" is permanent, public, and nobody can quietly reach in and edit its state from outside except by calling one of its own functions, each of which is itself a publicly visible, permanently recorded transaction. There's no direct memory access, no admin backdoor by default, no way to patch a running instance's code without the contract being deliberately designed for upgrades (a topic for a later week). What you deploy is, by default, exactly what runs, forever, for everyone.

## Real-world uses

This "code + state, permanently, at a public address" model isn't unique to Ethereum — it's a specific, blockchain-flavored version of a much older idea:

- **Actor-model systems** (Erlang/Elixir processes, for example) — long-running, addressable units that hold their own private state and only change it in response to messages.
- **Database stored procedures** — code that lives alongside data and can only be invoked through defined entry points, not arbitrary direct edits.
- **Content-addressed storage** (like IPFS, which you'll meet in Week 3) — where an object's identity is derived from what it contains, similar in spirit to how a contract's bytecode determines its behavior regardless of what you call the source file.

## Common misconceptions

- **"The Solidity source code is what's running."** No — the *compiled bytecode* is what's running. The source is for humans; verification (Topic 4) is what lets others confirm a given source file actually produces the deployed bytecode.
- **"Contract state lives in a database somewhere off-chain."** No — it's stored directly as part of the blockchain's own state, replicated across every full node, secured by the same hashing and consensus mechanisms from Week 1.

## Practice

1. Run `cast code <address>` on any contract address on a testnet (or reuse this week's deployment) and confirm you get back unreadable bytecode, not source code.
2. Run `cast storage <address> 0` before and after calling a state-changing function, and watch the raw value change.
3. Run `forge inspect Counter storage-layout` on your own copy of `Counter.sol` and identify which slot holds which variable.

## Take-home

1. **Written (4–5 sentences):** explain, in your own words, why a smart contract's address is a better analogy for "an object instance" than "a running program."
2. Deploy your own copy of `Counter.sol` locally (or another simple contract) and use `cast storage` to find and read one of its state variables directly, bypassing its getter function.
