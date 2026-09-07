# Topic 2: Public / Private Key Cryptography

## The plain-language explanation

Every crypto wallet (MetaMask, or any other) is built on a concept called **asymmetric cryptography** — "asymmetric" because, unlike a single shared password, you have *two* mathematically related keys that each do a different job:

- A **private key**: a very large random number, generated when you create a wallet. This is the actual secret. Whoever holds this number has complete control of the wallet — they can sign transactions, move funds, everything. It must never be shared with anyone, ever, for any reason.
- A **public key**: mathematically derived *from* the private key, using a one-way process (similar in spirit to hashing — easy to go from private key to public key, practically impossible to go backwards). This is safe to share.
- Your wallet **address** (the `0x...` string people send you funds to) is itself derived by *hashing* the public key and taking part of the result (this is where Topic 1 directly connects — your address is literally a hash). So the full chain is: private key → public key → address, and each arrow only goes one direction.

The specific math Ethereum and Bitcoin use for this is called **ECDSA** (Elliptic Curve Digital Signature Algorithm), on a specific curve named **secp256k1**. You don't need to understand the elliptic curve math itself to use it correctly, the same way you don't need to understand jet engine thermodynamics to be a passenger on a plane. What you *do* need to understand is what the two keys let you do — and there are actually **two distinct things** asymmetric cryptography is used for, which are easy to mix up:

### Two different jobs: encryption vs. signing

1. **Encryption (confidentiality — "can only the right person read this?").** Someone encrypts a message *using your public key*. Now only you, holding the matching private key, can decrypt and read it. Anyone can encrypt a message to you; only you can open it.
2. **Signing (authenticity — "did this really come from who it claims to?").** You sign a message *using your private key*, producing a signature. Anyone holding your public key can verify that signature — confirming the message really was authorized by the one person holding the matching private key — without that person ever revealing the key itself.

**Blockchain wallets use almost entirely the second one: signing.** When you send a transaction, you are not hiding its contents — anyone can read "send 0.1 ETH to address X" in plain text on a block explorer. You are proving *who authorized it*. This is a common point of confusion for newcomers coming from a general "public key = encryption" mental model, so it's worth being precise about from day one.

### Why this is the entire foundation of blockchain authorization

There's no login system, no password reset, no customer support line for a blockchain. There's just math. If a transaction is signed with a private key, it's authorized — full stop. If you didn't sign it, no signature you produce will verify correctly, no matter how hard you try to fake it, because forging a valid signature without the private key is exactly as computationally infeasible as reversing a hash.

## Worked example (a real key pair, generated live, not hypothetical)

This was generated using `openssl` on the same elliptic curve (`secp256k1`) that Ethereum wallets actually use. You can reproduce every line of this yourself.

**1. Generate a real private key:**

```
$ openssl ecparam -name secp256k1 -genkey -noout -out priv.pem
```

```
-----BEGIN EC PRIVATE KEY-----
MHQCAQEEIHoNT3gUJYe9tBv7ZZoRYRGGIGkvCFmX60mY+AAHXapHoAcGBSuBBAAK
oUQDQgAEjO0NYj4xwIE6sp4KVeag4zr8IUtOG+Tjf9yZ3NW5YqFJBhvP0wmCGTpe
2EsDsR2A2ko6I8XwpIOIeu7Ug853YA==
-----END EC PRIVATE KEY-----
```

**2. Derive the public key from it (one direction only — this cannot be reversed):**

```
$ openssl ec -in priv.pem -pubout -out pub.pem
```

```
-----BEGIN PUBLIC KEY-----
MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEjO0NYj4xwIE6sp4KVeag4zr8IUtOG+Tj
f9yZ3NW5YqFJBhvP0wmCGTpe2EsDsR2A2ko6I8XwpIOIeu7Ug853YA==
-----END PUBLIC KEY-----
```

**3. Sign a transaction-like message with the private key:**

```
$ echo -n "Send 1 ETH to Alice" > message.txt
$ openssl dgst -sha256 -sign priv.pem -out sig.bin message.txt
```

Resulting signature (hex-encoded):
```
30450221009e5db5f9adc7863abe31ed8b6e106216c3ca741b2e6edfc60e3f9ac44df755c3022058e3daafc7264a344a5e26e5104436b6134cfd6740e740bea89e1c8adc92abf7
```

**4. Verify it with the public key — succeeds, because the message is unmodified:**

```
$ openssl dgst -sha256 -verify pub.pem -signature sig.bin message.txt
Verified OK
```

**5. Now try to verify the *same signature* against a tampered message:**

```
$ echo -n "Send 100 ETH to Alice" > tampered.txt
$ openssl dgst -sha256 -verify pub.pem -signature sig.bin tampered.txt
Verification failure
```

That last step is the entire point. An attacker who intercepts this transaction cannot change "1 ETH" to "100 ETH" without invalidating the signature — and they cannot produce a *new* valid signature for the tampered message, because they don't have the private key. This is why a blockchain doesn't need a bank in the middle to prevent this exact kind of fraud.

## Real-world use cases (this exact math secures far more than crypto wallets)

1. **HTTPS / TLS — the padlock icon in your browser.** When you visit your bank's website, your browser and the bank's server use this same public/private key math to prove the server really is who it claims to be, and to securely establish an encrypted connection. Every time you've logged into any website over HTTPS, you've relied on asymmetric cryptography.

