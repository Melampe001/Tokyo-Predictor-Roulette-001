#!/bin/bash
# Secure version of cleanup_branches.sh
# Security improvements: input validation, proper handling, logging

set -euo pipefail

echo "🌿 Starting branch cleanup (SECURE MODE)..."
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Error: Not in a git repository" >&2
  exit 1
fi

# Fetch latest and prune deleted remote branches
echo "Fetching latest changes and pruning..."
if ! git fetch --all --prune 2>&1; then
  echo "⚠️  Warning: git fetch failed" >&2
fi

echo ""

# Delete local branches that no longer exist on remote
echo "Cleaning local branches..."

# Security: Validate branch names before deletion
DELETED_COUNT=0
SKIPPED_COUNT=0

git branch -vv | grep ': gone]' | awk '{print $1}' | while IFS= read -r branch; do
  # Security: Validate branch name format (alphanumeric, slash, dash, underscore)
  if [[ ! "$branch" =~ ^[a-zA-Z0-9/_.-]+$ ]]; then
    echo "  ⚠️  Skipping branch with invalid characters: '$branch'" >&2
    ((SKIPPED_COUNT++)) || true
    continue
  fi
  
  # Don't delete current branch
  current_branch=$(git branch --show-current)
  if [[ "$branch" == "$current_branch" ]]; then
    echo "  ⚠️  Skipping current branch: $branch" >&2
    ((SKIPPED_COUNT++)) || true
    continue
  fi
  
  # Don't delete main/master branches (safety check)
  if [[ "$branch" =~ ^(main|master|develop|development)$ ]]; then
    echo "  ⚠️  Skipping protected branch: $branch" >&2
    ((SKIPPED_COUNT++)) || true
    continue
  fi
  
  echo "  Deleting local branch: $branch"
  # Security: Properly quoted variable
  if git branch -D "$branch" 2>&1; then
    echo "    ✅ Deleted successfully"
    ((DELETED_COUNT++)) || true
  else
    echo "    ⚠️  Failed to delete" >&2
    ((SKIPPED_COUNT++)) || true
  fi
done

echo ""

# List remaining branches for manual review
echo "📊 Remaining remote branches:"
BRANCH_COUNT=$(git branch -r | grep -v HEAD | grep -vc main || echo "0")
echo "  Total remote branches (excluding main): $BRANCH_COUNT"

echo ""
echo "✅ Branch cleanup completed"
echo "   Local branches deleted: $DELETED_COUNT"
echo "   Branches skipped: $SKIPPED_COUNT"
echo ""
echo "⚠️  Remote branches preserved - delete manually via GitHub UI if needed"
echo "   To view remote branches: git branch -r"
