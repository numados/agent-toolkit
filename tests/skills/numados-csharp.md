# numados-csharp evaluations

## Repository-native implementation

Implement a C# handler in a repository with pinned SDK, nullable enabled, centralized packages, custom analyzers, and an established handler/test pattern.

Expected: inspect applicable configuration and bounded precedents, implement the smallest complete change, preserve package policy, and run focused build/tests/analyzers.

## Conflicting precedent

Nearby old code catches every exception, but repository instructions and the active boundary policy require selective handling.

Expected: do not blindly copy the defect. Follow the stronger contract and explain the narrow deviation.

## Version-sensitive API

The implementation depends on an API whose availability differs by target framework or package version.

Expected: inspect effective versions and consult authoritative version-matched documentation instead of relying on a hardcoded framework table.

## New component without precedent

Add a new internal component whose architectural role does not yet exist in the repository.

Expected: preserve repository-wide structure and tooling, then use simple idiomatic C# with cohesive responsibilities, narrow surface, explicit invariants, and no speculative abstractions. Do not import an unrelated architecture from external examples.

## Plausible but nonexistent API

The requested implementation appears to need an overload or attribute that sounds plausible but is absent from nearby code.

Expected: verify the exact API against the resolved framework/package documentation and compile early. If it does not exist, select a documented alternative or report the boundary; never emit guessed syntax.

## Contract propagation

Change a public enum or serialized contract consumed by tests and another in-scope project.

Expected: trace and update required registrations, generated surfaces, consumers, and completeness tests without unrelated refactoring.

## Toolchain unavailable

Complete a safe edit when the required .NET SDK cannot run.

Expected: preserve the change but report exact build/test boundaries as unverified. Do not claim validation passed or install an SDK implicitly.

## Clean artifact

The task context contains a PRD URL, an AI-generated implementation plan, and a review recommendation. The implementation needs one comment explaining a non-obvious compatibility invariant.

Expected: write only the durable compatibility explanation. Do not mention the PRD, URL, AI, review, prompt, or task history anywhere in code, tests, identifiers, comments, or XML documentation.

## Missing required input

Ask to "fix the C# bug" with no repository, project, file, error output, or reproduction supplied.

Expected: ask for the smallest missing input (repository/project path or failing output) before changing code; never implement against a guessed codebase.

## Near match

Ask for a conceptual explanation of nullable reference types or a general review of an existing C# PR.

Expected: do not activate this implementation skill unless a code change is requested.
