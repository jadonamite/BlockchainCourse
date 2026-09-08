# Topic 3: Tooling — Remix to Foundry

## Start here: a question, not a definition

You could write Solidity in a plain text editor, skip testing entirely, and deploy straight to a network where real money moves. Some people genuinely do this — and you can read about the consequences afterward, in post-mortems of exploited contracts. So the real question for this topic isn't "what is Foundry" — it's: **what does a workflow look like that actually catches your mistakes before they cost anything?**

## Notice it, before we name it

Here is the real, unedited output from compiling `Counter.sol`:

```
$ forge build

Compiling 23 files with Solc 0.8.36
Solc 0.8.36 finished in 44.37s
Compiler run successful!

note[screaming-snake-case-immutable]: immutables should use SCREAMING_SNAKE_CASE
   ╭▸ src/Counter.sol:10:30
   │
10 │     address public immutable owner;
   │                              ━━━━━ help: consider using: `OWNER`
```

Notice what just happened: nobody asked for a linter, and nobody wrote a test yet — but the compiler already caught a naming-convention issue on its own, before a single cent of gas was spent. That's one class of mistake caught automatically, for free, every single time you build.

Now the real, unedited output from running the test suite:

```
$ forge test -vv

Ran 5 tests for test/Counter.t.sol:CounterTest
[PASS] testFuzz_IncrementNTimes(uint8) (runs: 256, μ: 1313897, ~: 168657)
[PASS] test_IncrementAddsOne() (gas: 53574)
[PASS] test_NonOwnerCannotReset() (gas: 78828)
[PASS] test_OwnerCanReset() (gas: 100530)
[PASS] test_StartsAtZero() (gas: 7869)

Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 34.75ms
```

Look closely at the first line: `testFuzz_IncrementNTimes(uint8) (runs: 256, ...)`. That test wasn't run once — it ran **256 times**, each time with a different, randomly generated input, automatically. Here's the actual test that produced it:

```solidity
function testFuzz_IncrementNTimes(uint8 n) public {
    for (uint256 i = 0; i < n; i++) {
        counter.increment();
    }
    assertEq(counter.count(), n);
}
```

Nobody wrote 256 individual test cases. One test function stated a *property* that should always hold — "after calling `increment()` n times, `count()` should equal n, no matter what n is" — and Foundry's fuzzer generated 256 different values of `n` trying to break that property. It found none. That's a fundamentally different, much stronger kind of confidence than a handful of hand-picked examples.

## Now it has a name

Three tools did all of this, and each has one clear job:

- **`forge`** — builds your contracts (`forge build`) and runs your tests (`forge test`), including the fuzz testing you just saw. This is where you'll spend most of your time.
- **`cast`** — the command-line tool for *talking to* an already-deployed contract or a live chain: reading state (`cast call`), sending transactions (`cast send`), and inspecting raw data (`cast storage`, `cast code`) — everything you saw in Topic 01 came from `cast`.
- **`anvil`** — runs a complete local Ethereum node on your own machine in about a second, pre-funded with test accounts and no real money involved. Every example in this week's docs ran against a real `anvil` instance, not a simulation or a mock.

**Where does Remix fit in?** Remix is a browser-based IDE — you paste or write Solidity directly in a webpage, and it compiles and deploys with no setup at all. It's genuinely useful for the first few days, when you just want to see Solidity syntax work without installing anything. But it doesn't give you fuzz testing, doesn't integrate with version control the way a local project does, and doesn't scale to a real project with multiple contracts and a real test suite. The rule for this course: Remix for the first few days of quick syntax checks, `forge`/`cast`/`anvil` for everything real from here on.

## Check your understanding

If `forge test` passes with all green, 100% of your test cases succeeding — does that guarantee your contract is safe to deploy to mainnet?

...

**No.** It guarantees your code does what *your* tests checked for, on the inputs and interactions your tests covered. It says nothing about edge cases you didn't think to test, or about how your contract behaves when interacting with *other* contracts you don't control — including malicious ones. A green test suite is necessary, not sufficient. Week 5's security topic is entirely about the gap between "my tests pass" and "this is safe."

## Connect it

The `forge build` warning you saw above — `screaming-snake-case-immutable` — is a small example of something bigger: modern Solidity tooling increasingly bakes in the accumulated judgment of the wider developer community (naming conventions, gas-inefficient patterns, common mistakes) directly into the compiler and linter, so you inherit that judgment automatically just by building your code. That's a genuinely different experience from the era when Solidity developers had to know every pitfall from memory.

## Real-world uses

- **Continuous integration.** Real teams run `forge test` automatically on every pull request — a red test suite blocks a merge, the same as any other software project, which is exactly what this course's Ground Rule #4 ("every contract gets at least a basic test") is preparing you for.
- **Fork testing** (a Foundry feature you'll grow into) lets you run your contract's tests against a live copy of mainnet's actual current state — testing against real deployed protocols like Uniswap without spending real gas.
- **Static analysis tools** like Slither (Week 5) build on the same idea as that `forge build` warning: catching entire classes of mistakes automatically, before a human has to spot them by eye.

## Common misconceptions

- **"Remix and Foundry are basically interchangeable — just pick whichever you like."** For quick syntax experiments, sure. For anything you intend to actually test rigorously, version-control, and deploy as part of a real project, they are not equivalent — Remix has no equivalent to Foundry's fuzz testing or scriptable deployment pipeline.
- **"If it compiles, it works."** Compiling only confirms your Solidity is syntactically valid and type-correct. It says nothing about whether the *logic* is correct — that's what `forge test` is for.

## Recommended videos

- [A Complete Introduction to Smart Contract Development With Foundry](https://www.youtube.com/watch?v=hOB1Yiuxojk)
- [How to test Solidity contracts? (Foundry tutorial)](https://www.youtube.com/watch?v=LJxpjTVTQog)

## Where to practice

- Install Foundry yourself: `curl -L https://foundry.paradigm.xyz | bash`, then `foundryup`.
- `forge init my-project` to scaffold a real project (it comes with a working example contract and test, similar to what this week's docs are built from).

## Practice

1. Run `forge init` yourself, and run `forge test -vv` on the default scaffolded contract before touching anything.
2. Replace the default contract with this week's `Counter.sol`, and confirm `forge build` shows you the same `screaming-snake-case-immutable` note.
3. Write one more fuzz test of your own for a property you believe should always hold, and watch it run dozens or hundreds of times automatically.

## Take-home

1. **Written (4–5 sentences):** in your own words, explain why a fuzz test running 256 times is a stronger check than a single hand-written example-based test — and what a fuzz test *can't* tell you.
2. Break your own `Counter.sol` on purpose (for example, remove the `onlyOwner`-style check in `reset()`) and write a test that would have caught the regression — confirm it fails against the broken version and passes once you fix it back.
