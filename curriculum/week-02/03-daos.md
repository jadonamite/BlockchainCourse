# Topic 3: DAOs — Decentralization You Can Actually Join

## Start here: a question, not a definition

You now have real vocabulary for decentralization as a property of *infrastructure* and *control*. Here's the next question: what does an actual **organization** look like if it's decentralized from the ground up — no CEO, no board of directors, no small group of people who alone can move the treasury? Is that even possible, or just a slogan?

## Notice it, before we name it

In 2016 — with Ethereum barely a year old — a group built exactly this, and called it, simply, **"The DAO."** It was a decentralized venture fund: anyone could send ETH to its smart contract in exchange for voting tokens, and token holders would then vote on which projects the pooled funds should invest in. No company, no fund manager with sole signing authority over a bank account — the rules for moving money were written directly into a smart contract, and enforced by the network, not by trusting a person.

It worked, at first, remarkably well: The DAO raised roughly $150 million worth of ETH (about 3.6 million ETH) from thousands of independent contributors — at the time, one of the largest crowdfunding events in history, coordinated entirely without a company.

Then, in June 2016, an attacker found a bug in The DAO's smart contract — a **reentrancy vulnerability** (you'll learn this exact bug class in depth in Week 6) that let them repeatedly call a withdrawal function before their balance was updated, draining roughly 3.6 million ETH — the majority of the fund — into an account the attacker controlled.

Here's the part that makes this the right case study for this exact moment in the course: **there was no customer support line to call, and no company that could just reverse the transaction.** The code had done exactly what it was written to do — nobody had lied, forged a signature, or broken consensus. The rules, as written, allowed it. The Ethereum community faced a genuine, contentious choice: let the theft stand because "the code is the law," or intervene at the protocol level to reverse it. They chose to intervene, executing a **hard fork** that effectively rewrote recent history to return the funds to their original owners. The chain that adopted this fork continued as **Ethereum (ETH)**. A minority who rejected the intervention — on the principle that a blockchain's history should never be rewritten, no matter how sympathetic the reason — kept running the original, unaltered chain, which became **Ethereum Classic (ETC)**.

If that name sounds familiar: it's the exact same Ethereum Classic from Week 1's consensus topic, where you read about its real, documented 51%-attacks in 2019 and 2020. Its origin story *is* this event.

## Now it has a name

A **DAO (Decentralized Autonomous Organization)** is an organization whose core rules — who can spend shared funds, how decisions get made, what counts as approval — are written into smart contracts and enforced by the network, rather than by a person or a legal entity with unilateral authority. Membership and voting power are usually determined by holding a token; proposals are made and voted on, often entirely on-chain; and execution of an approved proposal (like releasing funds) can happen automatically once a vote passes, with no human required to press the final button.

## Check your understanding

If a DAO's smart contract has a bug, can "the DAO" — as an organization — just decide to pause it and patch the bug, the way a normal company could pull a broken feature overnight?

...

**Not unless that exact capability was deliberately built into the contract in advance** — a pause function, an upgrade mechanism, an emergency multi-sig override. This is precisely why The DAO's exploit couldn't simply be "undone" through ordinary means: the contract had no built-in way to freeze itself or claw funds back, because nobody had anticipated needing one. Fixing it required the drastic, deeply contentious step of changing the blockchain itself — which is a decision far outside any single DAO's own power, and exactly why it split the community.

## Connect it

The DAO is the cautionary origin story, but DAOs didn't stop there — they're a real, functioning organizational form today:

- **Uniswap DAO** — token holders vote on changes to the Uniswap protocol, including fee structures, using UNI tokens as voting power.
- **MakerDAO** — governs the risk parameters (collateral types, stability fees) backing the DAI stablecoin, entirely through on-chain governance votes.
- **Grants and treasury DAOs** — pool funds and vote on which projects or contributors to fund, a direct descendant of The DAO's original crowdfunded-investment-fund idea, just with the hard lessons about security (Week 6) baked in.

## Real-world uses (beyond crypto-native organizations)

- **Open-source foundations** (like the Apache Software Foundation) already use *some* decentralized-governance ideas — distributed voting among maintainers — without blockchain enforcement; DAOs are, in part, an attempt to make that kind of governance cryptographically enforceable rather than dependent on goodwill and bylaws.
- **Cooperative businesses** (worker co-ops, credit unions) share DAOs' basic premise — decisions made collectively by members rather than a small ownership class — DAOs are a blockchain-native, automatically-enforced version of a much older organizational idea.

## Common misconceptions

- **"A DAO means there's no leadership or structure at all."** In practice, most real DAOs still have core contributor teams, foundations, or multisig signers handling day-to-day execution — "decentralized" describes how major decisions and fund custody work, not necessarily the absence of any coordination at all.
- **"The DAO hack proves DAOs don't work."** It proved that *this specific, early, unaudited smart contract* had a bug — the same way one company going bankrupt doesn't prove companies don't work. It became the reason smart contract security (Week 6) is now treated as a first-class discipline rather than an afterthought.

## Recommended videos

- [What is a DAO in Crypto? (Decentralized Autonomous Organization)](https://www.youtube.com/watch?v=KHm0uUPqmVE)
- [Explained: What Is A DAO? | Crypto 101](https://www.youtube.com/watch?v=I4v5nrBLYuw)

## Practice

1. Look up one real, currently active DAO (Uniswap, MakerDAO, or any other) and find one real governance proposal it voted on. Write down what was proposed, and what the outcome was.
2. Write a one-paragraph timeline of The DAO, in your own words, from launch to the ETH/ETC split — without copying any single source.

## Take-home

**Written (6–8 sentences):** Explain, in your own words, why The DAO's exploit created a genuine philosophical disagreement (not just a technical problem) within the Ethereum community — and which side of "code is law" vs. "intervene to fix an obvious wrong" you find more convincing, with a reason.
