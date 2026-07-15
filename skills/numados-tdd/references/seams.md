# Seams — where tests live

## Definition

A **seam** is a public boundary where behaviour can be observed and verified
without reaching inside the system. Another name: the _interface_ that a caller
or consumer interacts with.

Tests live at seams. They do not reach past the seam into private methods,
internal state, or implementation details.

## What is a seam

| Is a seam | Is NOT a seam |
|-----------|---------------|
| Public API endpoint | Private helper method |
| Service method called by a controller | Internal wiring between helpers |
| Repository interface | Database query inside a repository |
| Command / query handler | The ORM mapping inside the handler |
| Module's exported function | Un-exported utility |
| gRPC / REST contract | Serialization format detail |
| Event published to a bus | The bus wiring itself |
| CLI command entry point | Internal string formatting |

## Identifying seams from a plan

When a `plan.md` phase says "add an endpoint that creates an order" or
"implement the retry policy in the payment handler", extract the seams:

1. **The caller's entry point** — what does the outside world call?
   Example: `POST /orders`, `PaymentService.Charge()`, `handleRetry()`.

2. **The observable outcome** — what can the caller observe after the call?
   Example: HTTP 201 + order ID, a confirmed transaction, a logged retry
   attempt.

3. **The contract** — what must remain true regardless of implementation?
   Example: "an order is retrievable by ID after creation", "a failed charge is
   retried exactly 3 times".

The seam is the combination: entry point + observable outcome + contract.

## Confirming seams with the user

Present seams as a short list:

```text
Seams for P2 (payment retry):

1. PaymentService.Charge(orderId) — public method called by order workflow
   Contract: on transient failure, retries 3 times with exponential backoff
   Observable: return value (success / permanent-failure), event log

2. RetryPolicy — injected dependency interface
   Contract: computes delay for attempt N
   Observable: return value for given attempt number
```

Ask: "Are these the right seams? Any missing? Any that don't need testing?"

If the user removes a seam, record the decision. If they add one, extend the
test list.

## Why seams matter

Without agreed seams, testing effort scatters:

- Tests appear for implementation details (private methods, internal wiring)
- Critical paths go untested because nobody named them
- Tests break on refactoring because they were coupled to internals
- Coverage metrics look good but business rules are unprotected

Seams force the question: **"What does a caller care about?"** — which is
exactly what a business-rule test should answer.

## Seam granularity

A seam should be coarse enough that a business stakeholder could describe what
it does, and fine enough that a failing test pinpoints the problem.

| Too coarse | Right size | Too fine |
|-----------|------------|----------|
| "The whole checkout flow" | `CheckoutService.execute(cart)` | `CartValidator.validateItem()` |
| Tests everything at once, hard to diagnose | Tests one business capability | Tests internal wiring, breaks on refactor |

If a seam covers many unrelated behaviours, split it. If a seam is a single
internal step, it is not a seam — it is an implementation detail.

## Seams and legacy code

In legacy code, seams may not be clean. A class might mix business logic with
framework wiring. In this case:

1. Identify the smallest public method that performs a business-rule decision.
2. If dependencies make it untestable, recommend a minimal refactor (extract
   interface, inject dependency) as a pre-seam step.
3. Record the refactor as a separate, minimal phase — do not bundle it with
   business-rule tests.
