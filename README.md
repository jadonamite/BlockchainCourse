# Blockchain Curriculum: From Zero to Hackathon-Ready

The goal of this curriculum is **understanding**, not memorization. A lot of people learn blockchain development by copy-pasting Solidity templates they don't understand. That approach falls apart the moment something doesn't work exactly like the tutorial — which, in a live hackathon, is most of the time.

This course is split into two halves, four weeks each:

- **Half 1 (Weeks 1–4): Basics & Core Concepts.** Everything you need to walk into a hackathon and actually build something — not just glue code together, but understand what each piece is doing.
- **Half 2 (Weeks 5–8): Advanced Topics.** What separates a working prototype from something closer to production: security, scaling, and the wider ecosystem.

By the end, you should be able to explain *how* a blockchain and a smart contract actually work — not just recite the words.

---

## Half 1: Basics & Core Concepts (Weeks 1–4)

**Goal of this half:** by Week 4, you can build and ship a small working dApp (a website that talks to a smart contract) — the minimum toolkit for a hackathon.

### Week 1 — How a Blockchain Actually Works

Before touching any code, you need a mental model of what's actually happening under the hood.

> 📘 **Full lesson materials for this week** (elaborate explanations, real-life analogies, recommended videos, interactive practice sites, and take-home assignments for each topic below) live in [`curriculum/week-01/`](./curriculum/week-01/).

- **Hashing (SHA-256 / Keccak-256):** A hash function takes any input (a file, a transaction, a word) and turns it into a fixed-length string of characters. The same input always produces the same output, but you can't work backwards from the output to figure out the input, and changing even one character of the input completely changes the output. This is what makes blockchain data tamper-evident — if someone changes old data, its hash changes, and that breaks the chain.
- **Public/private key cryptography:** Your wallet is really just a pair of numbers — a private key (secret, never shared) and a public key (derived from it, safe to share). Your wallet *address* is derived from your public key. When you "sign" a transaction, you're using your private key to prove you authorized it, without ever revealing the key itself. Anyone can verify the signature using your public key.
- **Blocks and chains:** A block is just a batch of transactions bundled together, along with a hash of the *previous* block. That's the "chain" part — each block points to the one before it. If you tried to alter a transaction in an old block, its hash would change, which would break every block after it. That's why blockchain data is considered immutable in practice.
- **Consensus (just the concept, not the math):** Thousands of independent computers (nodes) need to agree on a single, shared history of transactions without trusting each other or a central authority. Proof of Work (mining) and Proof of Stake (staking) are two different mechanisms for reaching that agreement. You don't need to implement either — you just need to understand *why* this problem exists and *what* it solves.

**Deliverable:** Install MetaMask (a wallet), get free testnet ETH from a faucet, and send a transaction to a friend or a second wallet you control. Find that transaction on a block explorer (like Etherscan) and identify: the sender, the receiver, the amount, the gas fee, and the transaction hash. Be able to explain what each field means.

---

### Week 2 — Writing & Deploying Your First Smart Contract

- **What a smart contract actually is:** Just a program that lives at a specific address on the blockchain, with its own storage (state) and functions anyone can call. There's no magic — it's code that runs deterministically and whose execution and results are publicly verifiable.
- **Solidity basics:** The main language for writing Ethereum-compatible contracts. Learn variables, functions, visibility (`public`/`private`/`external`/`internal`), and the special built-in variables `msg.sender` (who called this function) and `msg.value` (how much ETH they sent with the call).
- **Tooling:** Start in **Remix** (a browser-based IDE) for the first couple of days just to get a feel for writing and deploying without any setup friction. Then move to **Foundry** — a local command-line toolkit (`forge` to build/test, `cast` to interact with contracts, `anvil` to run a local blockchain on your machine) which is what you'll actually use for real projects.
- **Deploying & verifying:** Deploy a contract to a public testnet (a free, fake-money version of a real network, used for testing) and verify its source code on a block explorer so anyone can read what it does.

**Deliverable:** Write, test locally, and deploy a simple contract — a counter that increments, or a basic storage contract that saves and retrieves a value — to a testnet. Verify it on a block explorer.

---

### Week 3 — Tokens & Reusable Building Blocks

