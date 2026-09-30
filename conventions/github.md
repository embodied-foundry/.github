# GitHub rules

Every repo gets the same rules, stored as code in [`rulesets/`](../rulesets/) and applied by [`scripts/apply-github-rules.sh`](../scripts/apply-github-rules.sh) ([ADR-0004](https://github.com/embodied-foundry/architecture/blob/main/decisions/0004-github-rules-as-code.md)). Enforcing them on private repos requires the GitHub Team plan or higher.

## Rulesets

### `main` ([rulesets/main.json](../rulesets/main.json))

Targets the default branch. No bypass actors, including admins.

| Rule | Why |
| --- | --- |
| Changes only through a pull request | No direct pushes to `main` from humans or agents |
| 1 approving review | Every change is seen by a second person |
| Code owner review | The owning team signs off on its area |
| Approval of the most recent push | An agent or author push after approval needs a fresh approval, so nothing unreviewed slips in |
| Dismiss stale approvals on push | Same reason, applied to earlier approvals |
| All review threads resolved | Comments cannot be silently ignored |
| Squash merge only | One Conventional Commit per PR on `main` |
| Linear history | Follows from squash-only and keeps `git log` readable |
| Block force-push and deletion | `main` history is permanent |

Required status checks are added per repo once that repo has CI. Add a `required_status_checks` rule to the repo's own ruleset, not to the shared file.

### Release tags ([rulesets/release-tags.json](../rulesets/release-tags.json))

Targets `refs/tags/v*`. Blocks updates and deletion, so a released version always points at the same commit.

## Repository settings

Applied by the same script:

| Setting | Value |
| --- | --- |
| Merge methods | Squash only |
| Squash commit message | PR title + PR body |
| Delete head branch on merge | On |
| Suggest updating PR branch | On |

## Teams

CODEOWNERS refers to these teams, which must exist in the org:

| Team | Owns |
| --- | --- |
| `maintainers` | Org-wide files, rulesets, and the final say on cross-layer changes |
| `data` | `data` repo |
| `teleop` | `teleop` repo |
| `inference` | `inference` repo |

## Bootstrapping a new repo

A `main` ruleset blocks the initial push, so the order matters:

1. Push the initial commit to `main`.
2. Run `scripts/apply-github-rules.sh <repo>`.
3. Everything after that goes through pull requests.
