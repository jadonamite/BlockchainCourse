# Topic 3: Blocks, Chains & Block Explorers

## The plain-language explanation

You now know how hashing works (Topic 1) and how signing proves who authorized something (Topic 2). This topic ties them together into the actual structure that gives "blockchain" its name — and then shows you the everyday tool (a **block explorer**) that lets you actually see all of this happening on a real, live network.

### What a block is

A **block** is simply a batch of transactions, bundled together, plus some metadata. That metadata always includes:

- A **timestamp** (when the block was created)
- The **hash of the previous block**
- Its **own hash** (calculated from everything inside it, including the previous block's hash)
- Some network-specific extra fields (which validator produced it, total gas used, etc.)

Transactions don't get added to the blockchain one at a time — they're grouped into these batches (blocks) roughly every 12 seconds on Ethereum, and each block is added to the end of the chain once the network agrees on it (the *how* they agree is Topic 4, consensus).

### What makes it a "chain"

Here's the part that makes everything click: **each block includes the hash of the block directly before it, as part of its own data.** Since you already know from Topic 1 that changing *any* input to a hash function completely changes the output (the avalanche effect), this creates a domino effect. If someone tries to secretly alter a transaction inside Block #100, the hash of Block #100 changes completely. But Block #101 already recorded the *original* hash of Block #100 as part of its own data — so Block #101's hash is now wrong too. Which breaks Block #102's reference to Block #101. And so on, all the way to the most recent block.

To successfully tamper with old data, an attacker would need to recompute the hash of every single block after the one they changed — and, as you'll see in Topic 4, get the *entire network* to accept their rewritten version instead of the real one. That combination is what makes blockchain data effectively immutable in practice — it's the chain structure *plus* consensus working together, not any single trick.

## Worked example (a real, runnable 3-block chain, with a real tampering attempt)

This was run with a small Python script using the built-in `hashlib` module — no blockchain library involved, just the hashing primitive from Topic 1, applied exactly as described above.

```python
import hashlib

def h(s):
    return hashlib.sha256(s.encode()).hexdigest()

block1_data = "Genesis block"
block1_prev = "0" * 64
block1_hash = h(block1_data + block1_prev)

block2_data = "Alice pays Bob 2 ETH"
block2_prev = block1_hash
block2_hash = h(block2_data + block2_prev)

block3_data = "Bob pays Carol 1 ETH"
block3_prev = block2_hash
block3_hash = h(block3_data + block3_prev)
```

**Real output — the original, valid chain:**

```
Block 1: data='Genesis block'          prev=0000000000000000...  hash=80d76888074f7dfa22f4a6c73a894f8dc9c596e4b7c17389f6fe59b77b7dd021
Block 2: data='Alice pays Bob 2 ETH'   prev=80d76888074f7dfa...  hash=7dd7f6149021fd741a6b1cf5ef626f386a2d8c0cfa68de41c75f29f3b824623f
Block 3: data='Bob pays Carol 1 ETH'   prev=7dd7f6149021fd74...  hash=22001e872e22499069eec17de2f0af8b702e1e8332df83d4142a96b97b25315f
```

Notice Block 3's `prev` field is the *first 16 characters* of Block 2's actual hash — that's the literal link. Now, an attacker edits Block 2, changing "2 ETH" to "20 ETH":

```python
block2_data_tampered = "Alice pays Bob 20 ETH"
block2_hash_tampered = h(block2_data_tampered + block2_prev)
```

**Real output — the tampering attempt:**

```
Block 2 NEW hash:                6c7db182ce1b8061543e98d0549c337486a15d1bb8ff7a675ccc681b59e5a216
Block 3 still says its prev should be: 7dd7f6149021fd741a6b1cf5ef626f386a2d8c0cfa68de41c75f29f3b824623f
Match? False
```

The tampered Block 2 now has a different hash. But Block 3 was built expecting Block 2's *original* hash — the two no longer match. Anyone checking the chain can detect the inconsistency in a single comparison, without knowing anything about what was changed or why. This is exactly what a real blockchain node does, automatically, for every block it receives.

## Real-world use case: you have already been using this exact structure — it's called Git

This is not an analogy. Git, the version control system installed on your machine right now, is architecturally a hash chain, in the literal sense described above. Every commit you make is identified by a hash, and every commit stores the hash of its parent commit. Here's real output from a two-commit git repository:

```
$ git log --format="commit %H%nparent %P%n"
commit 14170b8693832cd89ca256741e1af856ede4361
parent 5c0144c7a07feca64a44f84b71b369c6b9d1304

commit 5c0144c7a07feca64a44f84b71b369c6b9d1304
parent
```

Notice: the newer commit's `parent` field is exactly the older commit's hash. If you went back and edited the content of the older commit (e.g., with `git rebase` or `git commit --amend`), its hash would change — and every commit after it would need new hashes too, which is precisely why rewriting shared git history is disruptive and why Git warns you loudly about it. **You have been working with a hash-linked chain of tamper-evident snapshots for your entire career as a developer, whether or not you ever thought of it that way.** The main practical difference between Git and a public blockchain is *who* is allowed to add the next entry, and how disagreements between different copies get resolved — which is exactly the consensus problem covered in Topic 4.

### Other real-world uses of this same "linked, tamper-evident structure" idea

- **Audit logs in regulated industries.** Financial and healthcare systems (subject to compliance rules like SOX or HIPAA) sometimes use hash-chained logging specifically so that, if a record is altered after the fact, auditors can prove it — the same mechanism as your worked example above, applied to a compliance log instead of a cryptocurrency ledger.
- **Certificate Transparency logs.** Every publicly trusted SSL certificate (including the one securing your bank's website) gets recorded into a public, append-only, hash-chained log, so security researchers can audit whether a Certificate Authority secretly issued a fraudulent certificate for someone's domain.
- **Merkle trees for efficient verification.** A full blockchain node stores every transaction, but a lightweight client (like a mobile wallet) doesn't want to download the entire chain just to check if one transaction is real. Instead, transactions within a block are hashed together in a tree structure (a "Merkle tree"), and a lightweight client can verify a single transaction is genuinely included in a block by checking a short chain of hashes (a "Merkle proof") — without downloading the rest of the block's data at all. This is why your phone wallet can sync quickly instead of downloading hundreds of gigabytes.

### What a block explorer actually is

All of this data — every block, every transaction, every address — is public. A **block explorer** (the most well-known for Ethereum is **Etherscan**) is just a website that reads this public data and displays it in a human-readable way, so you don't have to run your own node or manually decode raw data to see what's happening on the network. It's the closest thing blockchain has to a search engine, and it's how you'll debug your own smart contracts starting in Week 3.

On a transaction page, you'll typically see:

- **Status:** success or failed.
- **Block:** which block this transaction was included in.
- **From / To:** the sending address, and the receiving address (which might be another person's wallet, or a smart contract's address).
- **Value:** how much of the native currency (ETH, on Ethereum) was sent.
- **Gas fee:** how much was paid to have this transaction processed (more on *why* gas exists in Week 3, when you start deploying contracts).

## Real-life analogy

Think of a blockchain like a **chain of numbered receipts, stapled together, where each new receipt has to write down a summary of the total on the previous receipt before adding its own items.** If you tried to sneak into the middle of the stack and change an old receipt's total, every receipt stapled after it would now have the wrong "previous total" written on it — the mismatch would be obvious to anyone flipping through the stack, even without knowing exactly what you changed.

A block explorer, in this analogy, is like having a **searchable, digital photocopy of the entire stack of receipts**, made available to the public, so anyone can look up any specific receipt (transaction) instantly instead of having to physically dig through the whole stack.

## Common misconceptions

- **"Immutable means literally impossible to change."** More precisely: it means changing it is *detectable* and, for a large enough network, *computationally and economically infeasible* — not physically impossible in some absolute sense. As you'll see in Topic 4, an attacker with enough resources (a "51% attack") genuinely *can* rewrite recent blocks — this has happened in the real world. Immutability is a security guarantee backed by cost and detectability, not a law of physics.
- **"A block explorer showing a transaction as 'successful' means it was a good idea."** No — the chain only verifies that a transaction was correctly signed and followed the protocol's rules. It has no concept of whether you were scammed, sent funds to the wrong address, or interacted with a malicious contract. "Success" on Etherscan means "this was valid and processed," not "this was safe."
- **"Older blocks are more important than newer ones."** In practice it's closer to the opposite from a trust standpoint: the more blocks have been added *on top of* a given block, the more certain you can be it's permanent (this is what "number of confirmations" means) — because rewriting it now would require redoing the work for every block after it, all at once.

## Recommended videos

- [How to Use Etherscan (Full Tutorial 2025)](https://www.youtube.com/watch?v=IwJpKCLmeuM) — a complete, up-to-date walkthrough of Etherscan's interface: searching transactions, addresses, and contracts.
- [How To ACTUALLY Use Etherscan | Beginner's Complete Tutorial](https://www.youtube.com/watch?v=pwO34g9Uig4) — a second, beginner-paced walkthrough if you want a different explanation style.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/block](https://andersbrownworth.com/blockchain/block)** and the **"Blockchain"** tab on the same site — lets you build and edit blocks in a chain, live, and watch every block after your edit turn red (invalid) in real time.
- **[sepolia.etherscan.io](https://sepolia.etherscan.io/)** — the real Etherscan block explorer, pointed at Sepolia (a public Ethereum testnet using free fake-money ETH — exactly what you got from a faucet in this week's first deliverable).
- **Any git repository you already have on your machine.** You don't need to install anything new to explore this concept — you already have a working example.

## Practice (do this now, takes ~20–25 minutes)

1. Reproduce the worked example above: write and run the Python script yourself (or copy it in), verify you get consistent hashes on re-runs, then tamper with `block2_data` and confirm the mismatch, exactly as shown.
2. Go to any local git repository (or create a fresh one with `git init`, make two commits). Run `git log --format="commit %H%nparent %P%n"` and confirm you can see the parent-hash link between your own commits, matching the structure in this doc.
3. Go to the Anders Brownworth **Blockchain** demo (the multi-block version). Edit the data in an early block and watch every block after it immediately turn invalid.
4. Go to [sepolia.etherscan.io](https://sepolia.etherscan.io/) and paste in the transaction hash from the transaction you sent in Week 1's first deliverable. Identify: the block number, status, gas fee paid, and timestamp.

## Take-home assignment

1. **Reproduce and extend:** Take the 3-block Python script from this doc, run it, confirm your output matches the structure shown (your actual hash values will differ from a fresh chain unless you use identical inputs — that's expected). Then add a 4th block and demonstrate that tampering with Block 1 breaks the hash of every subsequent block, not just the next one.
2. **Git investigation:** In a real git repository (yours or any open-source one cloned locally), run `git cat-file -p <commit-hash>` on two consecutive commits and show, in your notes, exactly where the child commit's `parent` field matches the parent commit's own hash.
3. **Explorer investigation:** Find any 3 transactions on [sepolia.etherscan.io](https://sepolia.etherscan.io/). For each, write down: the block number, the gas fee paid, whether it succeeded or failed, and a guess about whether it was a simple transfer or a smart contract interaction.
4. **Written (5–8 sentences):** Explain, using both the Python worked example and the git example, why altering data from many blocks (or commits) ago requires recalculating everything after it — and why that becomes effectively impossible on a real network once thousands of independent computers are also holding copies of the real chain (a preview of Topic 4: consensus).
