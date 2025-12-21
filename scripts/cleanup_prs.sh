#!/bin/bash
set -e

echo "🧹 Starting PR cleanup..."

# Close all draft PRs except #83 (CI/CD - keep for review)
echo "Closing draft PRs..."
gh pr list --state open --draft --json number,title | \
  jq -r '.[] | select(.number != 83) | .number' | \
  while read -r pr_number; do
    echo "  Closing PR #$pr_number"
    gh pr close "$pr_number" --comment "🤖 **Automated Cleanup**: Closing draft PR as part of repository consolidation. Functionality has been merged into main via PR #97 or is no longer needed." || true
  done

# Close specific obsolete PRs (duplicates and superseded)
echo "Closing obsolete PRs..."
for pr in 70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96; do
  echo "  Closing PR #$pr"
  gh pr close $pr --comment "🤖 **Automated Cleanup**: Consolidated into PR #97 or functionality no longer required." 2>/dev/null || true
done

echo "✅ PR cleanup completed"
