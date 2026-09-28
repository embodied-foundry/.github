# 0002. Diagrams as code: C4 model in Mermaid

- Status: Accepted
- Date: 2026-09-29

## Context

The architecture must be versioned and reviewed like code, detailed enough to be useful, and editable by AI agents. Options considered: Mermaid, Structurizr DSL, D2, PlantUML, draw.io.

The notation question and the tool question are separate. For notation, the [C4 model](https://c4model.com) (context → containers → components → code) is the most widely used standard for software architecture. For the tool:

- **Mermaid** is rendered natively by GitHub in Markdown, PR diffs and the rich-diff view, needs no build step, and is the diagram language AI agents write most reliably.
- **Structurizr DSL** is purpose-built for C4, with one model and many views, but needs a renderer in CI, and reviewers see DSL text rather than a picture.
- **D2** gives the best layout control, but it also needs CI rendering, and agents know it less well.
- **draw.io** is visual, but its XML diffs are unreviewable.

## Decision

Use C4 levels as the notation and Mermaid `flowchart` as the syntax, styled with these classes:

| Class | Use | Style |
| --- | --- | --- |
| `person` | Humans | `fill:#08427b,color:#fff` |
| `system` | embodied-foundry as a whole | `fill:#1168bd,color:#fff` |
| `container` | A layer / repo / runtime unit | `fill:#438dd5,color:#fff` |
| `planned` | Does not exist yet | white fill, dashed `#438dd5` border |
| `external` | Outside our control | `fill:#6b6b6b,color:#fff` |

Do not use Mermaid's experimental `C4Context` / `C4Container` syntax, which lays out poorly on GitHub.

Levels 1–2 live in this repo. Level 3 lives in each layer repo.

## Consequences

- Reviewers see rendered diagrams directly in the PR.
- Mermaid's auto-layout limits fine positioning. If a diagram outgrows it, a later ADR may allow D2 for that diagram with CI-rendered SVGs committed next to the source.
