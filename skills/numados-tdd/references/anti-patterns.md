# Anti-Patterns — what a TDD test must never be

Each anti-pattern below produces a test that either tests the wrong thing,
breaks on harmless refactoring, or proves nothing. If a test matches any of
these, it must be rewritten.

## 1. Implementation-coupled

The test knows about internal structure. It calls private methods, mocks
internal collaborators, asserts on call counts or argument order, or verifies
through a side channel (querying the database directly instead of using the
public interface).

**The tell:** the test breaks when you refactor, but observable behaviour has
not changed.

```csharp
// BAD — coupled to internal collaborator
mockPaymentGateway.Verify(g => g.Process(It.IsAny<Order>()), Times.Once);

// GOOD — asserts observable outcome through the public seam
Assert.Equal(ChargeStatus.Confirmed, result.Status);
```

## 2. Tautological

The expected value is computed the same way the code computes it. The test
passes by construction and can never disagree with the code.

```csharp
// BAD — tautology
var expected = a + b;
Assert.Equal(expected, calculator.Add(a, b));

// BAD — snapshot derived by hand the same way
var expected = order.Total * 0.9m; // same formula as the code
Assert.Equal(expected, order.ApplyCoupon(0.1m));

// GOOD — independent source of truth
Assert.Equal(90m, order.ApplyCoupon(0.1m)); // 100 * 0.9 = 90, worked manually
```

Expected values come from: a literal constant, a manually worked example, the
specification, a known-good reference output. Never from recomputing the
formula.

## 3. Mocking what you own

Mocks are for **system boundaries** — external APIs, payment gateways, message
queues, the file system, the clock. They are not for your own classes,
interfaces you control, or internal collaborators.

```csharp
// BAD — mocking your own service
var mock = new Mock<IOrderValidator>();
mock.Setup(v => v.Validate(It.IsAny<Order>())).Returns(true);
var sut = new CheckoutService(mock.Object);

// GOOD — use the real validator, mock only the external boundary
var sut = new CheckoutService(new OrderValidator(), mockPaymentGateway.Object);
```

Mock at the boundary. Test your own code with real dependencies or test
doubles that are part of the test project, not generated mocks.

## 4. Testing private methods

Private methods are implementation details. They are tested through the public
seam that calls them. If a private method feels like it needs its own test, it
wants to be a separate class with its own public seam.

```csharp
// BAD — reaching into private method via reflection or InternalsVisibleTo
var result = InvokePrivateMethod<decimal>(sut, "CalculateTax", order);

// GOOD — test through the public seam
var result = sut.Checkout(order); // Checkout calls CalculateTax internally
Assert.Equal(expectedTotal, result.Total);
```

## 5. Testing trivial accessors

Getters, setters, and property assignments that contain no logic do not need
tests. The first scenario that exercises them through a public seam covers them.

```csharp
// BAD — testing a trivial setter
[Fact]
public void Order_SetTotal_SetsTotal()
{
    var order = new Order();
    order.Total = 100m;
    Assert.Equal(100m, order.Total);
}
```

If the setter has validation logic, test the validation through the seam that
calls the setter. If the setter is purely a data holder, skip it.

## 6. Testing framework code

The framework tests itself. Do not write tests that verify the DI container
resolves dependencies, the router maps endpoints, the serializer round-trips
JSON, or the ORM executes queries. These are framework concerns.

Test the business rule that uses the framework, not the framework itself.

```csharp
// BAD — testing the framework
[Fact]
public void Controller_IsRegistered()
{
    var controller = _serviceProvider.GetService<OrderController>();
    Assert.NotNull(controller);
}

// GOOD — testing the business rule through the controller
[Fact]
public async Task CreateOrder_WithValidCart_Returns201()
{
    var response = await _client.PostAsJsonAsync("/orders", validCart);
    Assert.Equal(HttpStatusCode.Created, response.StatusCode);
}
```

## 7. Horizontal slicing (bulk tests)

Writing all tests before any implementation. This produces tests that verify
imagined behaviour — the shape of things rather than user-facing behaviour.
Tests become insensitive to real changes.

Always work in vertical slices: one test → one implementation → repeat.

## 8. Coverage-driven tests

A test written because a coverage tool shows an uncovered line, not because a
business rule needs verification. These tests are tautological by nature — they
assert that the line executed, not that the behaviour is correct.

If coverage reveals an untested code path, ask: "What business scenario would
exercise this path?" If there is none, the path may be dead code. If there is
one, add it to the test list and test the behaviour, not the line.

## 9. Over-specifying the test

The test asserts on every field of a response object, including fields
unrelated to the scenario. When an unrelated field changes, the test fails
for the wrong reason.

```csharp
// BAD — over-specified
Assert.Equal("ORD-123", result.OrderId);
Assert.Equal(100m, result.Total);
Assert.Equal("USD", result.Currency);       // unrelated to the charge scenario
Assert.Equal("1.0", result.Version);         // unrelated
Assert.Equal(DateTime.UtcNow, result.CreatedAt); // fragile

// GOOD — asserts only what the scenario cares about
Assert.Equal(ChargeStatus.Confirmed, result.Status);
Assert.Equal(2, result.Attempts);
```

## Summary checklist

Before accepting a test, verify:

- [ ] Test uses the public seam, not internal details
- [ ] Expected value is from an independent source (literal, spec, manual calc)
- [ ] Mocks are at system boundaries only
- [ ] No private method access
- [ ] No trivial getter/setter tests
- [ ] No framework verification
- [ ] One scenario per test (no "and" in the name)
- [ ] Test would survive internal refactoring
- [ ] Assertion is on behaviour, not call counts or internal state
