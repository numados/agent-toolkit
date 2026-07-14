# Harness Adapter Boundaries

The portable toolkit defines adapter boundaries but does not need to contain a
full implementation for every harness. A separate adapter repository may own
the runtime integration when it has its own extensions, agents, installers, or
tests.

An adapter owns only:

- target-specific instruction and agent formats;
- plugin or marketplace manifests;
- MCP schema rendering;
- installation, discovery, update, and uninstall tests.

Apply [`execution-safety.md`](execution-safety.md) to every adapter. Keep the
portable contract in `contracts/`; adapters should contain only the concise
instruction projection and the harness-native enforcement needed for their
target. A prompt, copied rule, or Git hook alone is not a hard safety boundary.

Apply [`../contracts/context-precedence.md`](../contracts/context-precedence.md)
to skill and instruction discovery. Corporate/project context must be resolved
above Numados base context, with same-name shadowing, explicit extension, and
diagnostics for overridden or ambiguous sources. Do not implement precedence
through filesystem order or an undocumented adapter-specific exception.

The adapter installer must place a concise, idempotent precedence projection
and a valid link to the full contract into the target instruction surface.
Links alone are insufficient because a harness may not dereference them;
preserve the minimum rule text in the managed block and never emit an invalid
source-checkout-only path.

Do not copy the portable source into an adapter unless a target requires an
explicit generated variant. Every adapter must record the tested client
version and must preserve unmanaged user files.

The current PI integration is maintained in the separate `pi-agent-toolkit`
repository.

The single portable setup workflow uses the [harness setup adapter contract](harness-setup.md);
native implementations remain in each harness repository.
