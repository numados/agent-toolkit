---
name: numados-csharp
description: Implement or modify C# and .NET code so it fits the target repository's language version, architecture, conventions, contracts, and verification workflow. Use for requested C# implementation, bug fixes, refactoring, tests, project-file changes, or API integration. Do not activate for a general code review or a conceptual C# explanation with no requested code change.
---

# Numados C#

Make the smallest complete C# change that satisfies the requested behavior and looks native to the repository.

## Establish repository context

Before editing:

1. Read repository instructions and the relevant requirement or failing behavior.
2. Locate the target solution/project and inspect the applicable `global.json`, project files, `Directory.Build.*`, `Directory.Packages.props`, `.editorconfig`, analyzer settings, and test project.
3. Determine the effective target framework, C# language version, nullable mode, warning policy, package-management convention, and formatter.
4. Inspect a bounded set of nearby implementations and tests that exercise the same architectural role. Expand the search only when those examples conflict or do not establish the contract.

Repository precedent is evidence, not an excuse to reproduce a defect. If precedent conflicts with the requirement, a security boundary, public compatibility, or enforced tooling, follow the stronger contract and explain the narrow deviation.

Use this priority when guidance conflicts:

1. requested behavior and durable domain/public contracts;
2. compiler correctness, security, data integrity, and compatibility;
3. repository instructions, analyzers, and build policy;
4. established patterns in the affected component;
5. current official .NET guidance for a genuinely new pattern.

Follow valid local patterns when extending existing code. For a new component with no useful precedent, use simple idiomatic C#: intention-revealing names, cohesive types and methods, explicit invariants, narrow public surface, low coupling, and no speculative abstraction. Do not introduce a new architecture merely to make the code look “clean.”

## Implement

- Preserve existing layering, dependency injection, naming, namespace, error, logging, async, serialization, and test patterns.
- Use only language features supported by the effective `LangVersion` and SDK. Consult current official documentation when defaults or APIs are version-sensitive.
- Reuse an existing abstraction when it expresses the same contract. Avoid unrelated modernization or architecture changes.
- Add a dependency only when the task requires it, the repository's package policy is understood, and the user has authorized the resulting scope.
- Keep public API, persisted data, message schemas, and configuration backward compatible unless the requested change explicitly alters that contract.

Apply correctness checks when relevant:

- preserve nullable and validation guarantees at input boundaries;
- propagate cancellation through asynchronous I/O where the surrounding contract supports it;
- catch only exceptions that can be handled meaningfully at that layer; let the repository's boundary policy handle the rest;
- verify culture, time-zone, numeric, serialization, database, and concurrency semantics from the actual contract rather than applying universal defaults;
- update registrations, generated contracts, migrations, consumers, and completeness tests when the changed behavior requires them.

## Documentation gate

Do not invent syntax, attributes, APIs, overloads, package behavior, compiler options, or framework defaults.

Read [documentation routing](references/documentation-sources.md) when the implementation uses an unfamiliar or version-sensitive surface.

1. Identify the effective TFM, `LangVersion`, SDK, and resolved package version from repository files.
2. Prefer repository source, generated types, package metadata, and compiling examples for project-specific contracts.
3. Before using an unfamiliar or version-sensitive construct, verify its exact syntax, signature, availability, nullability, and runtime behavior in current official documentation for those effective versions.
4. Build the smallest affected target soon after introducing the construct. Treat compiler and analyzer diagnostics as evidence; investigate version/configuration mismatch instead of guessing alternative syntax.

If authoritative documentation or the required package source is unavailable, reuse a verified repository precedent or report the uncertainty. Never manufacture a plausible-looking API.

## Artifact hygiene

- Keep source, tests, identifiers, comments, and XML documentation about the maintained behavior, domain contract, or a non-obvious invariant.
- Prefer self-explanatory code; comments explain durable reasons or constraints, not obvious mechanics.
- Do not mention AI, prompts, PRDs, task/review links, reviewer recommendations, sessions, implementation plans, or “as requested” history in code or comments.
- Do not leave transient TODOs, debugging notes, review replies, or planning text. A durable external standard link is acceptable only when the implementation directly depends on it and repository convention permits it.

## Verify

Use the repository's configured commands and narrowest useful scope:

1. format changed files when a formatter is configured;
2. build the affected project or solution boundary;
3. run focused regression tests, then broader tests only when risk or repository policy warrants it;
4. run configured analyzers or validation targets.

Inspect the final diff for accidental generated files, package churn, unrelated formatting, incomplete contract propagation, and process metadata in code or comments. If the required SDK, dependency restore, service, or test environment is unavailable, report exactly what remains unverified instead of claiming success.

## Guardrails

- Do not change solution-wide settings, package policy, formatting policy, or architecture unless required by the task.
- Do not add speculative helpers, validation, comments, or abstractions.
- Do not hide warnings, broad exceptions, or failing tests to make verification pass.
- Do not depend on a named MCP, plugin, or IDE. Use any applicable code-navigation or documentation provider already available in the harness.
