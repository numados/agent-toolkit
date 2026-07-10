# Harness Adapters

An adapter maps the portable source to one supported harness. It owns only:

- target-specific instruction and agent formats;
- plugin or marketplace manifests;
- MCP schema rendering;
- installation, discovery, update, and uninstall tests.

Do not copy the portable source into an adapter unless a target requires an explicit generated variant. Every adapter must record the tested client version and must preserve unmanaged user files.
