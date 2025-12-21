# Repository Cleanup Guide

## 🎯 Purpose
This guide documents the automated cleanup process for consolidating PRs, branches, and issues.

## 🚀 Quick Start

### Prerequisites
- [GitHub CLI](https://cli.github.com/) installed
- Authenticated with GitHub: `gh auth login`
- On `main` branch with latest changes

### Run Full Cleanup
```bash
bash scripts/run_full_cleanup.sh
```

## 📋 What Gets Cleaned

### Pull Requests
- ❌ **Closed**: All draft PRs except #83 (CI/CD kept for review)
- ❌ **Closed**: PRs #70-82, #88-90, #92, #95-96 (duplicates/obsolete)
- ✅ **Kept**: #83 (Release automation), #97 (if not merged), #94 (if not merged)

### Issues
- ❌ **Closed**: #85, #93 (duplicate Copilot setup issues)
- ✅ **Kept**: #98 (cleanup tracking), active issues

### Branches
- ❌ **Deleted**: Local branches tracking deleted remotes
- ✅ **Preserved**: Remote branches (manual deletion recommended via GitHub UI)
- ✅ **Backup**: Created automatically before cleanup

## 🔧 Individual Scripts

### Cleanup PRs Only
```bash
bash scripts/cleanup_prs.sh
```

### Cleanup Branches Only
```bash
bash scripts/cleanup_branches.sh
```

### Cleanup Issues Only
```bash
bash scripts/cleanup_issues.sh
```

## 📊 Post-Cleanup Actions

### 1. Merge Critical PRs
```bash
# Merge comprehensive organization
gh pr merge 97 --squash --delete-branch

# Merge Copilot setup
gh pr merge 94 --squash --delete-branch

# Review and merge CI/CD if needed
gh pr view 83
gh pr merge 83 --squash --delete-branch
```

### 2. Verify Repository State
```bash
# Check remaining PRs
gh pr list

# Check remaining branches
git branch -a

# Check open issues
gh issue list
```

### 3. Delete Remote Branches (Optional)
Go to GitHub UI → Branches → Delete unused branches manually

## 🔄 Rollback

If something goes wrong, restore from backup:
```bash
# Find backup branch
git branch -a | grep backup

# Restore (example)
git checkout backup-20251221-123456
git checkout -b main-restored
git push origin main-restored --force
```

## 📝 Maintenance

Run cleanup periodically:
- After major feature merges
- Monthly maintenance
- Before releases

## ⚠️ Safety Features

- ✅ Backup branch created automatically
- ✅ Non-destructive remote branch handling
- ✅ Error handling with `|| true` fallbacks
- ✅ Manual confirmation points for critical actions
