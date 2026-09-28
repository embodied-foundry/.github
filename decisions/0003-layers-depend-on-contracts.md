# 0003. Layers depend on contracts, not on each other

- Status: Accepted
- Date: 2026-09-29

## Context

`data`, `teleop` and `inference` are separate repos so they can be reused and developed in parallel. If they import each other's internals, that independence is lost.

## Decision

- Layers communicate only through the contracts C1–C6 in [architecture/contracts.md](../architecture/contracts.md).
- Teleop and inference both implement the C3 Controller contract against the C2 Robot interface. Recording is a sink on that interface, so demonstrations and policy rollouts share the C4 Episode format.
- Contracts are semver-versioned. A breaking change needs an ADR and approval from every consuming layer.

## Consequences

- A layer can be replaced or reused elsewhere if it honours the contracts.
- Human intervention during rollouts needs no special data path.
- The contracts need a code home. Whether that is a `core` package is an open roadmap decision.
