# Topic 1: Decentralization — What Problem Does It Actually Solve?

## Start here: a question, not a definition

When you send money through your bank's app, who are you actually trusting to make sure the transaction is real, and that your balance doesn't just get quietly changed? Sit with that for a second before reading on — the honest answer is: the bank. One institution's internal database is the single source of truth for what you own. Everyone downstream — you, the merchant, other banks — ultimately trusts that one ledger.

## Notice it, before we name it

Now play that forward. What happens if the bank's database goes down for a day? You can't spend your own money — not because it's gone, but because the one place that says how much you have is unreachable. What happens if the bank makes an error, or gets hacked, and your recorded balance is wrong? You have no independent way to check — there's no second copy anywhere else to compare against. What happens if the bank (or the government that regulates it) decides to freeze your account? There's no appeal to a second authority, because there isn't one.

Now compare that to what you already built in Week 1. When you looked up your testnet transaction on Etherscan, that data wasn't coming from one company's private database — it was being independently confirmed by thousands of separate computers around the world, each of which had verified it themselves using the hashing, signing, and consensus mechanisms you already understand. If any single one of those computers disappeared, or lied about what it saw, the rest of the network would carry on undisturbed and the lie would be rejected. There is no single database to freeze, hack, or quietly edit.

## Now it has a name

That difference has a name, and it's worth being precise about it, because people use three different words interchangeably when they actually mean three different things:

- **Centralized** — one party controls the source of truth. Your bank's ledger. A company's single production database.
- **Distributed** — the *work* is spread across many machines, but one party still controls all of them. A company running its own servers across five data centers on three continents is distributed — but it's still that one company's decision whether to shut any of them down, and its engineers who can quietly edit the data. Spread out, not decentralized.
- **Decentralized** — both the *work* and the *control* are spread across many independent, mutually distrusting parties, none of whom can unilaterally change the rules or rewrite the recorded history without the others noticing and rejecting it.

Public blockchains are decentralized in this specific, load-bearing sense: no single node — however large or well-funded — can quietly edit history, because every other node is independently checking the same hashes and following the same consensus rules from Week 1.

## Check your understanding

Is a company's cloud infrastructure — say, spread across five AWS data centers on three continents — "decentralized"?

...

No — it's **distributed**, not decentralized. It's technically spread across many machines, and it may well survive one data center going offline. But one company still makes every decision about every one of those machines: what code runs, who gets banned, what the "true" balance is if there's ever a dispute. Decentralization is about who *controls* the system and can unilaterally change it — not simply how many machines it happens to run on.

## Connect it

Think about a gradient you already have intuitions about, from outside crypto entirely:

- **A company's internal wiki** — centralized. One team can edit or delete anything.
- **Wikipedia** — many contributors from anywhere in the world can edit, but hosting, final moderation authority, and the ability to ban an editor or roll back the whole site sit with one nonprofit organization. Contribution is decentralized-ish; ultimate control is not.
- **BitTorrent** — nobody hosts "the" file. Thousands of independent peers each hold pieces of it, and no single peer (or even a government) can make it disappear by taking down one server. Genuinely decentralized distribution, even though it predates blockchain entirely.

Bitcoin and Ethereum sit closer to the BitTorrent end of that spectrum — for the ledger of who owns what, specifically — which is precisely why Week 1 spent so much time on hashing, signing, and consensus. Those aren't separate topics from decentralization; they're the actual engineering mechanisms that make it possible for a system with no central authority to still be trustworthy.

## Real-world uses

- **Domain Name System (DNS)** — technically has some decentralized elements (many independent servers), but ultimate control of top-level domains sits with a small number of centralized registries, which is why governments can and do seize domains.
- **Open-source software development** — code itself is often decentralized (anyone can fork a public repository and keep developing independently), even when the "official" project has centralized maintainers.
- **Email** — the *protocol* (SMTP) is decentralized by design — anyone can run a mail server — but in practice a handful of providers (Gmail, Outlook) handle the overwhelming majority of real-world email, showing how a system can be architecturally decentralized while becoming practically centralized through adoption patterns. You'll see this exact distinction get a name in the next topic.

## Common misconceptions

- **"Decentralized just means 'on a lot of computers.'"** That's distribution, not decentralization — see the cloud-infrastructure example above. The number of machines tells you nothing about who controls them.
- **"Decentralization is all-or-nothing."** It isn't — as the email example shows, a system can be decentralized in its underlying design while still becoming centralized in practice. The next topic gives you precise language for exactly this.

## Recommended videos

- [Decentralization Explained: No Central Authority | Blockchain Basics for Beginners](https://www.youtube.com/watch?v=7rSbKu9fjP0)

## Practice

1. Pick three systems you use daily (a messaging app, a payment app, a social network) and classify each as centralized, distributed, or decentralized — and justify why, specifically in terms of who could unilaterally change or delete your data.
2. Revisit your Week 1 testnet transaction on Etherscan. Write down, concretely, who would have to agree to falsify that record, and why that's different from a bank employee editing a spreadsheet.

## Take-home

**Written (5–6 sentences):** Pick a real system — a company, app, or service you use — and explain what would have to be true about it for it to become genuinely decentralized, not just spread across more servers. Be specific about who currently holds unilateral control, and what would need to change.
