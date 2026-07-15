# Test list

The test list is the TDD steering document. It is created during planning,
extended during implementation as new scenarios are discovered, and serves as
the gate for what gets a test.

## Source: Kent Beck's Canon TDD

From the 2023 article:

> 1. Write a list of the test scenarios you want to cover
> 2. Turn exactly one item on the list into an actual, concrete, runnable test
> 3. Change the code to make the test (and all previous tests) pass, adding
>    items to the list as you discover them
> 4. Optionally refactor to improve the implementation design
> 5. Repeat until the list is empty

The list is not a rigid spec — it grows as implementation reveals new
scenarios. But it is always an explicit filter: if a scenario is not on the
list, it does not get a test.

## What goes on the list

A valid test-list item:

1. Describes a **business-rule scenario** — observable input → observable
   output through a named seam.
2. Has a **clear pass/fail** — there is no ambiguity about whether the
   behaviour is correct.
3. Is **independent** — can be tested in isolation from other scenarios.

**Good list items:**

```text
- [ ] Empty cart returns zero total
- [ ] Single item cart returns item price
- [ ] Cart with two items returns sum of prices
- [ ] Applying a 10% coupon reduces total by 10%
- [ ] Checkout with expired payment method returns "payment method expired"
- [ ] Retry policy: third failure propagates the error
- [ ] Order created via API is retrievable by ID within 5 seconds
```

**Bad list items — do not add these:**

```text
- [ ] Test that the controller exists              ← not a business rule
- [ ] Test that the CartService is injected         ← framework wiring
- [ ] Test that calculateTotal calls getSubtotal    ← implementation detail
- [ ] Test all edge cases for price formatting      ← too vague
- [ ] Test the full checkout flow                   ← too coarse
```

## What does NOT go on the list

Explicitly exclude:

| Category | Example | Reason |
|----------|---------|--------|
| Framework wiring | "Controller is registered" | Framework tests itself |
| Dependency injection | "Service receives its deps" | DI container tests itself |
| Trivial accessors | "getName returns the name" | No business logic |
| Implementation detail | "Private helper formats the date" | Tested through public seam |
| Duplicate scenarios | Same rule, different input | Pick the representative |
| Coverage padding | "Test the else branch" | No behavioural value |

## Maintaining the list

During implementation, new scenarios will appear:

- An edge case you didn't think of during planning.
- A contract that turns out to have more variants.
- A user confirmation that adds a requirement.

When this happens:

1. Add the scenario to the list.
2. If it belongs to the current phase and is small, address it after the
   current cycle.
3. If it is large or changes scope, record it and flag for the user — it may
   need a phase extension through `$numados-planning`.

Do not silently add significant scenarios. The list is a shared understanding,
not a private notebook.

## Test list format in plan.md

The test list appears inside each phase's test-coverage section:

```markdown
### P2 test coverage

Seams under test:
- `PaymentService.Charge(Order)` — the public entry point for payment

Test list:
- [x] Successful charge returns confirmed status
- [x] Transient failure retries and succeeds on second attempt
- [x] Third consecutive failure returns permanent-failure status
- [ ] Expired payment method returns "payment method expired"
- [ ] Zero-amount order skips payment and returns confirmed

Verification:
- `dotnet test tests/PaymentService.Tests --filter "FullyQualifiedName~Charge"`
- Expected: 5 tests, all passing
```

Checked items `[x]` mean the scenario has a passing test. Unchecked items `[ ]`
are planned but not yet implemented.

## Ordering the list

Start with the simplest happy-path scenario. It proves the seam works
end-to-end. Then add variations, error cases, and edge conditions in order of
business impact.

The first test is a **tracer bullet** — it establishes that the test harness,
the seam, and the implementation can all connect. Without it, later tests may
fail for infrastructure reasons, wasting diagnosis time.
