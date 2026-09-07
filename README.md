# Blockchain Curriculum: From EVM Fundamentals to Production dApps

A realistic blockchain curriculum must prioritize practical engineering over hype. Most newcomers fall into the trap of memorizing buzzwords or copy-pasting unverified Solidity templates without understanding EVM execution, state transitions, security trade-offs, or client-side wallet plumbing.

This is an end-to-end framework — complete with clear objectives, a 16-week modular roadmap, and practical deliverables — built to produce competent, hireable Web3 developers.

---

## Program Objectives

By the end of this track, students will be able to:

1. **Explain the underlying mechanics:** Understand cryptographic primitives (hashing, public-key cryptography, Merkle trees), distributed consensus, and state machines without resorting to analogies.
2. **Write & test secure smart contracts:** Develop, unit-test, and deploy robust smart contracts using modern toolchains (Foundry/Hardhat) while adhering to defensive design patterns.
3. **Build production-grade dApps:** Connect on-chain contracts to modern web interfaces using industry-standard client libraries, handle asynchronous transaction lifecycles, and implement seamless wallet onboarding.
4. **Audit and secure code:** Identify classic vulnerabilities (reentrancy, access control flaws, arithmetic errors, oracle manipulation) and write fuzz/invariant tests.
5. **Navigate modern architectures:** Understand Layer 2 rollups, gas optimization, smart accounts (ERC-4337), and indexing infrastructures.

---

## 16-Week Curriculum & Roadmap

### Phase 1: Cryptographic Foundations & Distributed State (Weeks 1–3)

*Objective: Strip away the financial hype and analyze blockchains as deterministic, append-only, distributed state machines.*

**Week 1: Core Mechanics & Cryptography**
- SHA-256, Keccak-256, and collision resistance.
- Public-key cryptography: Elliptic Curve Digital Signature Algorithm (ECDSA), keypairs, and address derivation.
- Data structures: Linked lists, Patricia/Merkle Trees, and cryptographic state verification.
- *Deliverable:* A small CLI script (Node.js/Python) that hashes blocks into a linked chain, signs transactions with an ECDSA private key, and validates Merkle proofs.

**Week 2: Consensus Models & Network Topologies**
- Peer-to-peer gossip protocols and node operations.
- Proof of Work (PoW) vs. Proof of Stake (PoS), validator duties, slashing, and finality.
- Transaction mempools, nonces, base fees, and priority tips (EIP-1559).
- *Deliverable:* Run a local testnode (e.g., Anvil, Geth dev mode) and manually construct, sign, and broadcast raw RPC transactions using `cURL`.

**Week 3: The EVM Architecture**
- Bytecode vs. opcodes, the program counter, stack, memory, storage slots, and calldata.
- Gas metering mechanics: execution costs, storage read/write costs, and out-of-gas errors.
- *Deliverable:* Dissect a compiled contract's bytecode into raw opcodes, mapping variables directly to their 32-byte storage slots.

---

### Phase 2: Smart Contract Engineering with Foundry (Weeks 4–7)

*Objective: Build production-ready, defensively programmed smart contracts using an industry-grade testing framework.*

**Week 4: Solidity Syntax & Data Modeling**
- Types, visibility modifiers, storage layouts, arrays, mappings, structs, and custom errors.
- Special variables: `msg.sender`, `msg.value`, `block.timestamp`, and `tx.origin` (and why to avoid it).
- Setting up **Foundry** (`forge`, `cast`, `anvil`) for high-speed compilation and testing.
- *Deliverable:* Build and deploy a multi-signature treasury contract from scratch with custom events and error handling.

**Week 5: Standards & Composable Architecture**
- Token specifications: ERC-20 (fungible), ERC-721 (NFTs), and ERC-1155 (multi-token).
- OpenZeppelin library: Inheriting `Ownable`, `AccessControl`, and `ReentrancyGuard`.
- Contract-to-contract interactions: Interfaces, `staticcall`, and low-level calls.
- *Deliverable:* Build a decentralized crowdfunding vault that accepts ERC-20 tokens, tracks milestone pledges, and enforces refund windows.

**Week 6: Testing & Gas Optimization**
- Unit testing, fork testing against mainnet state, and mocking oracles.
- Property-based fuzz testing and invariant testing in Foundry.
- Gas profiling: Packing variables, `immutable`/`constant`, cached storage reads, and avoiding custom errors vs. long revert strings.
- *Deliverable:* Write a suite of 20+ unit and fuzz tests achieving >95% code coverage for the crowdfunding contract.

**Week 7: Upgradeability & Advanced Design Patterns**
- Proxy patterns: EIP-1967, Transparent Proxies vs. Universal Upgradeable Proxy Standard (UUPS).
- Fallback functions, delegate calls, and storage collision prevention.
- Factory contracts and minimal clones (ERC-1167).
- *Deliverable:* Deploy an upgradeable contract via UUPS, upgrade its logic, and demonstrate state persistence across versions.

---

### Phase 3: Full-Stack dApp Engineering (Weeks 8–11)

*Objective: Bridge contract backends with responsive, resilient client frontends.*

**Week 8: Client-Side Web3 Tooling**
- JSON-RPC endpoints, Alchemy/Infura infrastructure, and public nodes.
- Interacting with the blockchain via modern TypeScript libraries (Viem, Wagmi, or Ethers.js).
- ABIs, typed contract hooks, and encoding calldata.
- *Deliverable:* A reactive TypeScript dashboard that reads contract states, decodes complex events, and monitors wallet balances in real time.

