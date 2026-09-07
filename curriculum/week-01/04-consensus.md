# Topic 4: Consensus

## The plain-language explanation

You now understand hashing (Topic 1), signing (Topic 2), and how blocks chain together (Topic 3). There's one piece left, and it's arguably the most important: **who decides which block gets added next, and how does everyone agree on it?**

There is no central server for a public blockchain. Thousands of independent computers around the world (called **nodes**) each keep their own copy of the entire chain. Nobody is in charge. So a real problem exists: how do you get thousands of strangers — some of whom might be dishonest, some of whom might have unreliable internet connections, none of whom trust each other — to agree on a single, shared version of "what happened," in the right order, without a bank or government sitting in the middle to make the final call?

This is called the **consensus problem**, and the specific set of rules a blockchain uses to solve it is called its **consensus mechanism**. The two you'll hear about most are **Proof of Work (PoW)** and **Proof of Stake (PoS)**.

### Proof of Work (PoW)

Used by Bitcoin (and, until 2022, by Ethereum). The rule: to earn the right to add the next block, a node (called a **miner**) has to solve a computational puzzle requiring huge amounts of brute-force guessing — repeatedly trying random numbers until one, combined with the block's data, produces a hash meeting a specific difficulty requirement (e.g., "starts with a certain number of zeros" — this connects directly back to the unpredictability property of hashing from Topic 1). This is deliberately expensive: it costs real electricity and real hardware.

The key asymmetry that makes it work: **solving the puzzle is extremely hard, but *verifying* someone else's solution is instant.** Any other node can immediately check "does this hash actually meet the difficulty requirement?" — a simple, fast recalculation. Miners can't fake a solution, and honest nodes don't have to do expensive work themselves just to confirm someone else did theirs.

Bitcoin targets a new block roughly every **10 minutes**, and automatically adjusts the puzzle's difficulty every **2,016 blocks** (about two weeks) to keep that pace steady, regardless of how much total computing power joins or leaves the network. A miner who successfully finds a valid block is rewarded with newly created coins plus transaction fees — and if they tried to cheat (e.g., including a fraudulent transaction), every other node would simply reject their block as invalid, wasting all that electricity for nothing. Honesty is the only strategy that reliably pays off.

### Proof of Stake (PoS)

Used by Ethereum since September 2022, and most newer blockchains. Instead of spending electricity, a node (called a **validator**) has to lock up (**"stake"**) a large amount of the network's own currency as collateral — for Ethereum, exactly **32 ETH** per validator. Validators are then randomly selected, roughly in proportion to how much they've staked, to propose and approve new blocks.

The economic logic is different but achieves the same goal: if a validator acts dishonestly — proposing an invalid block, or trying to approve two conflicting versions of history at once — the network can detect it and **"slash"** (destroy) a portion of their staked funds as a penalty. So instead of "cheating wastes your electricity," it's "cheating destroys your own deposited money." Either way, the system is designed so honest behavior is always the financially rational choice.

## Worked example: the math behind "how many bad actors can a network tolerate?"

This is a real, well-established result from distributed systems research (not specific to blockchain), sometimes called the **n ≥ 3f + 1** rule: a network of `n` nodes can reach reliable agreement even if up to `f` of them are faulty or actively malicious, as long as `n` is at least `3f + 1`. In other words, **the honest nodes need to outnumber the dishonest ones by more than 2-to-1**, not just a simple majority.

| Total nodes (n) | Max tolerable bad actors (f) | Why |
| --- | --- | --- |
| 4 | 1 | 4 ≥ 3(1) + 1 = 4 ✓ |
| 10 | 3 | 10 ≥ 3(3) + 1 = 10 ✓ |
| 100 | 33 | 100 ≥ 3(33) + 1 = 100 ✓ |

This is why you'll hear blockchain security discussed in terms of "51% attacks" or "the honest majority assumption" — it's a direct, practical application of this formula. If dishonest participants (or a single actor controlling many participants) cross roughly this threshold of the network's total mining power (PoW) or staked funds (PoS), they can start rewriting recent history.

### A real, documented case: what actually happens when this threshold is crossed

This isn't hypothetical. **Ethereum Classic (ETC)**, a smaller blockchain related to Ethereum, suffered multiple confirmed 51% attacks:

- **January 2019:** An attacker gained majority control of ETC's mining power and used it to reverse recent transactions, double-spending funds sent to exchanges — an estimated **$1.1 million** in losses.
- **July 31, 2020:** A second attack reorganized the chain, enabling roughly **$5.8 million** in double-spent transactions.
- **August 5, 2020:** A third attack days later added roughly **$3.2 million** more in double-spent transactions, and ETC's price fell over 30% within 48 hours of the incident becoming public.

The mechanism in every case was the same: the attacker sent funds to an exchange (getting something of value in return — e.g., trading the ETC for another currency, then withdrawing it), then used their majority mining power to secretly build an alternative version of the chain that never included that payment, and released it once it was longer than the honest chain. Network rules say the longest valid chain wins, so the honest chain got discarded, and the "spent" funds reappeared in the attacker's wallet — meaning they'd effectively spent the same coins twice.

**What this attack could and could not do** is an important distinction: the attacker could rewrite *recent* history (their own transactions) because they controlled block production. They could **not** forge a signature for funds they never controlled, and they could **not** touch other users' unrelated wallets — the private-key math from Topic 2 held perfectly throughout. A 51% attack breaks the "who got here first" ordering, not the cryptography itself.

## Real-world use cases: consensus is a much older, more general problem than blockchain

