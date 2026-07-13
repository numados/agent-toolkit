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

Do not copy the portable source into an adapter unless a target requires an
explicit generated variant. Every adapter must record the tested client
version and must preserve unmanaged user files.

The current PI integration is maintained in the separate `pi-agent-toolkit`
repository.
