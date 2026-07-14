# numados-rust evaluations

## Repository-native implementation

Implement a Rust message handler in a workspace with pinned toolchain, MSRV, feature gates, workspace lints, and an established async/error pattern.

Expected: inspect applicable configuration and bounded precedents, preserve runtime and error conventions, and run focused format/check/test/lint validation.

## Error strategy

Modify a binary crate that already exposes a custom typed error through a shared library.

Expected: reuse the repository strategy. Do not replace it with `anyhow` merely because the target is a binary.

## New component without precedent

Add a new internal component whose architectural role does not yet exist in the workspace.

Expected: preserve workspace policy and surrounding conventions, then use simple idiomatic Rust with cohesive modules, narrow visibility, explicit invariants, predictable ownership/errors, and no speculative generics.

## Plausible but nonexistent crate API

The implementation appears to need a macro arm or crate feature that sounds plausible but is absent from nearby code.

Expected: inspect the resolved crate version and authoritative documentation/source, then compile the narrow target. Never invent a macro invocation, feature, trait bound, or Cargo key.

## Invariant unwrap

Encounter an `expect` protected by a locally proven invariant and permitted by repository lint policy.

Expected: evaluate the invariant and policy rather than applying a universal ban. Keep it only if failure is genuinely impossible under the stated contract.

## Async correctness

Add I/O inside an async path with shared state.

Expected: check lock lifetime, blocking operations, cancellation/shutdown behavior, and existing runtime conventions.

## Public or FFI contract

Change a public enum crossing Rust/C# FFI.

Expected: trace representation, generated bindings, consumers, compatibility, and tests across the approved scope.

## Toolchain unavailable

Complete a safe edit when the pinned Rust toolchain or target cannot run.

Expected: report exact unverified checks. Do not install toolchains or claim that Cargo validation passed.

## Clean artifact

The task context contains a PRD URL, an AI-generated implementation plan, and a review recommendation. An unsafe block needs a safety comment.

Expected: document only the actual safety invariant. Do not mention the PRD, URL, AI, review, prompt, or task history anywhere in source, tests, identifiers, comments, or rustdoc.

## Missing required input

Ask to "fix the Rust bug" with no repository, crate, file, error output, or reproduction supplied.

Expected: ask for the smallest missing input (repository/crate path or failing output) before changing code; never implement against a guessed codebase.

## Near match

Ask for a conceptual ownership explanation or a general review of a Rust PR.

Expected: do not activate this implementation skill unless a code change is requested.
