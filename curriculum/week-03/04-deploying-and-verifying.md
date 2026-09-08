# Topic 4: Deploying & Verifying

## Start here: a question, not a definition

We've built `Counter.sol` and tested it thoroughly. Right now, it exists only as source files on one machine — nobody else can see it, call it, or verify what it does. What does it actually take to make it exist somewhere anyone else in the world can also reach?

## Notice it, before we name it

Here's the real, unedited output from deploying `Counter.sol` to a running local chain:

```
$ forge create src/Counter.sol:Counter \
    --rpc-url http://127.0.0.1:8545 --private-key <a real private key> --broadcast

Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
Deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Transaction hash: 0x0a60d1ce38dc90883607341154ce77773dccb57e9cbb7ec799b7963ee8544ec2
```

Notice this is a genuine transaction — even on a local test chain, it went through the exact same process a mainnet deployment does: signed with a private key (Week 1, Topic 02), broadcast to the network, mined into a block, and now permanently occupying an address. Nothing about deploying to a real public testnet is procedurally different from this — only the `--rpc-url` changes.

Now notice what a *state-changing* call looks like once the contract is live. Here's the real, full receipt from calling `increment()`:

```
$ cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "increment()" \
    --rpc-url http://127.0.0.1:8545 --private-key <key>

blockNumber          2
gasUsed              45209
status               1 (success)
transactionHash       0x35005b233d82c536009cd50d6750c6769ec8b42f5e80ece04a70f8610ce074ec
logs                 [{"address":"0x5fbdb2315678afecb367f032d93f642f64180aa3",
                       "topics":["0x66e68b0f...","0x000...f39fd6e5..."],
                       "data":"0x000...0001", ...}]
```

That `logs` field is our `CountIncremented` event, automatically captured and made permanently, publicly queryable — this is exactly what a frontend or a block explorer reads to know what happened, without ever needing to call back into the contract.

## Now it has a name

- **Local chain (anvil), testnet, mainnet** — three tiers of "somewhere a contract can live," differing only in who else can see it and whether real money is at risk. Anvil: only you, resets on restart, free. A public testnet like Sepolia: anyone with the URL, persistent, still free (fake ETH from a faucet — exactly what you used in Week 1). Mainnet: everyone, permanent, real money.
- **Deployment** is simply a transaction whose data *is* the contract's compiled bytecode, with no specific recipient address — the network computes a new address for it and stores the bytecode there. That's the entire mechanism behind `forge create` (or the more scriptable `forge script`, which you'll use for anything beyond a single simple contract).
- **Verification** is a separate, later step: uploading your actual Solidity source to a block explorer like Etherscan, which independently recompiles it and confirms the result matches your already-deployed bytecode byte-for-byte. Once verified, the explorer can show your readable source code, decode function calls and event logs by name (instead of raw hex), and offer a "Read/Write Contract" UI for anyone to interact with your contract directly from the browser. The real command looks like this:

  ```
  $ forge verify-contract --chain sepolia --watch \
      --etherscan-api-key $ETHERSCAN_API_KEY \
      <deployed-address> src/Counter.sol:Counter
  ```

## Check your understanding

If the bytecode is already public and already unchangeable the moment it's deployed, why bother verifying it at all — what does verification actually add?

...

Bytecode alone is unreadable to a human — it's the compiled hex you saw in Topic 01. Verification doesn't change what's running; it proves that a *specific, human-readable source file* produces *exactly* that bytecode, so anyone auditing your contract can read real Solidity instead of reverse-engineering hex, and can trust that what they're reading is genuinely what's executing — not just your word for it.

## Connect it

This is the same mechanism from Week 1's very first deliverable, just aimed at a contract instead of a plain wallet-to-wallet transfer: you sent a signed transaction, and then looked it up on a block explorer to see what happened. The only thing that's changed is what's on the receiving end of that transaction — a contract with its own logic, instead of a person's wallet — and that a *second* step (verification) now makes that contract's logic human-readable to anyone who looks it up, the same way your wallet's transaction history always was.

## Real-world uses

- **Every production DeFi protocol, NFT collection, and DAO contract you've ever interacted with** is a verified contract on a block explorer — checking that a contract is verified, and actually reading what it does, is one of the most basic real due-diligence steps before trusting it with funds.
- **CI/CD pipelines** for serious projects often run `forge script ... --broadcast --verify` as one atomic step, so a contract is never deployed without immediately being verified.
- **Bug bounty and audit workflows** depend entirely on verified source — auditors read the same Solidity you wrote, not the compiled bytecode.

## Common misconceptions

- **"Deploying to a testnet is basically a dry run that doesn't matter."** It's the same code path as mainnet deployment — same signing, same gas mechanics, same permanence *on that network*. What differs is the money at stake, not the process. Treat it seriously; that's the entire point of Ground Rule #2 ("testnet first, always").
- **"Verification is optional polish."** For a real project, an unverified contract is a serious trust red flag — reasonable users and auditors treat "unverified" as "we can't confirm what this actually does," because they can't.

## Where to practice

- [Etherscan's own contract-verification guide](https://info.etherscan.com/how-to-verify-contracts/) and [Foundry's `verify-contract` reference](https://getfoundry.sh/forge/reference/forge-verify-contract/) — the two most authoritative, current sources for this exact workflow.

## Practice

1. Deploy `Counter.sol` to Sepolia (the same testnet you used in Week 1), using a funded test wallet and a real RPC URL.
2. Verify it using `forge verify-contract` (you'll need a free Etherscan API key).
3. Find your verified contract on `sepolia.etherscan.io`, and use the "Write Contract" tab to call `increment()` directly from the browser — no `cast` required.

## Take-home

1. **Written (5–6 sentences):** explain, in your own words, the difference between "deployed" and "verified," and why a contract can be one without the other.
2. Deploy and verify your own version of `Counter.sol` (or a small variant you write yourself) on Sepolia, and submit the verified contract's Etherscan URL along with a screenshot of a successful `increment()` transaction from the "Write Contract" tab.
