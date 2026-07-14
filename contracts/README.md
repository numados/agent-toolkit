# Contracts

Contracts are versioned agreements that agent context must respect. Typical contracts include:

- output formats and quality gates;
- tool permissions and confirmation boundaries;
- repository ownership and update policy;
- MCP interface expectations;
- terminology and decision records.

Each contract should identify its owner, scope, compatibility impact, and verification method. Prefer a small number of clear contracts over duplicated rules embedded in many skills.

Current contracts:

- [Execution safety](execution-safety.md): block agent remote writes and require explicit approval for dangerous local or external mutations.
- [Change artifact hygiene](change-artifact-hygiene.md): keep code, comments, tests, and commit messages free of unrelated process provenance.
- [Git-backed knowledge history](git-backed-knowledge-history.md): searchable, safe commit metadata for file-based knowledge stores.
- [Skill runtime capabilities](skill-runtime-capabilities.md): portable provider declarations and machine-readiness semantics.
- [Context precedence](context-precedence.md): corporate/project context precedence over Numados base context across harnesses.
- [Development workflow artifacts](development-workflow-artifacts.md): evidence-grounded task handoffs from research through implementation review.
