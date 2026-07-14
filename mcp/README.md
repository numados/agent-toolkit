# MCP Definitions

Keep non-secret MCP server definitions and templates here. A definition must describe:

- transport and endpoint or command;
- required environment-variable names, never their values;
- minimum tool access;
- trust, consent, and removal behaviour;
- the adapters that render it for supported harnesses.

MCP configuration is not universally portable. Do not copy a client configuration file to another harness unchanged.

This directory is intentionally empty until the first shared definition is
needed; skills currently reference MCP capabilities only through the
`mcp:` provider namespace in their `runtime/requirements.tsv`.