Blockchain didn't invent the consensus problem — it applied an old field of distributed-systems research to a new, adversarial setting (strangers on the internet, some possibly malicious) rather than the older setting (a company's own servers, assumed mostly trustworthy but sometimes failing).

1. **Distributed databases and infrastructure you've probably already used.** Kubernetes — the system many companies use to run their production software — relies on a component called **etcd** to keep cluster configuration consistent across multiple servers, even if some crash or lose network connectivity. etcd uses a consensus algorithm called **Raft**, designed to solve a milder version of the same problem this topic covers (agreement despite failures, though typically *not* assuming actively malicious participants, unlike blockchain).
2. **Globally distributed databases.** Systems like Google Spanner and CockroachDB use consensus algorithms (in the **Paxos** family, a close relative of Raft) to keep data consistent across data centers on different continents, so that a bank balance or inventory count reads the same correct value no matter which server answers the query.
3. **Safety-critical redundant systems.** The original research into Byzantine fault tolerance (the 1982 paper that coined the "Byzantine Generals" framing you'll read about below) was motivated partly by aircraft flight-control computers: multiple redundant sensors and processors have to agree on readings like altitude or airspeed even if one unit is feeding bad data, because acting on a wrong majority decision could be catastrophic. Blockchain consensus and aircraft safety systems are, at the conceptual level, solving relatives of the exact same problem.
4. **Leader election.** Any time a cluster of servers needs to agree on which one is currently "in charge" (e.g., a primary database node after a failure), it's running some form of consensus algorithm to make that decision reliably.

## Real-life example: the Byzantine Generals Problem

This is the classic thought experiment computer scientists use to describe the exact problem consensus solves. Imagine several army generals, each commanding their own division, surrounding an enemy city from different directions. They can only coordinate by sending messengers back and forth. They must all agree to attack at the same time, or all agree to retreat — because if only some generals attack while others retreat, the attack fails and lives are lost.

The problem: messengers might be delayed or lost, or — worse — one or more generals might secretly be traitors, deliberately sending different messages to different generals to sabotage the agreement (telling General A "attack at dawn" and General B "retreat at dawn"). How do the loyal generals still reach a reliable, shared decision, despite unreliable communication and the possibility that some participants are actively lying?

This is exactly the situation a blockchain network is in: independent nodes, no central coordinator, unreliable networks, and some participants who might be actively malicious. PoW and PoS are two different, practical answers to "how do the honest majority still reach agreement anyway" — PoW by making dishonesty computationally and financially expensive, PoS by making it financially self-destructive.

## Common misconceptions

- **"Proof of Stake is just Proof of Work without the hardware — same idea, less energy."** The mechanics are genuinely different, not just a hardware swap. PoW's security comes from *external, sunk cost* (electricity you can't get back regardless of outcome). PoS's security comes from *internal, at-risk collateral* (money the protocol itself can destroy if you misbehave, called slashing). These create different attack economics and different recovery properties after an attack.
- **"A 51% attack lets you steal anyone's funds."** As shown in the Ethereum Classic case above, an attacker with majority control can rewrite *recent* transaction ordering and double-spend *their own* recently sent funds — they cannot forge a valid signature for a wallet they don't control, and cannot touch coins secured by a private key they don't have. The Topic 2 cryptography stays intact even during a successful consensus attack.
- **"More decentralized always means more secure."** More independent, honest participants raises the `f` an attacker would need to compromise — but a network can be technically "decentralized" (many nodes) while still being economically concentrated (a few entities controlling most of the mining power or staked funds), which is closer to what actually matters for the `n ≥ 3f + 1` math above.

## Recommended videos

- [Crypto Whiteboard: Proof of Work vs Proof of Stake](https://www.youtube.com/watch?v=53QAkq3YT-8) — a direct side-by-side comparison, explained visually, aimed at beginners.
- [What is Proof of Stake - Explained in 3 Minutes (Animation)](https://www.youtube.com/watch?v=z4Runk0on50) — short and animated, good as a quick recap after the first video.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/distributed](https://andersbrownworth.com/blockchain/distributed)** — simulates multiple peer nodes on a network, lets you "mine" a block on one node and watch it propagate, and lets you introduce a rogue/invalid block on one node to see how the rest of the network rejects it.

## Practice (do this now, takes ~15–20 minutes)

1. Open the Anders Brownworth distributed demo. Add a couple of peer nodes.
2. Mine a new block on one node and watch how it propagates (or fails to) to the other peers.
3. Try tampering with a block on one "rogue" peer, and observe how the rest of the network treats that peer's version as invalid.
4. Using the `n ≥ 3f + 1` table above, work out by hand: for a network of 31 nodes, what is the maximum number of dishonest nodes it can tolerate? Check your answer against the formula.

## Take-home assignment

1. **Written (6–8 sentences):** In your own words, explain the Byzantine Generals Problem, and then explain how *either* PoW or PoS (your choice) addresses it.
2. **Case study analysis (5–8 sentences):** Using the Ethereum Classic 51% attacks described in this doc, explain in your own words what the attacker was actually able to do, and — just as importantly — what they were *not* able to do. Be specific about why the cryptography from Topic 2 remained secure even while consensus was being attacked.
3. **Real-world use case (5–6 sentences):** Pick one non-blockchain use case from this doc (Kubernetes/etcd, distributed databases, or safety-critical redundant systems) and explain, in your own words, what would go wrong for that system if it had no consensus mechanism at all.
4. **Comparison table:** In your own words, list at least 3 concrete differences between Proof of Work and Proof of Stake — what resource is being risked, how a bad actor gets punished, and what the real-world cost of running a node looks like for each.
