# Rust documentation routing

Read this reference only when a construct, API, macro, feature, Cargo option, safety rule, or crate behavior is unfamiliar or version-sensitive.

## Resolve the active version first

Use workspace evidence before searching:

- target crate and workspace `Cargo.toml`;
- `edition`, `rust-version`, and pinned `rust-toolchain*`;
- enabled default/optional features and target configuration;
- `Cargo.lock` or other repository lock policy for resolved crate versions;
- workspace lint, formatting, deny, build-script, and generated-binding configuration.

Do not copy syntax or crate APIs from current/latest documentation when the workspace's MSRV or resolved dependency is older.

## Route the question

| Question | Primary authoritative source |
|---|---|
| Rust syntax, semantics, attributes, trait/lifetime rules | [The Rust Reference](https://doc.rust-lang.org/reference/) for the applicable stable/toolchain behavior |
| Edition-specific syntax or migration | [Rust Edition Guide](https://doc.rust-lang.org/edition-guide/) plus the crate's selected edition |
| Standard-library API and stability | Standard-library documentation matching the active toolchain, then Rust source when needed |
| Cargo manifest keys, feature resolution, workspace, build, or test behavior | [The Cargo Book](https://doc.rust-lang.org/cargo/) matching the active Cargo/toolchain |
| Compiler lint or Clippy behavior | rustc lint documentation or [Clippy documentation](https://doc.rust-lang.org/clippy/) plus repository lint configuration |
| External crate API, macro, or feature | Official crate documentation/source for the exact resolved version and its enabled features |
| New public API with no repository precedent | Repository contracts first, then [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) as non-mandatory trade-off guidance |
| Formatting for a genuinely new component | Repository rustfmt configuration first, then [Rust Style Guide](https://doc.rust-lang.org/style-guide/) defaults |

Prefer local source, generated bindings, dependency source/types, examples compiled by the repository, and tests when they define a project-specific contract. External docs verify language/tool/crate behavior; they do not override workspace architecture.

## Verification

Record only the facts needed for implementation: exact item or macro form, stability/MSRV, feature gates, safety requirements, error behavior, and compatibility constraints. Run the narrowest relevant check/build/test. If docs and compiler disagree, inspect selected toolchain, target, edition, features, dependency resolution, build scripts, and conditional compilation before trying guessed syntax.
