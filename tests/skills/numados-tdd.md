# numados-tdd evaluations

## Planning mode — extends plan.md with test coverage

The task has an approved `plan.md` with phases P1-P3 for a new order-checkout feature. Research confirms business rules for payment retry, coupon application, and inventory reservation.

Expected: read the plan, identify public seams for each phase (service methods, API endpoints), list business-rule scenarios per seam, extend each phase with a `test coverage` subsection containing seams, test list, and verification commands. Exclude framework wiring, DI checks, and trivial accessors. Record the extension in the planning iteration event.

## Planning mode — research too thin

The `plan.md` says "add retry logic" with no business-rule detail. Research has no target-behaviour statements.

Expected: stop and report "research or plan too thin to identify meaningful seams." Do not invent business rules. List what is missing.

## Implementation mode — TDD cycle per phase

Plan phase P2 says "implement payment retry" with a test list of 3 scenarios. The first scenario is untested.

Expected: write the test first, verify it fails with "feature not implemented", write minimal code, verify green, mark scenario `[x]`, repeat for remaining scenarios. Record test results in the phase iteration event. Do not write product code before a failing test.

## Implementation mode — red flag: code before test

The agent writes the retry implementation before any test exists.

Expected: stop. Report the red flag. Do not proceed.

## Legacy mode — user requests tests for untested code

User says: "The `InventoryReserver` class has no tests. Add business-rule tests for it."

Expected: read the class, extract observable business rules, identify public seams, produce a test list organised by seam for user approval. Exclude private helpers and trivial accessors. Do not write a single test until the user confirms the list.

## Legacy mode — code with no business logic

User says: "Add tests for the `OrderDto` class." The class has only properties and a `ToEntity()` mapper that delegates to AutoMapper.

Expected: report that the class has no business logic to test. The mapper is framework code. Suggest testing the seam that produces and consumes the DTO instead.

## Anti-pattern detection — rejects implementation-coupled test

An implementation-mode test mocks the internal `PriceCalculator` collaborator and asserts `.Verify(p => p.Calculate(...), Times.Once)`.

Expected: flag the test as implementation-coupled. The test should assert the observable outcome through the public seam, not internal call counts. Rewrite.

## Seam confirmation

Planning mode identifies seams: `CheckoutService.Execute(Cart)`, `PaymentGateway.Charge(Order, Method)`, and `InventoryReserver.Reserve(Items)`.

Expected: present the seams to the user with a one-line contract for each. Ask: "Are these the right seams?" Do not write tests at unconfirmed seams.
