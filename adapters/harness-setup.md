# Harness setup adapter contract

`numados-harness-setup` is the portable orchestration skill. A harness
repository implements the native adapter; this file defines the boundary
without prescribing one CLI or config format.

## Operations

The adapter exposes equivalent operations for:

- `discover`: return harness identity/version, active scope, native instruction
  and config paths, skill roots, environment declaration locations, effective
  and shadowed sources, and provenance. Never return secret values.
- `plan`: resolve requested Numados resources against discovered state and
  return an exact add/update/preserve/shadow/skip plan, conflict list, backup
  location, and rollback feasibility.
- `apply`: require a confirmation token or equivalent explicit approval; write
  only declared targets using native syntax, marked blocks/overlays, backups,
  and atomic/idempotent operations.
- `verify`: parse native configuration, run native discovery/status checks,
  prove effective skills and instruction precedence, and validate safety.
- `rollback`: restore the setup backup only where later user edits can be
  distinguished; otherwise stop and report the conflict.

The adapter may implement these operations as a command, MCP tool, extension,
or harness-native API. It must report the tested harness version and fail
closed when a target path, scope, precedence result, or backup cannot be
proven. Generic skill installers are not substitutes for this contract.

## Target projection

When the setup includes context instructions, generate the marked projection
required by [`../contracts/context-precedence.md`](../contracts/context-precedence.md).
Keep it concise, preserve unrelated text, and ensure the deployed contract
link resolves from the target machine.
