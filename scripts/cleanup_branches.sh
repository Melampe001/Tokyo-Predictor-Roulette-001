#!/bin/bash
set -e

echo "🌿 Starting branch cleanup..."

# Fetch latest and prune deleted remote branches
git fetch --all --prune

# Delete local branches that no longer exist on remote
echo "Cleaning local branches..."
git branch -vv | grep ': gone]' | awk '{print $1}' | while read -r branch; do
  echo "  Deleting local branch: $branch"
  git branch -D "$branch" 2>/dev/null || true
done

# List branches for manual review (don't auto-delete remote branches)
echo ""
echo "📊 Remaining remote branches:"
BRANCH_COUNT=$(git branch -r | grep -v HEAD | grep -vc main || true)
echo "  Total remote branches (excluding main): $BRANCH_COUNT"

echo "✅ Branch cleanup completed"
echo "⚠️  Remote branches preserved - delete manually via GitHub UI if needed"
