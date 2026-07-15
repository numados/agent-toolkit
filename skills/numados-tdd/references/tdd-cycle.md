# TDD Cycle — RED → GREEN → REFACTOR

The cycle is non-negotiable. Skipping a step or changing the order is not TDD.

## RED — Write the failing test

Write exactly one test for one scenario from the test list.

### Requirements

- **One scenario.** If the test name contains "and", split it.
- **Clear name.** The name describes the business rule:
  `OrderService_CreateOrder_WithValidCart_ReturnsConfirmedOrder`
- **Uses the public seam.** No access to private state, no mocking of internal
  collaborators.
- **Assertion is a behavioural expectation.** Not a mock call count, not an
  internal field value.
- **Expected value is from an independent source.** A literal constant, a
  manually worked example, or the spec — not recomputed the same way the code
  will compute it.

### Example (C# xUnit)

```csharp
[Fact]
public async Task Charge_WithTransientFailure_RetriesAndSucceeds()
{
    // Arrange
    var paymentMethod = new PaymentMethod { IsTransientlyFailing = true };
    var order = new Order { Total = 100m };

    // Act
    var result = await _sut.Charge(order, paymentMethod);

    // Assert
    Assert.Equal(ChargeStatus.Confirmed, result.Status);
    Assert.Equal(2, result.Attempts); // failed once, succeeded on retry
}
```

### Verify RED — MANDATORY

Run the test:

```bash
dotnet test --filter "FullyQualifiedName~Charge_WithTransientFailure"
```

Confirm:

- [ ] Test **fails** (not errors — no compilation error, no missing reference)
- [ ] Failure message matches the expected gap: "feature not implemented", not
  "null reference" or "type mismatch"
- [ ] The test is failing because the behaviour does not exist yet

**Test passes?** You are testing existing behaviour. The scenario may already
be covered, or the test is wrong. Fix the test.

**Test errors (does not compile, null ref)?** The test has a bug. Fix it and
re-run until it fails correctly.

**Never skip this step.** If you did not watch the test fail for the right
reason, you do not know if it tests anything.

## GREEN — Minimal code

Write the simplest code that makes the test pass. Do not:

- Add features the test does not demand (YAGNI)
- Refactor other code
- "Improve" design beyond what the test requires
- Anticipate the next test

### Example

```csharp
public async Task<ChargeResult> Charge(Order order, PaymentMethod method)
{
    for (int attempt = 1; attempt <= MaxRetries; attempt++)
    {
        try
        {
            await _gateway.Process(order, method);
            return new ChargeResult(ChargeStatus.Confirmed, attempt);
        }
        catch (TransientException) when (attempt < MaxRetries)
        {
            // retry
        }
    }
    return new ChargeResult(ChargeStatus.PermanentFailure, MaxRetries);
}
```

This is enough for the current test. It does not handle expired payment
methods, zero-amount orders, or configurable retry counts — those scenarios
are not on the current test yet.

### Verify GREEN — MANDATORY

Run the same test again. Confirm:

- [ ] The new test passes
- [ ] All previously passing tests still pass
- [ ] No new warnings, no test-runner errors

**New test fails?** Fix the code, not the test.

**Other tests fail?** Fix now — the minimal change broke something. This is
valuable: you caught a regression immediately.

## REFACTOR — Clean up

After GREEN, and only after GREEN:

- Remove duplication (extract method, extract class)
- Improve names
- Simplify control flow

Keep tests green throughout. Run after each refactor step. Do not add
behaviour.

If no refactoring is needed, move to the next scenario. "No obvious
duplication" is a valid refactor outcome.

## Repeat

Pick the next unchecked scenario from the test list. RED → GREEN → REFACTOR.
Repeat until the phase's test list is fully checked.

## Red flags

| Situation | Action |
|-----------|--------|
| Test passes immediately | Fix the test — it is not testing new behaviour |
| Test errors (compile/runtime) | Fix the test — it has a bug |
| Need to add code the test doesn't demand | Don't — add a new scenario first |
| "This is too simple to test" | Rationalization — even simple code breaks |
| "I'll write the test after" | Not TDD — delete the code, start over |
| "I'll write all tests first, then implement" | Horizontal slicing — produces bad tests |

## Vertical slices

```
WRONG (horizontal):
  Phase:  test1, test2, test3, test4
  Then:   impl1, impl2, impl3, impl4

RIGHT (vertical):
  test1 → impl1 → refactor
  test2 → impl2 → refactor
  test3 → impl3 → refactor
  test4 → impl4 → refactor
```

Each vertical slice is a tracer bullet. It proves the test harness, the seam,
and the implementation all work before moving to the next scenario.
