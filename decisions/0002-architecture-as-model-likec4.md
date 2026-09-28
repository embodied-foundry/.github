# 0002. Architecture as a model: C4 in LikeC4

- Status: Accepted
- Date: 2026-09-29

## Context

The architecture spans every layer down to component level, so it will be large. It must be versioned and reviewed like code, and editable by AI agents.

The notation and the tool are separate choices. For notation, the [C4 model](https://c4model.com) is the most widely used standard for software architecture, but it defines only abstraction levels and element types. It does not render anything.

Hand-drawn diagram languages (Mermaid, D2, PlantUML, draw.io) repeat each element in every diagram that shows it. At our size, that means diagrams drift apart and none of them can hold the whole picture. A **model-based** tool defines each element once and generates views from it. We considered two:

- **Structurizr DSL** is purpose-built for C4 by its creator, but its tooling is mid-consolidation (the Lite and CLI tools are archived), and its element types are fixed to C4's.
- **LikeC4** is model-based and C4-inspired, with custom element kinds (robot hardware, contracts, stores). It supports splitting the model across files by owner, an interactive drill-down viewer, `validate` for CI, PNG export, and generators for Mermaid/D2/PlantUML. It also ships an MCP server that agents can use to query the model.

## Decision

- The architecture is a single LikeC4 model in `architecture/model/`, pinned to one LikeC4 version in `package.json`.
- Each layer's components live in `model/layers/<layer>.c4`, owned by that layer's team through CODEOWNERS.
- CI validates the model and exports every view as PNG on each PR.
- Mermaid remains in use only for small non-architecture flows in docs (roadmap, git workflow).

## Consequences

- An element is defined once. Renaming or moving it updates every view.
- Reviewers see the change as `.c4` text in the diff and as rendered PNGs in the workflow artifact. Seeing it rendered inline in the PR is not possible, because GitHub does not render LikeC4.
- Viewing locally requires Node.js.
