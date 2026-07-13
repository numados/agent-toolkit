# Search routing policy

## Selection order

Choose the first ready provider that expresses the query without avoidable scanning or post-filtering.

| Query class | Preferred route | Escalate when |
|---|---|---|
| Exact path or basename | `rg --files` or `fd` | path is unknown across explicitly approved roots |
| Exact text or identifier | fixed-string `rg -l`, then snippets | aliases or terminology are uncertain |
| Regex text | bounded `rg` regex | syntax rather than text is the real constraint |
| Code structure | verified `ast-grep` or harness structural search | relationships require semantic code retrieval |
| Conceptual code/Markdown | applicable harness semantic retrieval | provider cannot access the root or ranking is weak |
| Obsidian semantic | applicable harness retrieval, native provider, or ready QMD | lexical results are weak and terminology differs |
| PDF/Office/archive | verified `rga` or document MCP | extractor lacks the requested file format |
| Machine-wide filename | fresh `plocate`-like index | index scope or freshness is unknown |
| Git provenance | `git log --follow -- <path>` | no current path or stable identifier is known |

## Staged retrieval

1. Find paths only and cap the candidate set.
2. Rank using path, title, exact phrase, and query-term coverage.
3. Read one or two snippets from the best candidates.
4. Escalate to semantic retrieval only when lexical evidence is weak or the query is conceptual.
5. Verify semantic candidates with a bounded source read.

Several narrow lexical queries are cheaper than one broad dump. Semantic retrieval can improve ranking but may add network latency and excessive excerpts; request paths and decisive evidence only, then enforce bounds in the active agent.

## Provider proof

Before selecting a provider, establish:

- identity: the executable or tool performs the advertised operation;
- scope: it can read every requested root;
- mode: filename, lexical, structural, semantic, or extracted-document search matches the request;
- bounds: output can be limited or safely post-filtered;
- freshness: an index reflects sufficiently current files;
- side effects: no unapproved indexing, model download, GUI launch, or mutation;
- privacy: sending content outside the local process is allowed for this root.

Do not infer tool identity from a short command name. For example, some systems provide an unrelated `/usr/bin/sg`; require `ast-grep --version` or output that explicitly identifies ast-grep.

## Subagent delegation

Delegate only independent branches. Good examples are separate repositories, distinct file types requiring different providers, or parallel lexical and semantic candidate generation. Each branch returns paths and concise evidence, never a raw corpus dump.

Keep a single search in the active agent when startup and merge costs exceed the search itself. A subagent changes context isolation and parallelism; it does not improve the underlying provider's index or matching algorithm.
