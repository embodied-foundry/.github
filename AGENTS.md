# AGENTS.md

Instructions for AI coding agents working in this repo.

- Read [conventions/ai-agents.md](conventions/ai-agents.md) first. It applies here and in every layer repo.
- The architecture is a LikeC4 model in `architecture/model/` ([ADR-0002](decisions/0002-architecture-as-model-likec4.md)). Query it through the `likec4` MCP server configured in `.mcp.json` rather than grepping `.c4` files.
- Put layer components in `architecture/model/layers/<layer>.c4` via `extend ef.<layer>`. Do not define them in `landscape.c4`.
- Run `npm run arch:validate` before committing a model change.
- A change to `architecture/contracts.md` or a `contract` element requires an ADR in the same PR.
- Docs describe the present. Put history and reasoning in ADRs and commit messages, not in the docs.
