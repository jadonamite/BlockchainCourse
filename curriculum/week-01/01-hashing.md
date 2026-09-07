# Topic 1: Hashing

## The plain-language explanation

A **hash function** is a mathematical function that takes *any* input — a single letter, a word, an entire movie file — and turns it into a fixed-length string of letters and numbers, called a **hash** (or "digest"). For blockchain, the specific hash function that matters most is called **SHA-256** (used by Bitcoin) or **Keccak-256** (used by Ethereum), but they both work the same way conceptually.

A hash function has three properties that matter enormously, and it's worth sitting with each one:

1. **Deterministic.** The same input *always* produces the exact same output. Hash the word "hello" today, tomorrow, or on a different computer on the other side of the planet — you get the identical hash every time. There's no randomness involved.

2. **One-way.** Given a hash, there is no way to work backwards to figure out what the original input was, other than guessing inputs and hashing them until you get a match (which, for anything non-trivial, would take longer than the age of the universe). This is why it's sometimes called a "trapdoor" — easy to fall through in one direction, essentially impossible to climb back up.

3. **Avalanche effect.** Changing even a single character of the input — even just flipping one letter's capitalization — produces a completely different, unrecognizable hash. There's no "partial similarity" between the hashes of similar inputs. This is the property that makes tampering detectable: if a hash doesn't match, *something* changed, even if it's just one character.

There's a fourth property, **collision resistance**, which means it should be practically impossible to find two different inputs that produce the same hash. This is what makes a hash trustworthy as a stand-in for the original data — if I show you a hash, you can be confident it corresponds to one specific piece of data, not several.

### Why blockchain cares about this at all

A blockchain is, at its core, a very long list of data (transactions, grouped into blocks) where **each block contains the hash of the block before it.** That's the entire trick. Because of the avalanche effect, if anyone tries to secretly edit an old transaction, the hash of that block changes completely — which breaks its link to the next block, whose hash was calculated *including* the old (now-wrong) hash. The tampering becomes immediately, mathematically obvious. You don't have to trust anyone's word for it — you just recompute the hash and check.

## Real-life analogy

Think of a hash like a **tamper-evident wax seal** on an old letter. The seal itself doesn't tell you what's written inside the letter — you can't "reverse" a wax seal back into the words of the letter (one-way). But if someone opens the letter, changes even one word, and reseals it, the new seal will look completely different from the original (avalanche effect). Anyone who kept a record of what the original seal looked like can instantly tell the letter was tampered with, even without reading a single word of it.

Or, more simply: it's like a **fingerprint**. Your fingerprint doesn't let a stranger reconstruct your face (one-way), the same finger always leaves the same print (deterministic), and no two people share a fingerprint (collision resistance) — but if someone shows you a fingerprint, you can instantly *verify* whether it matches a specific person.

## Recommended videos

- [How does SHA-256 work? (full explanation)](https://www.youtube.com/watch?v=PbFVTb7Pndc) — the best single overview: what SHA-256 is, why it matters, and how it works under the hood, without assuming prior crypto background.
- [What is SHA-256 | Blockchain | The Beginner Guide](https://www.youtube.com/watch?v=ds655t9KZc0) — slower-paced, more example-driven, good if the first video moves too fast.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/hash](https://andersbrownworth.com/blockchain/hash)** — an interactive SHA-256 calculator built exactly for this. Type anything into the "Data" box and watch the hash recompute *live* as you type. This is the single fastest way to *feel* the avalanche effect instead of just reading about it.
- **[CyberChef](https://gchq.github.io/CyberChef/)** — a free browser-based tool (built by the UK's GCHQ, widely used by security professionals) that can hash text using SHA-256 and many other algorithms. Slightly more advanced UI, but useful once you want to experiment beyond simple text — e.g., hashing multiple lines, or comparing SHA-256 against other hash types.

## Practice (do this now, takes ~15 minutes)

1. Go to the Anders Brownworth hash demo. Type your first name into the "Data" field. Note the resulting hash.
2. Change just one letter (e.g., capitalize the first letter, or add a period). Note that the entire hash changed — not just part of it.
3. Type your name again, exactly as the first time. Confirm you get the *exact same* hash as step 1 (determinism).
4. Open CyberChef, drag the "SHA2" operation into the recipe area, and hash the phrase `Hello World`. Note the output. Now hash `hello World` (lowercase h) and compare — completely different, even though only one letter changed case.

## Take-home assignment

1. **Written (5–6 sentences):** In your own words, explain why a blockchain's "immutability" depends entirely on hashing. Specifically, address: what would happen if someone edited a transaction in a block from a year ago, and how would the network detect it?
2. **Small script (Python or JavaScript):**
   - Write a script that takes a string as input and prints its SHA-256 hash. (Python: use the built-in `hashlib` module. JavaScript/Node: use the built-in `crypto` module.)
   - Extend the script to simulate a two-block mini-chain: hash the string `"block 1 data"` to get `hash1`. Then hash the *combination* of `hash1 + "block 2 data"` to get `hash2`. Print both hashes, and add a comment explaining, in one line, what would happen to `hash2` if `"block 1 data"` were changed.
