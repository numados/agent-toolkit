---
name: numados-rust
description: Implement or modify Rust code so it fits the target crate's edition, MSRV, workspace policies, architecture, contracts, and verification workflow. Use for requested Rust implementation, bug fixes, refactoring, tests, Cargo changes, async code, or FFI integration. Do not activate for a general code review or a conceptual Rust explanation with no requested code change.
---

# Numados Rust

Make the smallest complete Rust change that satisfies the requested behavior and integrates with the existing crate or workspace.

## Establish repository context

Before editing:

1. Read repository instructions and the relevant requirement or failing behavior.
2. Inspect the target and workspace `Cargo.toml`, `rust-toolchain*`, `.cargo/config*`, lint, formatting, dependency-policy, and test configuration that apply to the change.
3. Determine edition, MSRV, enabled features, target platforms, crate boundaries, async runtime, error model, unsafe policy, and workspace validation commands.
4. Inspect a bounded set of nearby modules and tests with the same role. Expand only when they conflict or do not establish the contract.

Repository precedent is evidence, not a mandate to repeat a bug. If precedent conflicts with the requirement, soundness, security, compatibility, or enforced tooling, follow the stronger contract and explain the narrow deviation.

Use this priority when guidance conflicts:

1. requested behavior and durable domain/public contracts;
2. compiler correctness, soundness, security, and compatibility;
3. repository instructions, lints, and workspace policy;
4. established patterns in the affected crate/component;
5. current official Rust guidance for a genuinely new pattern.

Follow valid local patterns when extending existing code. For a new component with no useful precedent, use simple idiomatic Rust: intention-revealing names, cohesive modules and types, explicit invariants, predictable ownership and errors, narrow visibility, and no speculative generic abstraction. Do not redesign the workspace merely to make the code look “clean.”

## Implement

- Preserve module boundaries, visibility, ownership style, error types, logging, serialization, feature gates, async runtime, and testing patterns.
- Respect edition and MSRV. Verify version-sensitive language, standard-library, and crate APIs from current documentation for the versions in the workspace.
- Prefer borrowing when it makes ownership simpler, but choose ownership from lifetime and API needs rather than a fixed borrow-before-clone rule.
- Reuse the crate's existing error strategy. Do not select an error library solely because a target is a library or binary.
- Handle fallible paths explicitly. `unwrap` or `expect` is acceptable only where the repository permits it and the invariant is locally obvious; production input and I/O paths normally require propagation or deliberate handling.
- Avoid holding blocking locks across `.await`, accidental blocking I/O on async executors, unnecessary allocation, and unbounded work on external input.
- Add dependencies, features, unsafe code, or FFI surface only when required by the task and after checking workspace policy and downstream contracts.

For public APIs, document material errors, panic conditions, safety requirements, and compatibility implications in the repository's established style.

## Documentation gate

Do not invent syntax, attributes, trait bounds, standard-library APIs, crate features, Cargo keys, or macro behavior.

Read [documentation routing](references/documentation-sources.md) when the implementation uses an unfamiliar or version-sensitive surface.

1. Identify the effective edition, `rust-version`/toolchain, enabled features, targets, and resolved crate versions from workspace configuration and lockfiles.
2. Prefer repository source, generated bindings, dependency source/types, and compiling examples for project-specific contracts.
3. Before using an unfamiliar or version-sensitive construct, verify its exact syntax, stability, feature requirements, signatures, safety contract, and edition/MSRV support in the Rust Reference, standard-library/Cargo documentation, or authoritative docs/source for the resolved crate version.
4. Run the narrowest relevant compiler check soon after introducing the construct. Remember that `cargo check` can miss errors emitted only during code generation; use build/tests when that distinction matters.

If authoritative documentation or dependency source is unavailable, reuse a verified repository precedent or report the uncertainty. Never manufacture a plausible-looking crate API or macro invocation.

## Artifact hygiene

- Keep source, tests, identifiers, comments, and rustdoc about maintained behavior, public contracts, safety invariants, or non-obvious constraints.
- Prefer self-explanatory code; comments explain durable reasons, invariants, or safety conditions, not obvious mechanics.
- Do not mention AI, prompts, PRDs, task/review links, reviewer recommendations, sessions, implementation plans, or “as requested” history in code or comments.
- Do not leave transient TODOs, debugging notes, review replies, or planning text. A durable external standard link is acceptable only when the implementation directly depends on it and repository convention permits it.

## Verify

Use repository commands and the narrowest useful package/feature/target scope:

1. check formatting;
2. compile with the relevant features and targets;
3. run focused unit, integration, and documentation tests affected by the change;
4. run configured Clippy, deny, Miri, FFI, or workspace checks when applicable.

Inspect the final diff for lockfile churn, feature leakage, generated artifacts, accidental public API expansion, unrelated formatting, and process metadata in code or comments. If the toolchain, target, dependency source, external service, or test environment is unavailable, report the exact unverified boundary.

## Guardrails

- Do not change workspace-wide lint, formatting, profile, resolver, or dependency policy unless the task requires it.
- Do not suppress diagnostics or add broad `allow` attributes without a narrow documented reason.
- Do not introduce unsafe code without stating and checking its safety invariant.
- Do not over-generalize an API before multiple concrete callers require it.
- Do not depend on a named MCP, plugin, or IDE. Use any applicable navigation or documentation provider already available.
