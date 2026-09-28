# Architecture Decision Records

One file per decision, numbered, in [MADR](https://adr.github.io/madr/) style. Copy [template.md](template.md).

- An ADR is immutable once accepted. To change a decision, write a new ADR that supersedes it and set the old one's status to `Superseded by ADR-NNNN`.
- Decisions scoped to one layer live in that layer repo's `docs/decisions/`. Decisions that touch contracts or more than one layer live here.

| ADR | Title | Status |
| --- | --- | --- |
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions | Accepted |
| [0002](0002-architecture-as-model-likec4.md) | Architecture as a model: C4 in LikeC4 | Accepted |
| [0003](0003-layers-depend-on-contracts.md) | Layers depend on contracts, not on each other | Accepted |
| [0004](0004-github-rules-as-code.md) | GitHub rules as code | Accepted |
