# Topic 1: Hashing

## The plain-language explanation

A **hash function** is a mathematical function that takes *any* input — a single letter, a word, an entire movie file, gigabytes of data — and turns it into a fixed-length string of letters and numbers, called a **hash** (or "digest"). For blockchain, the specific hash function that matters most is called **SHA-256** (used by Bitcoin) or **Keccak-256** (used by Ethereum), but they both work the same way conceptually, and everything below applies to both.

A hash function has properties that matter enormously, and it's worth sitting with each one individually:

1. **Fixed-length output, regardless of input size.** Whether you hash the single letter "a" or the entire text of every Harry Potter book combined, SHA-256 always produces exactly 256 bits of output (displayed as 64 hexadecimal characters). The output size never grows with the input.

2. **Deterministic.** The same input *always* produces the exact same output. Hash the word "hello" today, tomorrow, or on a different computer on the other side of the planet — you get the identical hash every time. There's no randomness involved.

3. **One-way (a "trapdoor" function).** Given a hash, there is no way to work backwards to figure out what the original input was, other than guessing inputs and hashing them until you get a match — which, for anything non-trivial, would take longer than the age of the universe with all the computing power on Earth combined. Easy to fall through in one direction, essentially impossible to climb back up.

4. **Avalanche effect.** Changing even a single character of the input — even just flipping one letter's capitalization — produces a completely different, unrecognizable hash. There's no "partial similarity" between the hashes of similar inputs.

5. **Collision resistance.** It should be practically impossible to find two different inputs that produce the same hash. This is what makes a hash trustworthy as a stand-in for the original data — if I show you a hash, you can be confident it corresponds to one specific piece of data, not several.

### Why blockchain cares about this at all

A blockchain is, at its core, a very long list of data (transactions, grouped into blocks) where **each block contains the hash of the block before it.** That's the entire trick, covered in full in Topic 3. Because of the avalanche effect, if anyone tries to secretly edit an old transaction, the hash of that block changes completely — which breaks its link to the next block. The tampering becomes immediately, mathematically obvious. You don't have to trust anyone's word for it — you just recompute the hash and check.

## Worked example (real, computed output — not hypothetical)

These aren't made-up example hashes. They were generated live, on the command line, using `shasum -a 256` (the same SHA-256 algorithm Bitcoin uses). You can reproduce every one of these yourself.

**Determinism** — hashing the exact same input twice, on two separate runs:

```
$ echo -n "hello" | shasum -a 256
2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824

$ echo -n "hello" | shasum -a 256
2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824
```

Identical, every time, forever. No randomness.

**Avalanche effect** — hashing three closely related inputs. Notice each hash is 64 hex characters, no matter how the input length changes, and the outputs share *zero* visible resemblance to each other despite the inputs differing by one character or one digit:

```
$ echo -n "Send 1 ETH to Alice" | shasum -a 256
9bed087e0a716e203d57c1ba36493085f7a87628da1cb1fe18bf5b4631bd7e45

$ echo -n "Send 1 ETH to Alicf" | shasum -a 256      # last letter changed e -> f
94f17d20a09db58f6a7fe2cf97f00b2ae2dc1a67802b6e74776b0b6785e4b1eb

$ echo -n "Send 100 ETH to Alice" | shasum -a 256    # "1" changed to "100"
d719d69c92208d30e96261d7832949c49cc1b60e67aaf9e628478b295efe44f4
```

Notice that changing "1 ETH" to "100 ETH" — the exact kind of tampering an attacker would want to pull off on a real transaction — produces a hash with no visible relationship to the original. There's no partial match to spot, no "close enough." This is precisely what makes a single altered digit in a financial transaction detectable.

Try this yourself right now: open a terminal and run the two `echo -n "hello" | shasum -a 256` commands above. You'll get the exact same output shown here — that's determinism, proven on your own machine, not taken on faith.

## Real-world use cases (hashing shows up everywhere, not just blockchain)

Hashing predates blockchain by decades and solves a much older, more general problem: "how do I know this data hasn't changed?" Here's where it actually shows up in the software you already use:

1. **Software download integrity checks.** When you download a large program (a Linux distribution, a big installer), the publisher's website often lists a "SHA-256 checksum" next to the download. After downloading, you hash the file yourself and compare it to the listed value. If they match, you know the download wasn't corrupted in transit *and* wasn't tampered with by a compromised mirror server. This is the exact same mechanism that protects blockchain data, applied to file downloads instead of transactions.

2. **Git version control.** Every commit you've ever made, and every file version inside it, is identified by a hash. This isn't a metaphor — it's covered in full with real output in Topic 3, because it's genuinely the clearest "you've already been using this" example available.

