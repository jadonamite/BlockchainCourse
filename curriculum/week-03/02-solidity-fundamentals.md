# Topic 2: Solidity Fundamentals

## Start here: a question, not a definition

Our `Counter` contract has an owner, and only that owner is allowed to call `reset()`. Anyone else who tries gets rejected. Here's the question worth sitting with before we look at syntax: this contract lives on a fully public blockchain, with no login page, no session cookie, no username field anywhere. So how does a function running in that environment know *who* is calling it, in a way that can't be faked?

## Notice it, before we name it

Here's what actually happens when a second, different account tries to call `reset()` on our deployed `Counter`:

```
$ cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "reset()" \
    --rpc-url http://127.0.0.1:8545 --private-key <a different account's key>

Error: Failed to estimate gas: server returned an error response:
error code 3: execution reverted: custom error 0x245aecd3:
000000000000000000000000 70997970c51812dc3a010c7d01b50e0d17dc79c8
NotOwner(0x70997970C51812dc3A010C7d01b50e0d17dc79C8)
```

Notice what's in that error: the contract knew, with certainty, the exact address of whoever just tried to call it — `0x70997970C51812dc3A010C7d01b50e0d17dc79C8` — and rejected the call because it didn't match the address that deployed the contract. Nobody told the contract who was calling. It didn't check a password. It read this directly off the transaction itself.

Here's the line in `Counter.sol` responsible:

```solidity
constructor() {
    owner = msg.sender;
}
```

And the check that used it:

```solidity
function reset() public {
    if (msg.sender != owner) {
        revert NotOwner(msg.sender);
    }
    ...
}
```

`msg.sender` isn't a variable anyone sets. It's populated automatically by the Ethereum Virtual Machine itself, derived from the cryptographic signature attached to the transaction — this is Week 1's Topic 02 showing up again, doing real work. Recall: a signature proves who authorized something without them revealing their private key, and nobody else can forge it. `msg.sender` is that guarantee, made available to your Solidity code as a single built-in variable. There is no way to lie about it.

## Now it has a name

You've now met most of what you need for basic Solidity, each piece already grounded in something you just watched happen:

- **Types.** `uint256 count` is an unsigned (non-negative) integer, 256 bits wide — the EVM's native word size. `address owner` is a 20-byte Ethereum address, exactly the kind of value you saw in the error above.
- **Visibility.** `public` on `count` did something specific: it auto-generated the free `count()` getter function you called with `cast call`. `private`/`internal`/`external` restrict who can call a function or read a variable directly — you'll use these as your contracts grow.
- **`msg.sender`** — the address that directly called the current function. (**`msg.value`** is its sibling — how much ETH, if any, was sent along with the call. `Counter` doesn't use it, but you'll see it the moment you write a contract that accepts payment.)
- **Custom errors** — `error NotOwner(address caller);` plus `revert NotOwner(msg.sender);` is what produced that precise, structured error above, instead of a generic failure. Custom errors are also cheaper in gas than the older `require(condition, "some string")` style, because the string never has to be stored in the deployed bytecode.
- **Events** — `emit CountIncremented(msg.sender, count);` is how a contract announces "this happened" to the outside world. You saw one arrive as raw log data earlier; anyone — a frontend, a block explorer, an indexer — can watch for these without ever calling into the contract.
- **`immutable`** — `address public immutable owner;` is set exactly once, in the constructor, and then baked directly into the contract's bytecode rather than stored in a mutable storage slot. That's exactly why `owner` was missing from the `storage-layout` table in Topic 01 — it isn't storage at all.

## Check your understanding

Suppose Alice calls Contract A, and Contract A's function then calls a function on Contract B. Inside that function on Contract B, what does `msg.sender` equal — Alice's address, or Contract A's address?

...

**Contract A's address.** `msg.sender` always means "whoever called *me*, directly" — not the original human who kicked off the whole chain of calls. This exact distinction is why a different, older built-in — `tx.origin`, which *does* mean "the original human, no matter how many contracts the call passed through" — is dangerous to use for authorization, and why experienced Solidity developers avoid it almost entirely. You'll see exactly how it gets exploited in Week 5's security topic. For now, the rule that matters: use `msg.sender` for access control, not `tx.origin`, and you'll already be ahead of a real, historically-exploited class of bugs.

## Connect it

Custom errors aren't just a style preference — they cost less gas than string-based `require` reverts, because a string literal has to be stored in the contract's bytecode and copied into memory on every failed call, while a custom error is just a 4-byte selector (you can see one right there in the real error above: `0x245aecd3`) plus its encoded arguments. On a network where every byte of deployed bytecode and every unit of gas has a real cost, this isn't a micro-optimization — it's the kind of decision that separates code written by someone who's shipped contracts from a copy-pasted tutorial.

## Real-world uses

- **`msg.sender`-based access control** is the foundation of essentially every access-control pattern in Solidity, including OpenZeppelin's `Ownable` and `AccessControl` contracts you'll use starting Week 5 — they're more elaborate versions of the exact `if (msg.sender != owner)` check in `Counter.sol`.
- **Events** are how essentially every dApp frontend and indexing service (like The Graph, in Week 3) knows what happened on-chain, without expensively re-reading full contract state on every block.
- **Gas-conscious patterns** like custom errors over string reverts show up in every production Solidity codebase — this isn't an academic distinction.

## Common misconceptions

- **"`msg.sender` and `tx.origin` are basically the same thing."** They're only the same when a human calls a contract directly, with no intermediate contracts involved. The moment any contract-to-contract call happens, they diverge — and that divergence is a real, exploitable bug class covered in Week 5.
- **"Custom errors are just a syntax preference."** They measurably reduce deployment and runtime gas costs compared to string-based `require` — a concrete engineering trade-off, not a style choice.

## Recommended videos

- [Learn Solidity: The COMPLETE Beginner's Guide (Full Course)](https://www.youtube.com/watch?v=9BZ0zjqwCPs)
- [Solidity Tutorial: Built-in Variables (msg.sender, msg.value...)](https://www.youtube.com/watch?v=XiDs_UmEDG0)

## Practice

1. Deploy `Counter.sol` yourself, call `increment()` from one account, then try `reset()` from a *different* account — reproduce the `NotOwner` revert shown above.
2. Add a `getCallerAddress()` view function that simply returns `msg.sender`, call it from two different accounts, and confirm the returned address changes each time.
3. Change one `require(condition, "string")` you write to a custom error instead, and compare the deployed bytecode size with `forge build --sizes`.

## Take-home

1. **Written (5–6 sentences):** explain why `msg.sender` can be trusted for access control while a value a user simply *tells* your function (like a plain function argument) cannot be, without more work.
2. Extend `Counter.sol` with a `mapping(address => uint256)` that tracks how many times *each* address has called `increment()` individually — you'll need `msg.sender` as the mapping key.
