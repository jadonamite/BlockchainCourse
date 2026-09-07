# Topic 3: Blocks, Chains & Block Explorers

## The plain-language explanation

You now know how hashing works and how signing proves who authorized something. This topic ties them together into the actual structure that gives "blockchain" its name — and then shows you the everyday tool (a **block explorer**) that lets you actually see all of this happening on a real, live network.

### What a block is

A **block** is simply a batch of transactions, bundled together, plus some metadata. That metadata always includes:

- A **timestamp** (when the block was created)
- The **hash of the previous block**
- Its **own hash** (calculated from everything inside it, including the previous block's hash)
- Some network-specific extra fields (e.g., which validator produced it, the total gas used, etc.)

Transactions don't get added to the blockchain one at a time — they're grouped into these batches (blocks) roughly every 12 seconds on Ethereum, and each block is added to the end of the chain once the network agrees on it (more on *how* they agree in the next topic, on consensus).

### What makes it a "chain"

Here's the part that makes everything click: **each block includes the hash of the block directly before it, as part of its own data.** Since you already know from Topic 1 that changing *any* input to a hash function completely changes the output (avalanche effect), this creates a domino effect:

If someone tries to secretly alter a transaction inside Block #100 (say, changing "send 1 ETH" to "send 100 ETH"), the hash of Block #100 changes completely. But Block #101 already recorded the *original* hash of Block #100 as part of its own data — so Block #101's hash is now wrong too. Which breaks Block #102's reference to Block #101. And so on, all the way to the most recent block.

To successfully tamper with old data, an attacker would need to recompute the hash of every single block after the one they changed — and, as you'll see in the next topic, get the *entire network* to accept their rewritten version instead of the real one. That combination is what makes blockchain data effectively immutable in practice, not any single trick — it's the *chain* structure plus *consensus* working together.

### What a block explorer actually is

All of this data — every block, every transaction, every address — is public. A **block explorer** (the most well-known for Ethereum is **Etherscan**) is just a website that reads this public data and displays it in a human-readable way, so you don't have to run your own node or manually decode raw data to see what's happening on the network. It's the closest thing blockchain has to a "search engine."

On a transaction page, you'll typically see:

- **Status:** success or failed.
- **Block:** which block this transaction was included in.
- **From / To:** the sending address, and the receiving address (which might be another person's wallet, or a smart contract's address).
- **Value:** how much of the native currency (ETH, on Ethereum) was sent.
- **Gas fee:** how much was paid to have this transaction processed (you'll learn more about *why* gas exists in Week 2, when you start deploying contracts).

## Real-life analogy

Think of a blockchain like a **chain of numbered receipts, stapled together, where each new receipt has to write down a summary of the total on the previous receipt before adding its own items.** If you tried to sneak into the middle of the stack and change an old receipt's total, every receipt stapled after it would now have the wrong "previous total" written on it — the mismatch would be obvious to anyone flipping through the stack, even without knowing exactly what you changed.

A block explorer, in this analogy, is like having a **searchable, digital photocopy of the entire stack of receipts**, made available to the public, so anyone can look up any specific receipt (transaction) instantly instead of having to physically dig through the whole stack.

## Recommended videos

- [How to Use Etherscan (Full Tutorial 2025)](https://www.youtube.com/watch?v=IwJpKCLmeuM) — a complete, up-to-date walkthrough of Etherscan's interface: searching transactions, addresses, and contracts.
- [How To ACTUALLY Use Etherscan | Beginner's Complete Tutorial](https://www.youtube.com/watch?v=pwO34g9Uig4) — a second, beginner-paced walkthrough if you want a different explanation style.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/block](https://andersbrownworth.com/blockchain/block)** and **[andersbrownworth.com/blockchain](https://andersbrownworth.com/blockchain/)** (the "Blockchain" tab specifically) — lets you build and edit blocks in a chain, live, and watch every block after your edit turn red (invalid) in real time. This is genuinely one of the best "aha" moments in this entire course — don't skip it.
- **[sepolia.etherscan.io](https://sepolia.etherscan.io/)** — the real Etherscan block explorer, pointed at Sepolia (a public Ethereum testnet, meaning it uses free fake-money ETH — exactly what you got from a faucet in this week's first deliverable). Use this to look up your own real testnet transaction.

## Practice (do this now, takes ~15–20 minutes)

1. Go to the Anders Brownworth **Blockchain** demo (the multi-block version, not just the single hash or single block page). You'll see several blocks chained together, each showing as valid (green).
2. Edit the data in an early block (e.g., Block 2). Watch every block after it immediately turn invalid (usually shown in red), because their stored "previous hash" no longer matches.
3. Try to manually re-mine (recompute) the block you edited, and notice you'd then have to do the same for every block after it to make the chain valid again — this is the "cost of tampering" made visible.
4. Go to [sepolia.etherscan.io](https://sepolia.etherscan.io/) and paste in the transaction hash from the transaction you sent in Week 1's first deliverable (or search your wallet address to find it in your transaction history). Identify: the block number it was included in, its status, the gas fee paid, and the timestamp.

## Take-home assignment

1. **Explorer investigation:** Find any 3 transactions on [sepolia.etherscan.io](https://sepolia.etherscan.io/) (they can be your own, a classmate's, or any public ones you find by browsing recent blocks). For each, write down: the block number, the gas fee paid, whether it succeeded or failed, and a guess (based on what you see — e.g., the "To" address, or whether there's contract interaction data) about whether it was a simple transfer or a smart contract interaction.
2. **Written (5–8 sentences):** Using what you saw in the Anders Brownworth chain demo, explain in your own words why altering a transaction from 100 blocks ago would require recalculating every single block's hash after it — and why that becomes effectively impossible once you factor in that thousands of independent computers around the world are also holding copies of the real chain (a preview of next topic: consensus).
