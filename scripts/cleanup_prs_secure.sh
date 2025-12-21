#!/bin/bash
# Secure version of cleanup_prs.sh
# Security improvements: input validation, proper quoting, error handling, rate limiting

set -euo pipefail

# Security: Validate numeric inputs
validate_number() {
  [[ "$1" =~ ^[0-9]+$ ]] || return 1
}

# Security: Check API rate limits
check_rate_limit() {
  local remaining
  remaining=$(gh api rate_limit -q '.rate.remaining' 2>/dev/null || echo "0")
  if [[ "$remaining" -lt 50 ]]; then
    echo "⚠️  Low API rate limit: $remaining requests remaining" >&2
    echo "   Consider waiting before continuing." >&2
    return 1
  fi
  echo "✅ API rate limit OK: $remaining requests remaining"
  return 0
}

echo "🧹 Starting PR cleanup (SECURE MODE)..."
echo ""

# Check prerequisites
if ! command -v gh &> /dev/null; then
  echo "❌ Error: GitHub CLI (gh) not found" >&2
  exit 1
fi

if ! gh auth status &> /dev/null; then
  echo "❌ Error: Not authenticated with GitHub CLI" >&2
  exit 1
fi

# Check rate limits
if ! check_rate_limit; then
  echo ""
  read -p "Continue anyway? (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

echo ""

# Configuration (can be overridden via environment variables)
EXCLUDED_PR="${EXCLUDED_PR:-83}"
OBSOLETE_PRS="${OBSOLETE_PRS:-70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96}"

# Dry-run mode (set DRY_RUN=true to preview actions)
DRY_RUN="${DRY_RUN:-false}"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "🔍 DRY-RUN MODE: No actual changes will be made"
  echo ""
fi

# Track closed PRs for audit
CLOSED_PRS=()
FAILED_PRS=()

# Close draft PRs (except excluded)
echo "Closing draft PRs (excluding #${EXCLUDED_PR})..."
draft_prs=$(gh pr list --state open --draft --json number,title 2>/dev/null || echo "[]")

if [[ "$draft_prs" == "[]" || -z "$draft_prs" ]]; then
  echo "  No draft PRs found"
else
  echo "$draft_prs" | jq -r '.[] | select(.number != '"$EXCLUDED_PR"') | .number' | \
    while IFS= read -r pr_number; do
      # Security: Validate PR number is numeric
      if ! validate_number "$pr_number"; then
        echo "  ⚠️  Invalid PR number from API: '$pr_number' (skipped)" >&2
        continue
      fi
      
      if [[ "$DRY_RUN" == "true" ]]; then
        echo "  [DRY-RUN] Would close PR #$pr_number"
      else
        echo "  Closing PR #$pr_number..."
        if gh pr close "$pr_number" --comment "🤖 **Automated Cleanup**: Closing draft PR as part of repository consolidation. Functionality has been merged into main via PR #97 or is no longer needed." 2>&1; then
          CLOSED_PRS+=("$pr_number")
          echo "    ✅ Closed successfully"
        else
          FAILED_PRS+=("$pr_number")
          echo "    ⚠️  Failed to close (may already be closed or insufficient permissions)" >&2
        fi
      fi
    done
fi

echo ""

# Close specific obsolete PRs
echo "Closing obsolete PRs (duplicates and superseded)..."
for pr in $OBSOLETE_PRS; do
  # Security: Validate PR number is numeric
  if ! validate_number "$pr"; then
    echo "  ⚠️  Invalid PR number in hardcoded list: '$pr' (skipped)" >&2
    continue
  fi
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [DRY-RUN] Would close PR #$pr"
  else
    echo "  Closing PR #$pr..."
    # Security: Properly quoted variable
    if gh pr close "$pr" --comment "🤖 **Automated Cleanup**: Consolidated into PR #97 or functionality no longer required." 2>&1; then
      CLOSED_PRS+=("$pr")
      echo "    ✅ Closed successfully"
    else
      FAILED_PRS+=("$pr")
      echo "    ⚠️  Failed to close (may already be closed or insufficient permissions)" >&2
    fi
  fi
done

echo ""
echo "✅ PR cleanup completed"
echo ""
echo "📊 Summary:"
echo "  - PRs closed: ${#CLOSED_PRS[@]}"
echo "  - PRs failed: ${#FAILED_PRS[@]}"

if [[ ${#FAILED_PRS[@]} -gt 0 ]]; then
  echo "  - Failed PRs: ${FAILED_PRS[*]}"
fi

if [[ "$DRY_RUN" == "true" ]]; then
  echo ""
  echo "🔍 This was a DRY-RUN. No actual changes were made."
  echo "   To execute for real, run: DRY_RUN=false bash $0"
fi