3. **Password storage.** No competently built system stores your password as plain text. Instead, it stores a hash of your password. When you log in, the system hashes what you typed and compares it to the stored hash — if a database ever leaks, attackers get a list of hashes, not passwords. (One important nuance: plain SHA-256 alone is actually *not* considered ideal for passwords, because it's designed to be fast — which means an attacker with a leaked hash list can try billions of guesses per second. Purpose-built password-hashing algorithms like **bcrypt** or **Argon2** are deliberately slow and add random "salt" per password specifically to make this kind of brute-forcing impractical. Good engineering judgment here matters: use the right hash function for the job.)

4. **Deduplication in cloud storage.** Services like Dropbox or Google Drive hash the content of every file you upload. If two different users upload the exact same file, the service can recognize the hashes match and store the data only once internally, saving enormous amounts of storage — without ever needing to "look inside" either user's file.

5. **Digital forensics and chain of custody.** When investigators seize a hard drive as evidence, they hash it immediately. If the hash of the drive matches at trial months later, it proves the data was never altered after collection — a legal application of the exact same one-way, avalanche-effect properties you just tested above.

6. **Certificate Transparency logs.** Every SSL certificate issued for any website (including the one securing your bank's login page) gets published into a public, tamper-evident log built from hash chaining, so security researchers can audit whether a Certificate Authority has secretly issued a fraudulent certificate for someone else's domain. This is a direct real-world relative of the block-chaining you'll learn in Topic 3.

## Real-life analogy

Think of a hash like a **tamper-evident wax seal** on an old letter. The seal itself doesn't tell you what's written inside the letter — you can't "reverse" a wax seal back into the words of the letter (one-way). But if someone opens the letter, changes even one word, and reseals it, the new seal will look completely different from the original (avalanche effect). Anyone who kept a record of what the original seal looked like can instantly tell the letter was tampered with, even without reading a single word of it.

Or, more simply: it's like a **fingerprint**. Your fingerprint doesn't let a stranger reconstruct your face (one-way), the same finger always leaves the same print (deterministic), and no two people share a fingerprint (collision resistance) — but if someone shows you a fingerprint, you can instantly *verify* whether it matches a specific person.

## Common misconceptions

- **"Hashing is a form of encryption."** No. Encryption is reversible on purpose — if you have the right key, you can decrypt data back to its original form. Hashing is deliberately one-way; there is no key that turns a hash back into its original input. If someone says they "decrypted a hash," that's a contradiction in terms — what they actually did (if anything) was guess inputs and re-hash them until one matched.
- **"Hashing is a form of compression."** No. Compression is designed so you can reconstruct the *original* data from the compressed version. A hash is not a shrunk-down copy of the input that can be expanded back — it's a fingerprint, not a zip file.
- **"If a hash is public, that's always safe."** Mostly true for high-entropy inputs like large files or random data, but *not* true for low-entropy inputs. If you hashed a 4-digit PIN, an attacker could simply hash all 10,000 possible PINs and find the match instantly. This is exactly why passwords need random "salt" added before hashing (see use case #3 above) — otherwise attackers pre-compute hashes for common passwords in bulk (called a "rainbow table") and just look yours up.

## Recommended videos

- [How does SHA-256 work? (full explanation)](https://www.youtube.com/watch?v=PbFVTb7Pndc) — the best single overview: what SHA-256 is, why it matters, and how it works under the hood, without assuming prior crypto background.
- [What is SHA-256 | Blockchain | The Beginner Guide](https://www.youtube.com/watch?v=ds655t9KZc0) — slower-paced, more example-driven, good if the first video moves too fast.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/hash](https://andersbrownworth.com/blockchain/hash)** — an interactive SHA-256 calculator built exactly for this. Type anything into the "Data" box and watch the hash recompute *live* as you type. This is the fastest way to *feel* the avalanche effect instead of just reading about it.
- **[CyberChef](https://gchq.github.io/CyberChef/)** — a free browser-based tool (built by the UK's GCHQ, widely used by security professionals) that can hash text using SHA-256 and many other algorithms. Useful once you want to experiment beyond simple text.
- **Your own terminal.** Every Mac and Linux machine already has a SHA-256 hasher built in (`shasum -a 256` on macOS, `sha256sum` on Linux). No install needed — you used it above.

## Practice (do this now, takes ~20 minutes)

1. Open a terminal and run `echo -n "your own name here" | shasum -a 256` (macOS) or `echo -n "your own name here" | sha256sum` (Linux). Note the hash.
2. Run it again with the exact same input. Confirm you get the identical hash — determinism, proven on your own machine.
3. Change one character (capitalize a letter, add a period) and re-run. Confirm the entire hash changes, not just part of it — the avalanche effect, proven on your own machine.
4. Go to the Anders Brownworth hash demo and repeat steps 1–3 by typing directly into the live "Data" field, watching the hash update character-by-character as you type.
5. Open CyberChef, drag the "SHA2" operation into the recipe area, and hash the phrase `Hello World`. Now hash `hello World` (lowercase h) and compare — completely different output, from a one-character case change.

## Take-home assignment

1. **Written (5–6 sentences):** In your own words, explain why a blockchain's "immutability" depends entirely on hashing. Specifically, address: what would happen if someone edited a transaction in a block from a year ago, and how would the network detect it?
2. **Real-world use case essay (5–6 sentences):** Pick one real-world use case from this doc that is *not* blockchain (software checksums, password storage, deduplication, forensics, or certificate transparency). Explain, in your own words, what specific property of hashing (one-way, deterministic, avalanche effect, or collision resistance) makes it useful for that specific problem — and what would go wrong if hashing didn't have that property.
3. **Small script (Python or JavaScript):**
   - Write a script that takes a string as input and prints its SHA-256 hash. (Python: use the built-in `hashlib` module. JavaScript/Node: use the built-in `crypto` module.)
   - Extend the script to simulate a two-block mini-chain: hash the string `"block 1 data"` to get `hash1`. Then hash the *combination* of `hash1 + "block 2 data"` to get `hash2`. Print both hashes, then change `"block 1 data"` to something else, re-run, and add a one-line comment explaining what you observe about `hash2`.
