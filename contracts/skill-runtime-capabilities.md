# Skill runtime capabilities

## Ownership

- Owner: numados toolkit
- Scope: portable Agent Skills with machine, harness, CLI, MCP, or indexed-provider requirements
- Consumer: `numados-skill-doctor` and future deployment adapters

## Manifest

A skill may declare runtime needs in `runtime/requirements.tsv`. This file is not injected into normal skill context; the doctor reads it on demand.

Use exactly five tab-separated columns:

```text
# capability<TAB>need<TAB>when<TAB>providers<TAB>purpose
filesystem.lexical<TAB>required<TAB>content search<TAB>cmd:rg|mcp:filesystem-search<TAB>Find bounded candidates
```

- `capability`: stable lowercase identifier using letters, digits, `.`, `_`, or `-`.
- `need`: `required` or `optional`.
- `when`: operation that activates the requirement.
- `providers`: `|`-separated alternatives using `cmd:`, `verified:`, `harness:`, or `mcp:`.
- `purpose`: concise reason the capability exists.

Do not put install commands, absolute machine paths, credentials, versions, or provider configuration in the manifest.

Use `cmd:<name>` only when command presence is enough to use it safely. Use `verified:<name>` when readiness requires additional proof: a stateful index, downloaded model, running application, authenticated session, target-specific configuration, Git worktree, or command identity where aliases may collide. The doctor counts a `verified:` provider only when the active agent passes the same value through `--provide` after a read-only identity or readiness check.

## Provider states

A discovered provider is not automatically usable. Report these states separately:

1. `available`: command or tool exists.
2. `applicable`: provider supports the operation and can access the target scope.
3. `ready`: use requires no unapproved download, index build, GUI launch, daemon, network call, or mutation.

Only a ready provider satisfies a requirement. When scope or readiness cannot be verified, report `unknown` and do not pass the provider to the deterministic probe.

## Recommendation boundary

- Prefer existing applicable harness or MCP providers over duplicate installations.
- Recommend a missing optional provider only for a requested or demonstrably inefficient feature.
- Explain ongoing index, model, service, network, storage, and privacy costs.
- Never install, enable, configure, index, or download as part of diagnosis.
- Require a separate explicit request before changing machine or harness state.

## Compatibility

Skills without a manifest remain loadable. The doctor reports them as `UNDECLARED` and derives provisional requirements from `SKILL.md` and referenced scripts; those inferences must not be treated as verified declarations.

## Verification

- The repository validator accepts every manifest row and rejects malformed fields or providers.
- The doctor distinguishes command presence from target-scoped harness/MCP applicability.
- Missing required providers produce `BLOCKED`; missing optional providers produce `READY WITH OPTIONAL GAPS`.
- Reports contain no machine-local path except evidence from the machine currently being audited.
