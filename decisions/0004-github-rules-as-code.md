# 0004. GitHub rules as code

- Status: Accepted
- Date: 2026-09-29

## Context

Many branches are worked on in parallel, often by AI agents, but `main` must only change after a teammate reviews. Settings clicked into the GitHub UI drift between repos and leave no history.

## Decision

Keep repository rulesets as JSON in [`rulesets/`](../rulesets/) and apply them, together with the merge settings, with [`scripts/apply-github-rules.sh`](../scripts/apply-github-rules.sh). The rules are described in [conventions/github.md](../conventions/github.md).

## Consequences

- A rule change is a reviewed PR, and every repo gets the same rules.
- Enforcing rulesets on private repos requires the GitHub Team plan or higher.
- Someone with org admin rights must re-run the script after a ruleset change is merged.