2. **SSH keys.** If you've ever set up a GitHub SSH key (`~/.ssh/id_ed25519`) to push code without typing a password every time, you've already generated a private/public key pair and used it for exactly this purpose: GitHub's servers trust anyone who can produce a valid signature with the private key matching the public key you uploaded. It's the identical concept as a crypto wallet, just applied to logging into a server instead of authorizing a transaction.

3. **Code signing.** When your phone or computer says "Verified Developer" before installing a software update, it's checking a signature made with the developer's private key against a known public key — proving the update genuinely came from Apple, Google, or Microsoft, and wasn't swapped out for malware by an attacker in the middle.

4. **Signed git commits.** Git supports cryptographically signing your commits (`git commit -S`) so that anyone cloning your repository can verify a given commit genuinely came from you, and wasn't inserted by someone who gained write access to the repository. This is a direct, developer-relevant relative of blockchain transaction signing.

5. **PGP/GPG-encrypted email.** Journalists and security researchers commonly publish a public key so sources can send them encrypted messages that only they can decrypt — the "encryption" use case described above, rather than the "signing" one.

## Real-life analogy

Think of your private key like a **unique, physically impossible-to-forge signature stamp** — like a wax seal signet ring that only you own. Your public key is like a reference card, held by everyone you interact with, showing exactly what your genuine seal impression looks like.

When you sign a document, you press your ring into wax (using your private key). Anyone can compare that wax seal against the reference card (your public key) and confirm: "yes, this really was sealed by the one person who owns that ring." Crucially, having the reference card doesn't let you forge the ring's impression — verifying and creating a signature are two completely different, one-directional operations.

If you ever lose the ring (leak your private key), anyone who finds it can now forge your signature perfectly, and there's no way to "revoke" it after the fact — which is exactly why protecting a private key is the single most important security habit in this entire field.

## Common misconceptions

- **"My wallet address IS my public key."** Not quite — your address is a *hash* of your public key (usually the last 20 bytes of its Keccak-256 hash, on Ethereum). This is a direct callback to Topic 1: your address goes public key → hash → address, one more one-way step for extra safety margin.
- **"Signing a transaction encrypts it, so nobody can see what it says."** No — as covered above, signing proves *authorship*, not secrecy. Every detail of a public blockchain transaction (sender, recipient, amount) is visible to anyone on a block explorer. If you want confidentiality, that's a separate problem (and one public blockchains generally don't solve by default).
- **"If I lose my private key, I can just reset it like a forgotten password."** There is no password reset. If a private key is lost, whatever funds or permissions it controlled are gone, permanently, with no recovery mechanism built into the protocol. (Some wallets offer a recovery *phrase* — a human-readable backup of the key generated at setup — but that only works if you saved it *before* losing access, not after.)

## Recommended videos

- [Public Key Cryptography - Computerphile](https://www.youtube.com/watch?v=GSIDS_lvRv4) — a well-known, clear explanation of the general public/private key concept, from a channel that specializes in making CS ideas accessible.
- [Public Key & Private Key Explained | Asymmetric Encryption for Beginners](https://www.youtube.com/watch?v=RQ_vKpryNwM) — beginner-focused walkthrough of the same idea, useful as a second pass if the first video moves too fast.

## Where to learn and practice

- **[andersbrownworth.com/blockchain/public-private-keys](https://andersbrownworth.com/blockchain/public-private-keys/)** — a browser-based demo that lets you generate a real key pair, sign a message, verify it, then tamper with the message afterward and watch verification *fail* — the same experiment you just walked through with `openssl`, but with a visual interface.
- **Your own terminal with `openssl`.** Every Mac and Linux machine already has this installed. You don't need MetaMask or any blockchain-specific tool to understand the underlying math — you just used the exact same primitive Ethereum wallets use.

## Practice (do this now, takes ~20 minutes)

1. Open a terminal and run through the five `openssl` commands in the worked example above yourself, using your own message text in step 3. Confirm you get `Verified OK` on the original message and `Verification failure` on a tampered one.
2. Go to the Anders Brownworth public/private key demo and repeat the same experiment with its visual interface: generate a key pair, sign a message, verify it, then edit the message and verify again to watch it fail.
3. Open MetaMask (installed in your Week 1 wallet setup). You will never see your private key during normal use — MetaMask handles signing internally when you approve a transaction. Take a moment to notice: every time you click "Confirm" on a transaction, that's your private key signing it behind the scenes, using the exact mechanism you just ran by hand in your terminal.

## Take-home assignment

1. **Reproduce the worked example:** Run the five `openssl` commands yourself with a message of your choosing, and paste your terminal output (private key, public key, signature, and both verification results) into your notes.
2. **Analogy (your own, not the ones given above):** Write a short paragraph (4–6 sentences) describing public/private key signing using a real-world analogy you come up with yourself. Explain which part represents the private key, which represents the public key, and which represents "signing" vs. "verifying."
3. **Real-world use case (5–6 sentences):** Pick one use case from this doc that is not a crypto wallet (HTTPS, SSH keys, code signing, signed git commits, or PGP email). Explain what specifically would go wrong — concretely — if that system used a shared secret (like a regular password) instead of a public/private key pair.
4. **Written exercise:** In plain language, explain what an attacker *could* and *could not* do if they obtained your wallet's private key. Then explain what an attacker *could not* do even if they obtained your public key and every transaction you've ever signed. Be specific about the distinction.
