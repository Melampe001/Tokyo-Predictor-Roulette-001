#!/bin/bash
set -e

echo "🚀 ============================================"
echo "   TOKYO PREDICTOR - REPOSITORY CLEANUP"
echo "============================================"
echo ""

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) not found. Install from https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Error: Not authenticated with GitHub CLI. Run: gh auth login"
    exit 1
fi

echo "✅ Prerequisites checked"
echo ""

# Create backup branch
BACKUP_BRANCH="backup-$(date +%Y%m%d-%H%M%S)"
echo "📦 Creating backup branch: $BACKUP_BRANCH"
git checkout -b "$BACKUP_BRANCH" 2>/dev/null || git checkout "$BACKUP_BRANCH"
git push origin "$BACKUP_BRANCH" || echo "⚠️  Backup branch already exists"
git checkout main

echo ""

# Run cleanup scripts
bash scripts/cleanup_prs.sh
echo ""
bash scripts/cleanup_issues.sh
echo ""
bash scripts/cleanup_branches.sh

echo ""
echo "✅ ============================================"
echo "   CLEANUP COMPLETED SUCCESSFULLY"
echo "============================================"
echo ""
echo "📊 Summary:"
echo "  - Backup created: $BACKUP_BRANCH"
echo "  - Draft PRs closed (except #83 for review)"
echo "  - Obsolete PRs closed"
echo "  - Duplicate issues closed"
echo "  - Local orphaned branches removed"
echo ""
echo "📝 Next steps:"
echo "  1. Review remaining open PRs: gh pr list"
echo "  2. Merge PR #97 (comprehensive organization): gh pr merge 97 --squash"
echo "  3. Merge PR #94 (Copilot setup): gh pr merge 94 --squash"
echo "  4. Review PR #83 (CI/CD) and merge if needed"
echo "  5. Manually delete remote branches via GitHub UI if desired"
echo ""
