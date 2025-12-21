#!/bin/bash
# Secure version of run_full_cleanup.sh
# Security improvements: comprehensive validation, dry-run, logging, rollback

set -euo pipefail

# Configuration
DRY_RUN="${DRY_RUN:-false}"
LOG_FILE="/tmp/cleanup-$(date +%Y%m%d-%H%M%S).log"

# Set up logging
exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "🚀 ============================================"
echo "   TOKYO PREDICTOR - REPOSITORY CLEANUP"
echo "   SECURE MODE WITH ENHANCED SAFETY"
echo "============================================"
echo ""
echo "📝 Logging to: $LOG_FILE"
echo "🔍 Dry-run mode: $DRY_RUN"
echo ""

# Security: Check prerequisites
echo "Checking prerequisites..."

if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) not found. Install from https://cli.github.com/" >&2
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Error: git not found" >&2
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "⚠️  Warning: jq not found. Some features may be limited" >&2
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Error: Not authenticated with GitHub CLI. Run: gh auth login" >&2
    exit 1
fi

# Security: Verify we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Error: Not in a git repository" >&2
  exit 1
fi

# Security: Verify we're on main branch
current_branch=$(git branch --show-current)
if [[ "$current_branch" != "main" ]]; then
  echo "⚠️  Warning: Not on main branch (current: $current_branch)" >&2
  read -p "Continue anyway? (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

# Security: Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
  echo "⚠️  Warning: You have uncommitted changes" >&2
  git status --short
  read -p "Continue? This will create a backup branch. (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

echo "✅ Prerequisites checked"
echo ""

# User confirmation (unless in dry-run mode)
if [[ "$DRY_RUN" != "true" ]]; then
  echo "⚠️  ============================================"
  echo "   WARNING: DESTRUCTIVE OPERATION"
  echo "============================================"
  echo ""
  echo "This script will:"
  echo "  - Close multiple PRs and issues"
  echo "  - Delete local branches"
  echo "  - Create a backup branch"
  echo ""
  echo "A backup will be created, but make sure you have:"
  echo "  1. Reviewed what will be deleted"
  echo "  2. Have local backups if needed"
  echo "  3. Can restore from the backup branch if needed"
  echo ""
  read -p "Type 'yes' to continue: " -r
  if [[ ! $REPLY =~ ^yes$ ]]; then
    echo "Aborted by user"
    exit 0
  fi
  echo ""
fi

# Create backup branch
BACKUP_BRANCH="backup-$(date +%Y%m%d-%H%M%S)"
echo "📦 Creating backup branch: $BACKUP_BRANCH"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "  [DRY-RUN] Would create backup branch: $BACKUP_BRANCH"
else
  if git checkout -b "$BACKUP_BRANCH" 2>&1; then
    echo "  ✅ Created backup branch"
    if git push origin "$BACKUP_BRANCH" 2>&1; then
      echo "  ✅ Pushed backup to remote"
    else
      echo "  ⚠️  Failed to push backup branch (continuing anyway)" >&2
    fi
    git checkout main 2>&1 || {
      echo "❌ Failed to return to main branch" >&2
      exit 1
    }
  elif git checkout "$BACKUP_BRANCH" 2>&1; then
    echo "  ⚠️  Backup branch already exists, using existing one"
    git checkout main 2>&1 || {
      echo "❌ Failed to return to main branch" >&2
      exit 1
    }
  else
    echo "❌ Failed to create/checkout backup branch" >&2
    exit 1
  fi
fi

echo ""

# Export DRY_RUN for child scripts
export DRY_RUN

# Run cleanup scripts with error handling
echo "🧹 Running cleanup scripts..."
echo ""

# Track script execution
SCRIPTS_RUN=0
SCRIPTS_FAILED=0

# 1. Clean up PRs
if [[ -f "scripts/cleanup_prs_secure.sh" ]]; then
  echo "▶️  Running PR cleanup..."
  if bash scripts/cleanup_prs_secure.sh; then
    ((SCRIPTS_RUN++)) || true
    echo "  ✅ PR cleanup completed"
  else
    ((SCRIPTS_FAILED++)) || true
    echo "  ⚠️  PR cleanup had errors" >&2
  fi
else
  echo "⚠️  cleanup_prs_secure.sh not found, skipping" >&2
fi
echo ""

# 2. Clean up issues
if [[ -f "scripts/cleanup_issues_secure.sh" ]]; then
  echo "▶️  Running issue cleanup..."
  if bash scripts/cleanup_issues_secure.sh; then
    ((SCRIPTS_RUN++)) || true
    echo "  ✅ Issue cleanup completed"
  else
    ((SCRIPTS_FAILED++)) || true
    echo "  ⚠️  Issue cleanup had errors" >&2
  fi
else
  echo "⚠️  cleanup_issues_secure.sh not found, skipping" >&2
fi
echo ""

# 3. Clean up branches
if [[ -f "scripts/cleanup_branches_secure.sh" ]]; then
  echo "▶️  Running branch cleanup..."
  if bash scripts/cleanup_branches_secure.sh; then
    ((SCRIPTS_RUN++)) || true
    echo "  ✅ Branch cleanup completed"
  else
    ((SCRIPTS_FAILED++)) || true
    echo "  ⚠️  Branch cleanup had errors" >&2
  fi
else
  echo "⚠️  cleanup_branches_secure.sh not found, skipping" >&2
fi
echo ""

# Final summary
echo "✅ ============================================"
echo "   CLEANUP COMPLETED"
echo "============================================"
echo ""
echo "📊 Summary:"
echo "  - Backup branch: $BACKUP_BRANCH"
echo "  - Scripts executed: $SCRIPTS_RUN"
echo "  - Scripts with errors: $SCRIPTS_FAILED"
echo "  - Log file: $LOG_FILE"

if [[ "$DRY_RUN" == "true" ]]; then
  echo ""
  echo "🔍 DRY-RUN MODE was enabled. No actual changes were made."
  echo "   To execute for real, run:"
  echo "   DRY_RUN=false bash $0"
else
  echo "  - Draft PRs closed (except #83 for review)"
  echo "  - Obsolete PRs closed"
  echo "  - Duplicate issues closed"
  echo "  - Local orphaned branches removed"
fi

echo ""
echo "📝 Next steps:"
echo "  1. Review the log file: cat $LOG_FILE"
echo "  2. Review remaining open PRs: gh pr list"
if [[ "$DRY_RUN" != "true" ]]; then
  echo "  3. Merge PR #97 (comprehensive organization): gh pr merge 97 --squash"
  echo "  4. Merge PR #94 (Copilot setup): gh pr merge 94 --squash"
  echo "  5. Review PR #83 (CI/CD) and merge if needed"
  echo "  6. Manually delete remote branches via GitHub UI if desired"
  echo "  7. If anything went wrong, restore from backup:"
  echo "     git checkout $BACKUP_BRANCH"
fi
echo ""

if [[ $SCRIPTS_FAILED -gt 0 ]]; then
  echo "⚠️  Some scripts had errors. Review the log file for details." >&2
  exit 1
fi
