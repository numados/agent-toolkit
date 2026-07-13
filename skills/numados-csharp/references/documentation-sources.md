# C# and .NET documentation routing

Read this reference only when a construct, API, build option, framework default, or package behavior is unfamiliar or version-sensitive.

## Resolve the active version first

Use repository evidence before searching:

- `global.json` and the selected SDK;
- target project and imported `Directory.Build.*` properties;
- effective TFM and `LangVersion`;
- central package management, assets/lock files, and resolved package version;
- analyzer, nullable, trimming/AOT, and platform settings that affect behavior.

Do not use documentation for “latest” when the repository targets an older language, runtime, or package version.

## Route the question

| Question | Primary authoritative source |
|---|---|
| C# syntax, semantics, keywords, attributes, language-version availability | [C# language reference](https://learn.microsoft.com/dotnet/csharp/language-reference/) and the relevant language-version page/specification |
| TFM and `LangVersion` selection | [Configure C# language version](https://learn.microsoft.com/dotnet/csharp/language-reference/configure-language-version) plus effective project properties |
| BCL API signature and platform/TFM availability | Microsoft Learn API reference filtered to the target framework, then reference/source assemblies when needed |
| SDK, CLI, MSBuild property, analyzer, trimming, or publishing behavior | Current Microsoft .NET/SDK/MSBuild documentation matching the installed major version |
| NuGet package API or option | Official package documentation/source and compiled metadata for the exact resolved version |
| New public API shape with no repository precedent | Repository contracts first, then [.NET Framework Design Guidelines](https://learn.microsoft.com/dotnet/standard/design-guidelines/) as trade-off guidance, not an automatic mandate |
| General fallback style for a genuinely new component | Repository `.editorconfig`/analyzers first, then [Microsoft C# coding conventions](https://learn.microsoft.com/dotnet/csharp/fundamentals/coding-style/coding-conventions) |

Prefer local source, generated code, type metadata, and tests when they define a project-specific wrapper or contract. Use external documentation to verify the underlying language/framework behavior, not to replace repository architecture.

## Verification

Record only the facts needed for the implementation: exact symbol/signature, version availability, defaults, failure behavior, and compatibility constraints. Compile the affected target after applying them. If docs and compiler disagree, inspect effective imports, target framework, package resolution, conditional symbols, and SDK selection before changing syntax by trial and error.