- **ERC-20 (fungible tokens):** The standard interface that defines what a "token" is on Ethereum — things like `transfer`, `balanceOf`, `totalSupply`. Any token following this standard automatically works with every wallet and exchange that supports ERC-20, which is the whole point of a standard.
- **ERC-721 (NFTs):** Same idea, but for unique, non-interchangeable tokens — each one has its own ID and can point to unique metadata (an image, a name, attributes).
- **OpenZeppelin:** A widely-used, audited library of pre-built, secure contract templates (tokens, access control, etc.). Instead of writing an ERC-20 token from scratch — and likely introducing bugs — you inherit from OpenZeppelin's implementation and customize only what you need. The rule here: don't just import it blindly, read the code you're inheriting so you know what it actually does.
- **Gas, in practical terms:** Every operation on Ethereum costs a small fee (gas), paid in the network's native currency, because someone (a validator) has to actually execute and store the result of your code. Storing data is expensive; reading data is cheap. This matters when you're designing what a contract actually stores on-chain versus off-chain.

**Deliverable:** Deploy your own ERC-20 token or a small NFT collection using OpenZeppelin as your base. Mint a few tokens to your own wallet and confirm they show up in MetaMask or a block explorer.

---

### Week 4 — Connecting a Frontend: Your First Real dApp

This is the week everything comes together — the point where you go from "I can deploy a contract" to "I can build the thing people at a hackathon actually demo."

- **How a webpage talks to a blockchain:** A frontend doesn't talk to a contract directly — it sends requests to a **node** (a computer running the blockchain software) via **JSON-RPC**, usually through a provider service like Alchemy or Infura so you don't have to run your own node.
- **ABI (Application Binary Interface):** A JSON description of a contract's functions and how to call them — think of it as the contract's "menu" that tells your frontend code what's available and how to format the request.
- **Client libraries:** Use **Viem** (or Ethers.js) — TypeScript/JavaScript libraries that handle the low-level RPC calls for you, so you can just write `contract.read.balanceOf(...)` instead of hand-crafting raw requests.
- **Wallet connection:** MetaMask (and similar wallets) inject a provider into the browser page, which is how your site asks the user to connect their wallet and approve transactions.
- **Transaction states:** A transaction isn't instant. It goes from *submitted* → *pending* (waiting to be included in a block) → *confirmed* (or *failed*). A good dApp shows the user what's happening at each stage instead of leaving them staring at a frozen button.

**Deliverable:** Build a minimal full-stack dApp: a simple webpage that connects a wallet and reads/writes to the contract you deployed in Week 2 or 3 (e.g., a page that shows your token balance and lets you send tokens to another address). This is your hackathon starter template — from here on, most hackathon projects are variations on this same pattern.

---

## Half 2: Advanced Topics (Weeks 5–8)

**Goal of this half:** understand what separates a toy project from something closer to production-grade, and how the wider ecosystem (security, scaling, infrastructure) fits together.

### Week 5 — Security: Thinking Like an Attacker

Smart contracts are unusual in that anyone can read the code, and anyone can attack it — there's no obscurity to hide behind, and mistakes are often irreversible and directly cost money.

