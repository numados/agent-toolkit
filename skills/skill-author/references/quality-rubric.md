# Skill Quality Rubric

## Correct Primitive

- Use a skill for a narrow, repeatable workflow that loads on demand.
- Use an instruction for always-applicable contracts or baseline knowledge.
- Use an agent for a separate role, authority boundary, or tool set.

## Metadata and Routing

- The directory name, `name`, and references agree.
- The description names the capability and the situations that should activate it.
- The description is specific enough to avoid activation for adjacent tasks.

## Workflow

- Inputs, preconditions, procedure, output, verification, and stop conditions are explicit.
- The main file contains only essential procedure.
- Detailed content is directly linked from `SKILL.md`.
- Scripts are necessary, deterministic where possible, and documented.

## Safety and Portability

- No secrets, destructive default action, hidden network call, or unreviewed external dependency.
- Tool assumptions and MCP requirements are explicit.
- Runtime-dependent skills declare required and optional provider alternatives in `runtime/requirements.tsv`.
- Client-specific fields and configuration stay in adapters.

## Evaluation

- Test a clear positive prompt.
- Test a near-match prompt that should not activate or should route elsewhere.
- Test missing required input.
- Test tool, script, or dependency failure.
- Test discovery and removal on every supported harness.
