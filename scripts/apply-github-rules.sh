#!/usr/bin/env bash
# Usage: scripts/apply-github-rules.sh [repo ...]   (defaults to every layer repo and this one)
# Idempotent: updates rulesets by name, so re-running after a merged ruleset change is safe.
set -euo pipefail

org=embodied-foundry
rulesets_dir="$(cd "$(dirname "$0")/.." && pwd)/rulesets"
repos=("$@")
[ ${#repos[@]} -gt 0 ] || repos=(.github data teleop inference)

for repo in "${repos[@]}"; do
  gh api -X PATCH "repos/$org/$repo" \
    -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false \
    -F delete_branch_on_merge=true -F allow_update_branch=true \
    -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY >/dev/null
  echo "$repo: settings"

  for file in "$rulesets_dir"/*.json; do
    name=$(jq -r .name "$file")
    id=$(gh api "repos/$org/$repo/rulesets" --jq ".[] | select(.name == \"$name\") | .id")
    if [ -n "$id" ]; then
      gh api -X PUT "repos/$org/$repo/rulesets/$id" --input "$file" >/dev/null
    else
      gh api -X POST "repos/$org/$repo/rulesets" --input "$file" >/dev/null
    fi
    echo "$repo: ruleset $name"
  done
done
