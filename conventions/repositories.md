# Repository conventions

## Naming

Lowercase kebab-case, named for the layer's role (`data`, `teleop`, `inference`), not for a framework or robot.

## Required files in every layer repo

| File | Purpose |
| --- | --- |
| `README.md` | What the layer does, which contracts it produces and consumes, and how to run it |
| `AGENTS.md` | Agent instructions for this repo, linking to [ai-agents.md](ai-agents.md) |
| `CLAUDE.md` | A single line, `@AGENTS.md` |
| `CODEOWNERS` | The layer's team, plus `maintainers` on contract code |
| `docs/decisions/` | Layer-scoped ADRs, same template as the [org ADRs](https://github.com/embodied-foundry/architecture/tree/main/decisions) |

The layer's architecture is not kept in the layer repo. Its components live in the [`architecture`](https://github.com/embodied-foundry/architecture) repo at `model/layers/<layer>.c4`, owned by the layer team, and the layer README links to it.

CONTRIBUTING and the PR template are inherited from this repo unless a layer overrides them.

## Code and docs

- Validate at trust boundaries (user input, hardware, network, files from outside the org), not between trusted internal modules.
- Comments explain *why* (a constraint, invariant or workaround), never *what*.
- Docs describe the present. History and reasoning go into commits and ADRs.
- Delete dead code cleanly. Do not leave "removed" markers or compatibility shims that nothing uses.
- Generalize on the third occurrence, not the first.