- **Reentrancy:** The classic exploit. If contract A calls out to contract B before finishing its own bookkeeping (e.g., before updating a balance), a malicious contract B can call back into contract A and repeat an action (like a withdrawal) before the first one is even recorded. The fix is a simple rule: update your own state *before* making external calls.
- **Access control bugs:** Forgetting to restrict who can call a sensitive function (e.g., anyone can call `withdrawAllFunds()` because there's no check that the caller is the owner).
- **Integer overflow/underflow:** Less of an issue since Solidity 0.8+ (it now reverts automatically on overflow), but you should still understand what it *was* and why it mattered, since older contracts and other languages still have this risk.
- **`tx.origin` vs `msg.sender`:** `tx.origin` is the original human who started the transaction chain; `msg.sender` is whoever called this specific function directly (which could be another contract). Using `tx.origin` for authorization is a common bug that can be exploited via phishing-style contract tricks.
- **Static analysis:** Tools like **Slither** scan your contract code automatically and flag common vulnerability patterns before you ever deploy.

**Deliverable:** Work through a handful of levels of **Ethernaut** (a well-known set of intentionally vulnerable contracts you have to hack). Then take a contract you wrote earlier in the course, find a way to break it, and fix it.

---

### Week 6 — Advanced Contract Design

- **Proxies & upgradeability:** Once a contract is deployed, its code normally can't change. A proxy pattern gets around this: users interact with a fixed "proxy" address that forwards (delegates) all calls to a separate "logic" contract, which *can* be swapped out later. This is how teams fix bugs or add features to contracts that are already live.
- **Multi-sig & access control:** Instead of one private key controlling something valuable, require multiple approvals (e.g., 3 of 5 signers) before an action executes. Reduces the blast radius if any single key is compromised.
- **Contract-to-contract calls & oracles:** Contracts can call other contracts using interfaces (a description of what functions to expect) and low-level calls. But contracts can't natively access anything outside the blockchain — so if a contract needs a real-world price (e.g., ETH/USD), it relies on an **oracle** (like Chainlink) to bring that data on-chain.

**Deliverable:** Deploy an upgradeable contract using the proxy pattern, then deploy a new version of its logic and confirm the contract's stored data (state) is unchanged while its behavior has been upgraded.

---

### Week 7 — Scaling: Layer 2s & Gas

- **The scaling problem:** Ethereum's main network (Layer 1) can only process a limited number of transactions per second, and demand for block space drives fees up. This is often called the blockchain trilemma — trading off decentralization, security, and scalability.
- **Rollups (Layer 2):** Networks like Arbitrum, Base, and Optimism (optimistic rollups) or zkSync and Scroll (ZK rollups) process transactions off of Ethereum's main chain, then post a compressed summary back to Ethereum for security. Result: transactions that are much cheaper and faster, while still inheriting most of Ethereum's security guarantees. You don't need to implement rollup internals — just understand *why* they exist and the basic difference between the optimistic and ZK approaches (optimistic assumes transactions are valid unless challenged; ZK proves they're valid upfront using cryptographic proofs).
- **Gas optimization, briefly:** Packing variables efficiently, avoiding unnecessary storage writes, and using `immutable`/`constant` where values never change.

**Deliverable:** Deploy the same contract you built earlier to an L2 testnet, and compare the gas cost and confirmation time against deploying it on an L1 testnet. Write down the difference.

---

### Week 8 — Modern Infrastructure & Capstone

- **Indexing:** Querying a blockchain directly for historical data (e.g., "show me every transfer this contract has ever made") is slow and expensive at scale. Indexing services like **The Graph** continuously watch the chain, organize the data into a queryable database, and let your frontend fetch it instantly via GraphQL instead of hammering a node.
- **Account abstraction (ERC-4337):** Normal wallets (EOAs — Externally Owned Accounts) are just a key pair; they can't have custom logic like spending limits, social recovery, or letting someone else pay your gas fee. Smart accounts fix this by making the wallet itself a smart contract, opening the door to gasless transactions (a "paymaster" covers the fee) and other UX improvements. You don't need to build a bundler or paymaster from scratch — just understand the pieces (EntryPoint contract, UserOperations, Paymasters) and see a working demo.
- **Capstone:** Combine everything from the course into one small, complete project: a smart contract (with at least basic tests and a quick security self-review), a frontend that connects a wallet and interacts with it, and a short write-up explaining what it does and why you made the design choices you made.

**Deliverable:** A small, working, end-to-end project — deployed to a testnet, with a frontend — that you could realistically submit at a hackathon.

---

## Core Tooling Stack

| Layer | Tool | What it's for |
| --- | --- | --- |
| Smart contract framework | **Foundry** | Writing, testing, and deploying contracts from the command line. Fast, and includes fuzz testing built in. |
| Smart contract language | **Solidity** | The standard language for Ethereum-compatible contracts. |
| Frontend | **Next.js / Vite + React** | Building the website that talks to your contract. |
| Client library | **Viem** (or Ethers.js) | Lets your frontend read from and write to the blockchain without hand-crafting raw RPC calls. |
| Wallet connection | **RainbowKit** | Handles the "connect wallet" button and multi-wallet support so you don't build it from scratch. |
| Security scanning | **Slither** | Automatically flags common vulnerabilities in your contract code. |
| Indexing (Half 2 only) | **The Graph** | Makes historical on-chain data queryable instead of scanning the whole chain yourself. |

---

## Ground Rules

1. **Understand before you copy.** If you can't explain what a line of code does, don't ship it — this applies doubly to anything imported from a library.
2. **Testnet first, always.** Never deploy something you haven't tested locally and on a testnet.
3. **No frontend before your contract works from the command line.** You should be able to deploy and call a contract using `cast` before you ever build UI around it.
4. **Every contract gets at least a basic test.** An untested contract is an unfinished contract.
5. **Treat every external call as a potential attack.** By Week 5, this should be instinct, not something you have to consciously remember.