**Week 9: Wallet Integration & Onboarding**
- Injected providers (EIP-1193), browser extensions, and mobile wallets.
- Multi-wallet connection kits (RainbowKit, AppKit, or Privy).
- Network switching, chain configuration, and handling connection rejects.
- *Deliverable:* Implement an end-to-end authentication and wallet connection modal that gracefully handles chain-switching between testnets.

**Week 10: Asynchronous Transaction Lifecycles & UX**
- Managing optimistic UI states, pending hashes, confirmations, and transaction failures.
- Off-chain message signing: EIP-712 typed structured data.
- Off-chain storage: IPFS, Arweave, and pinning metadata for decentralized assets.
- *Deliverable:* Complete dApp frontend enabling users to mint dynamic metadata assets pinned to IPFS, signed via EIP-712.

**Week 11: Data Indexing & Querying**
- The latency of raw RPC querying vs. specialized indexing.
- Building and deploying subgraphs with The Graph or using Goldsky/Envio.
- Integrating GraphQL queries into frontend interfaces.
- *Deliverable:* Build a custom subgraph to index deposits, withdrawals, and user activity for your Week 5 protocol, displaying them in a paginated frontend table.

---

### Phase 4: Security, L2 Scaling, & Modern Ecosystems (Weeks 12–14)

*Objective: Harden code against real-world exploits and adapt to modern production architectures.*

**Week 12: Smart Contract Security & Common Attack Vectors**
- Classic vulnerabilities: Reentrancy, integer overflow/underflow, access control bypass, tx.origin spoofing, and front-running/MEV.
- Oracle manipulation and flash loan mechanics.
- Static analysis tools: Slither, Mythril, and automated CI/CD security linters.
- *Deliverable:* Complete a curated "Capture The Flag" (CTF) security challenge (e.g., Damn Vulnerable DeFi or Ethernaut levels).

**Week 13: Layer 2 Networks, Rollups & Bridges**
- Scaling challenges: The blockchain trilemma, state bloat, and execution bottlenecks.
- Optimistic rollups (Arbitrum, OP Stack, Base) vs. Zero-Knowledge rollups (Scroll, zkSync, Starknet).
- Bridging fundamentals, cross-chain messaging, and rollup transaction life cycles.
- *Deliverable:* Deploy and verify an existing contract onto an L2 testnet, measuring gas costs and confirmation latencies against L1.

**Week 14: Account Abstraction (ERC-4337) & Smart Accounts**
- Externally Owned Accounts (EOAs) vs. Smart Contract Wallets.
- The ERC-4337 architecture: Bundlers, EntryPoint contract, UserOperations, and Paymasters.
- Gasless transactions, session keys, and passkey authentication.
- *Deliverable:* Execute a sponsored, gasless transaction where a paymaster covers the user's gas fee.

---

### Phase 5: Capstone Project & Portfolio Production (Weeks 15–16)

*Objective: Build an audit-ready, full-stack decentralized application suitable for a professional portfolio.*

**Weeks 15–16: Full Protocol Development**

Teams or individual students design, write, test, audit, and deploy a complete protocol.

**Requirements:**
1. Smart contracts with >90% test coverage using Foundry (unit + invariant tests).
2. Comprehensive technical documentation (architecture diagram, threat model, spec).
3. Fully functional frontend with multi-wallet support and optimistic state management.
4. Verified contracts deployed on a major L2 testnet/mainnet.
5. Integrated indexing (Subgraph) or event listener backend.

**Project Ideas:** Automated decentralized escrow, on-chain peer-to-peer payment switch with passkey support, collateralized lending pool, or dynamic on-chain game engine.

---

## Core Tooling Stack

| Layer | Recommended Tools | Why It Matters |
| --- | --- | --- |
| **Smart Contract Framework** | **Foundry** | Native Solidity testing, blazingly fast execution, built-in fuzzing and trace debugging. |
| **Smart Contract Language** | **Solidity (0.8.20+)** | Primary industry standard for EVM protocols. |
| **Frontend Framework** | **Next.js / Vite + React** | Modern SSR/SPA workflows standard across Web3 engineering teams. |
| **Client Web3 Libraries** | **Viem + Wagmi** | Modern, lightweight, typesafe EVM client libraries that outperform legacy alternatives. |
| **Wallet Layer** | **RainbowKit or Privy** | Streamlined developer experience for multi-wallet onboarding, social logins, and passkeys. |
| **Data Indexing** | **The Graph or Envio** | Avoids hammering raw RPC nodes for historical logs and relational queries. |
| **Static Analysis** | **Slither** | Industry standard for automated vulnerability scans prior to deployment. |

---

## Ground Rules to Keep Students from "Chasing Shadows"

1. **No Frontend Before Solidity Competence:** Students must understand the contracts they interact with. Do not touch UI code until contracts can be compiled, deployed, and tested via the command line.
2. **Foundry Over Browser IDEs:** Limit browser tools (like Remix) to the first 3 days for fast visual syntax checks. Move students immediately to standard local terminal workflows (Git, VS Code, Foundry).
3. **Zero Deployments Without Automated Tests:** If a contract has no automated tests, it is considered broken. Every PR must pass automated CI tests before being deployed to a testnet.
4. **Security by Default:** Teach students to treat any untrusted contract call as a potential exploit vector. Reentrancy and access checks should become second nature.
5. **No Memorization of Template Code:** For every OpenZeppelin contract they import, they must be able to read and explain the underlying library logic.
