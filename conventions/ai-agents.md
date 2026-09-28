# Working with AI agents

Agents are welcome on any branch. `main` only changes after a human teammate reviews.

## Rules

1. **Own branch per agent task.** Use a git worktree per task so parallel agents never share a working tree. Name the branch like any other ([git-workflow.md](git-workflow.md)).
2. **Never push to `main`.** The `main` ruleset enforces this ([github.md](github.md)).
3. **A human is accountable.** The person who opens the PR has read every line, ticks the AI-involvement box in the PR template, and answers review comments.
4. **A different human reviews.** An agent review can come before human review but never replaces it. Because the ruleset requires approval of the last push, an agent push after approval needs re-approval.
5. **Context comes from the repo.** Agents read `AGENTS.md`, the contracts and the ADRs, not chat history. If a decision matters and is not written down, write the ADR first.
6. **Keep the same standards.** Conventional Commits without scope, one concern per PR, and the code rules in [repositories.md](repositories.md).
