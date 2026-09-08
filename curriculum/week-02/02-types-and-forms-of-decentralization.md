# Topic 2: Types & Forms of Decentralization

## Start here: a question, not a definition

Is Ethereum decentralized? Most people answer with a confident yes or no. Here's why that's the wrong shape of answer: decentralization isn't one property a system either has or doesn't — it's several separate, independent measurements, and a system can score high on one and low on another at the same time. Before naming those measurements, let's find one where your intuition gets surprised.

## Notice it, before we name it

Ethereum runs on thousands of independently operated nodes, spread across the world, run by individuals, universities, companies, and hobbyists who mostly don't know each other. That sounds about as decentralized as it gets.

Now notice something else: at any given moment, all of those thousands of independent nodes agree on **one single, shared version of the truth** — one balance for your wallet, one state for every contract, no ambiguity, no "which copy is real." If you split the entire network in half — half the nodes on one side of the planet, half on the other, for one second — both halves would still be trying to agree on the exact same single ledger, not maintaining two independent, divergent ones. Functionally, the network behaves like *one giant, unified computer*, not like a loose federation of separate ones.

That's genuinely strange, once you notice it: thousands of independent operators, zero central authority — and yet the *system's behavior* is as unified and monolithic as if one company ran it.

## Now it has a name

This is exactly the distinction Ethereum co-founder Vitalik Buterin laid out in a widely-cited 2017 essay, ["The Meaning of Decentralization"](https://medium.com/@VitalikButerin/the-meaning-of-decentralization-a0c92b76a274) — three separate axes, and a system's score on one tells you almost nothing about its score on another:

1. **Architectural decentralization** — how many physical computers make up the system, and how many could fail before the whole thing breaks? Ethereum: thousands of independently run nodes; losing a large fraction changes nothing. Highly architecturally decentralized.
2. **Political decentralization** — how many individuals or organizations ultimately control those computers? If three mining pools (or a handful of large staking operators, under Proof of Stake) control the majority of block production, that's a much smaller number of decision-makers than the raw node count suggests — this is exactly the vulnerability behind the real 51%-attack case study from Week 1's consensus topic.
3. **Logical decentralization** — does the system behave like one unified object, or like an amorphous swarm of independent pieces that could keep functioning if split in half? Blockchains, as you just noticed above, are **logically centralized** — one agreed-upon state, one "truth" — even while being architecturally and (ideally) politically decentralized.

That third one is the genuinely surprising result: **a blockchain is decentralized in who runs it and who controls it, but centralized in how it behaves** — one unified ledger, not many independent ones. Buterin's own conclusion is worth sitting with directly: these three axes are largely independent of each other, and treating "decentralized" as one single yes/no property collapses a real, useful distinction.

## Check your understanding

Bitcoin mining is heavily concentrated — historically, a handful of large mining pools have controlled the majority of total hash power at various points. Does that make Bitcoin "centralized"?

...

Not architecturally — there are still thousands of independent nodes verifying the chain, and anyone can run one. But it does mean Bitcoin can be, at times, **less politically decentralized** than the raw node count alone would suggest, since a small number of pool operators control an outsized share of block-production decisions. This is precisely why being specific about *which axis* you mean matters — "Bitcoin is decentralized" and "Bitcoin's mining is politically concentrated" can both be true statements about the same network at the same time.

## Connect it: forms of decentralization in practice

Once you have this vocabulary, you can spot the same underlying idea applied to different problems:

- **Decentralized finance (DeFi)** — lending, trading, and borrowing without a bank as the central party; smart contracts (Topic 4) hold the funds and enforce the rules instead.
- **Decentralized storage** (IPFS, Filecoin) — files distributed and addressed by their content hash (a direct callback to Week 1's Topic 01) across many independent storage providers, instead of living on one company's servers.
- **Decentralized identity** — proving facts about yourself (age, credentials, membership) without a single company or government database being the sole authority that can revoke or alter the record.
- **DAOs** — organizations whose decision-making itself is decentralized, not just their infrastructure. This is significant enough to be its own topic, next.

## Real-world uses

- **The federated email example from Topic 1** is a clean illustration of Buterin's framework applied outside crypto entirely: SMTP is architecturally decentralized (anyone can run a mail server) but has become politically concentrated in practice (a handful of providers handle most real-world traffic) — exactly the kind of mismatch this framework is built to describe precisely.
- **Content Delivery Networks (CDNs)** are architecturally distributed across the globe but politically centralized — a handful of companies (Cloudflare, Akamai, AWS) run most of the internet's CDN infrastructure, meaning a decision by one of them can take large parts of the web offline, as has happened during real outages.

## Common misconceptions

- **"A blockchain being 'logically centralized' contradicts it being decentralized."** It doesn't — it's a different axis entirely. A unified, agreed-upon ledger is actually the *point*: it's what lets a decentralized network avoid the "which copy is real" problem that plagues systems without consensus (Week 1, Topic 04).
- **"More nodes always means more decentralized."** Only along the architectural axis. If those nodes are run by a small number of organizations, or a handful of parties control the majority of mining/staking power, political decentralization can be low even with a high node count.

## Recommended videos

- [What is a DAO in Crypto? (Decentralized Autonomous Organization)](https://www.youtube.com/watch?v=KHm0uUPqmVE) — previews Topic 3, but also touches on why decentralized *decision-making*, not just infrastructure, matters.

## Where to read more

- Vitalik Buterin, ["The Meaning of Decentralization"](https://medium.com/@VitalikButerin/the-meaning-of-decentralization-a0c92b76a274) — the original essay this topic is built on. Short, and worth reading in full.

## Practice

1. Pick any blockchain network (Bitcoin, Ethereum, or one you've heard of) and rate it, in your own words, on all three axes — architectural, political, logical. Justify each rating with a specific fact, not a vibe.
2. Apply the same three-axis framework to a non-blockchain system from Topic 1's "real-world uses" (DNS, open-source development, or email) — where does it score high, and where does it score surprisingly low?

## Take-home

**Written (5–6 sentences):** Using Buterin's three axes, explain why "is X decentralized?" is often the wrong question to ask about a real system — and rewrite it as three more precise questions someone could actually answer with evidence.
