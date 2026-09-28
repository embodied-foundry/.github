# 0001. Record architecture decisions

- Status: Accepted
- Date: 2026-09-29

## Context

Several teammates and AI agents work across `data`, `teleop` and `inference` in parallel. Without a written record, the reasons behind cross-layer choices exist only in chat and memory, and agents cannot see them at all.

## Decision

Record every decision that affects a contract, more than one layer, or org conventions as an ADR in this repo, reviewed through a pull request like code.

## Consequences

- Reviewers and agents can find the reasoning next to the diagrams it shaped.
- Docs stay short because they describe only the current state and link to ADRs for the reasoning.
