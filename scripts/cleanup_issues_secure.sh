#!/bin/bash
# Secure version of cleanup_issues.sh
# Security improvements: input validation, proper quoting, error handling

set -euo pipefail

# Security: Validate numeric inputs
validate_number() {
  [[ "$1" =~ ^[0-9]+$ ]] || return 1
}

echo "📝 Starting issue cleanup (SECURE MODE)..."
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

# Configuration (can be overridden via environment variables)
DUPLICATE_ISSUES="${DUPLICATE_ISSUES:-85 93}"

# Dry-run mode
DRY_RUN="${DRY_RUN:-false}"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "🔍 DRY-RUN MODE: No actual changes will be made"
  echo ""
fi

# Track closed issues for audit
CLOSED_ISSUES=()
FAILED_ISSUES=()

# Close duplicate Copilot setup issues (keep #94 which has the PR)
echo "Closing duplicate issues..."
for issue in $DUPLICATE_ISSUES; do
  # Security: Validate issue number is numeric
  if ! validate_number "$issue"; then
    echo "  ⚠️  Invalid issue number: '$issue' (skipped)" >&2
    continue
  fi
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [DRY-RUN] Would close issue #$issue"
  else
    echo "  Closing issue #$issue..."
    # Security: Properly quoted variable
    if gh issue close "$issue" --comment "🤖 **Automated Cleanup**: Duplicate issue. Copilot setup completed via PR #94." 2>&1; then
      CLOSED_ISSUES+=("$issue")
      echo "    ✅ Closed successfully"
    else
      FAILED_ISSUES+=("$issue")
      echo "    ⚠️  Failed to close (may already be closed or insufficient permissions)" >&2
    fi
  fi
done

echo ""
echo "✅ Issue cleanup completed"
echo ""
echo "📊 Summary:"
echo "  - Issues closed: ${#CLOSED_ISSUES[@]}"
echo "  - Issues failed: ${#FAILED_ISSUES[@]}"

if [[ ${#FAILED_ISSUES[@]} -gt 0 ]]; then
  echo "  - Failed issues: ${FAILED_ISSUES[*]}"
fi

if [[ "$DRY_RUN" == "true" ]]; then
  echo ""
  echo "🔍 This was a DRY-RUN. No actual changes were made."
  echo "   To execute for real, run: DRY_RUN=false bash $0"
fi
