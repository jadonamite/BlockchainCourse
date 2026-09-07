# Topic 2: Public / Private Key Cryptography

## The plain-language explanation

Every crypto wallet (MetaMask, or any other) is built on a concept called **asymmetric cryptography** — "asymmetric" because, unlike a single shared password, you have *two* mathematically related keys that each do a different job:

- A **private key**: a very large random number, generated when you create a wallet. This is the actual secret. Whoever holds this number has complete control of the wallet — they can sign transactions, move funds, everything. It must never be shared with anyone, ever, for any reason.
- A **public key**: mathematically derived *from* the private key, using a one-way process (similar in spirit to hashing — easy to go from private key to public key, practically impossible to go backwards). This is safe to share.
- Your wallet **address** (the `0x...` string people send you funds to) is itself derived from the public key, usually by hashing it and taking part of the result. So the chain is: private key → public key → address, and each arrow only goes one direction.

The specific math Ethereum uses for this is called **ECDSA** (Elliptic Curve Digital Signature Algorithm) — you don't need to understand the elliptic curve math itself to use it correctly, the same way you don't need to understand jet engine thermodynamics to be a passenger on a plane. What you *do* need to understand is what the keys let you do:

### Signing: proving you own the private key without revealing it

When you "sign" a transaction (e.g., "send 0.1 ETH to address X"), your wallet uses your private key to produce a **signature** — a piece of data mathematically tied to both the private key and the specific message being signed. Anyone in the world can then take that signature, the message, and your *public* key, and verify: "yes, this message was genuinely signed by whoever holds the private key matching this public key" — without ever seeing the private key itself, and without the signer having to reveal it.

This is the entire foundation of how blockchains verify who's allowed to move funds. There's no login system, no password reset, no customer support line — just math. If you sign it, it's authorized. If you didn't, no signature you produce will verify correctly, no matter how hard you fake it.

A critical detail: signing is *not* the same as encrypting. You're not hiding the transaction — anyone can read "send 0.1 ETH to address X" in plain text. You're proving *who authorized it*.

## Real-life analogy

Think of your private key like a **unique, physically impossible-to-forge signature stamp** — like a wax seal signet ring that only you own. Your public key is like a reference card, held by everyone you interact with, showing exactly what your genuine seal impression looks like.

When you sign a document, you press your ring into wax (using your private key). Anyone can compare that wax seal against the reference card (your public key) and confirm: "yes, this really was sealed by the one person who owns that ring." Crucially, having the reference card doesn't let you forge the ring's impression — verifying and creating a signature are two completely different, one-directional operations.

If you ever lose the ring (leak your private key), anyone who finds it can now forge your signature perfectly, and there's no way to "revoke" it after the fact — which is exactly why protecting a private key is the single most important security habit in this entire field.

## Recommended videos

- [Public Key Cryptography - Computerphile](https://www.youtube.com/watch?v=GSIDS_lvRv4) — a well-known, clear explanation of the general public/private key concept, from a channel that specializes in making CS ideas accessible.
- [Public Key & Private Key Explained | Asymmetric Encryption for Beginners](https://www.youtube.com/watch?v=RQ_vKpryNwM) — beginner-focused walkthrough of the same idea, useful as a second pass if the first video moves too fast.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/public-private-keys](https://andersbrownworth.com/blockchain/public-private-keys/)** — the companion to last topic's hash demo, from the same site. It lets you generate a real key pair in your browser, type a message, sign it with the private key, and verify it with the public key — and then tamper with the message afterward and watch verification *fail*. This is the single best way to see signing and verification actually happen.

## Practice (do this now, takes ~15 minutes)

1. Go to the Anders Brownworth public/private key demo and generate a new key pair.
2. Type a short message (e.g., "send 5 coins to Alice"), then sign it using the private key field. Note the signature that's produced.
3. Use the public key and the signature to verify the message — confirm it shows as valid.
4. Now change one word in the message (without re-signing) and try to verify again. Confirm it now fails. This is the exact mechanism that stops someone from intercepting a transaction and altering the amount or recipient.
5. Open MetaMask (installed in your Week 1 wallet setup). You will never see your private key during normal use — MetaMask handles signing internally when you approve a transaction. Take a moment to notice: every time you click "Confirm" on a transaction, that's your private key signing it behind the scenes, without ever leaving your device.

## Take-home assignment

1. **Analogy (your own, not the ones given above):** Write a short paragraph (4–6 sentences) describing public/private key signing using a real-world analogy you come up with yourself — not the wax seal or fingerprint examples from this doc. Explain which part of your analogy represents the private key, which represents the public key, and which represents "signing" vs. "verifying."
2. **Written exercise:** In plain language, explain what an attacker *could* and *could not* do if they obtained your wallet's private key. Then explain what an attacker *could not* do even if they obtained your public key and every transaction you've ever signed. Be specific about the distinction.
