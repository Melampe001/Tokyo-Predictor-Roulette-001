# 🔒 Security Review: Cleanup Scripts
**Date**: 2025-12-21  
**Reviewer**: Security Agent  
**Scope**: Bash scripts for GitHub repository cleanup

---

## 📋 Executive Summary

**Overall Security Rating**: ⚠️ **MEDIUM RISK**

The cleanup scripts contain **6 security vulnerabilities** ranging from HIGH to LOW severity. While the scripts have basic protections (`set -e`, quoted variables in some places), they have significant security gaps that could lead to command injection, unintended data loss, and information disclosure.

### Critical Findings
- ❌ **HIGH**: Command injection vulnerability in `cleanup_prs.sh` (line 12)
- ❌ **HIGH**: Command injection vulnerability in `cleanup_issues.sh` (line 10)
- ⚠️ **MEDIUM**: Unquoted variable in `cleanup_branches.sh` (line 13)
- ⚠️ **MEDIUM**: Missing input validation for PR/issue numbers
- ⚠️ **MEDIUM**: Potential information disclosure through error messages
- ℹ️ **LOW**: Race condition in backup branch creation

---

## 🔍 Detailed Vulnerability Analysis

### 1. ❌ HIGH SEVERITY: Command Injection in cleanup_prs.sh

**Location**: `scripts/cleanup_prs.sh:12`

```bash
gh pr close "$pr_number" --comment "🤖 **Automated Cleanup**: ..."
```

**Issue**: While `$pr_number` is quoted, the `--comment` parameter contains user-controlled data that could be manipulated if the JSON response from `gh pr list` is compromised or if GitHub returns malicious titles.

**Attack Vector**:
```bash
# If a PR title contains: "; rm -rf / #"
# And the script processes it unsafely elsewhere, it could be exploited
```

**Impact**: 
- Potential command execution
- Repository manipulation
- Data loss

**Recommendation**:
```bash
# Validate PR number is numeric
if [[ "$pr_number" =~ ^[0-9]+$ ]]; then
  gh pr close "$pr_number" --comment "🤖 **Automated Cleanup**: Closing draft PR as part of repository consolidation."
else
  echo "⚠️  Invalid PR number: $pr_number (skipped)" >&2
fi
```

---

### 2. ❌ HIGH SEVERITY: Command Injection in cleanup_prs.sh (Loop)

**Location**: `scripts/cleanup_prs.sh:19`

```bash
gh pr close $pr --comment "..." 2>/dev/null || true
```

**Issue**: 
- Variable `$pr` is **NOT quoted** - shell word splitting vulnerability
- No validation that `$pr` is a valid number
- Hardcoded list could be modified maliciously

**Attack Vector**:
```bash
# If someone modifies the script to add:
for pr in 70 71 "72; malicious_command #" 73; do
  gh pr close $pr --comment "..."  # VULNERABLE
done
```

**Impact**: Command injection, arbitrary code execution

**Recommendation**:
```bash
# Validate and quote
for pr in 70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96; do
  if [[ "$pr" =~ ^[0-9]+$ ]]; then
    echo "  Closing PR #$pr"
    gh pr close "$pr" --comment "🤖 **Automated Cleanup**: Consolidated into PR #97." 2>/dev/null || true
  else
    echo "⚠️  Invalid PR number in hardcoded list: $pr" >&2
  fi
done
```

---

### 3. ❌ HIGH SEVERITY: Command Injection in cleanup_issues.sh

**Location**: `scripts/cleanup_issues.sh:10`

```bash
gh issue close $issue --comment "..." 2>/dev/null || true
```

**Issue**: Same as #2 - unquoted variable `$issue`

**Recommendation**: Same validation and quoting as PR script

---

### 4. ⚠️ MEDIUM SEVERITY: Unquoted Variable in cleanup_branches.sh

**Location**: `scripts/cleanup_branches.sh:13`

```bash
git branch -D "$branch" 2>/dev/null || true
```

**Issue**: While `$branch` is quoted here, the variable comes from:
```bash
git branch -vv | grep ': gone]' | awk '{print $1}' | while read -r branch; do
```

**Risk**: If a branch name contains special characters (though Git usually prevents this), it could cause issues. The `read -r` is good, but branch names should be validated.

**Recommendation**:
```bash
git branch -vv | grep ': gone]' | awk '{print $1}' | while read -r branch; do
  # Validate branch name format
  if [[ "$branch" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
    echo "  Deleting local branch: $branch"
    git branch -D "$branch" 2>/dev/null || true
  else
    echo "⚠️  Skipping branch with suspicious name: $branch" >&2
  fi
done
```

---

### 5. ⚠️ MEDIUM SEVERITY: No Input Validation for PR/Issue Numbers

**Location**: All cleanup scripts

**Issue**: The scripts trust that:
- `jq` output is always numeric
- Hardcoded lists are safe
- GitHub API returns expected data

**Attack Vector**: 
- Compromised GitHub API responses
- Modified script files
- Supply chain attacks on `gh` CLI

**Recommendation**: Add strict input validation with regex `^[0-9]+$` before every use of PR/issue numbers.

---

### 6. ⚠️ MEDIUM SEVERITY: Information Disclosure via Error Messages

**Location**: Multiple locations using `2>/dev/null || true`

**Issue**: Errors are silently suppressed, which:
- Hides legitimate failures
- Could mask security issues
- Makes debugging difficult

**Example**:
```bash
gh pr close $pr --comment "..." 2>/dev/null || true
```

If `gh` fails due to authentication issues, API errors, or other problems, the script continues silently.

**Recommendation**:
```bash
# Log errors to stderr but continue
if ! gh pr close "$pr" --comment "..." 2>&1; then
  echo "⚠️  Failed to close PR #$pr (skipped)" >&2
fi
```

---

### 7. ℹ️ LOW SEVERITY: Race Condition in Backup Creation

**Location**: `scripts/run_full_cleanup.sh:27`

```bash
git checkout -b "$BACKUP_BRANCH" 2>/dev/null || git checkout "$BACKUP_BRANCH"
```

**Issue**: If two processes run simultaneously, they might:
- Create conflicting backup branches
- Corrupt the git state
- Leave the repository in an inconsistent state

**Impact**: Low (unlikely in CI/CD, but possible in concurrent runs)

**Recommendation**:
```bash
# Add a lock file mechanism or use git's atomic operations
if git checkout -b "$BACKUP_BRANCH" 2>/dev/null; then
  echo "✅ Created backup branch: $BACKUP_BRANCH"
elif git checkout "$BACKUP_BRANCH" 2>/dev/null; then
  echo "✅ Using existing backup branch: $BACKUP_BRANCH"
else
  echo "❌ Failed to create/checkout backup branch" >&2
  exit 1
fi
```

---

## 🛡️ Additional Security Concerns

### 8. Missing Authentication Validation

**Location**: `run_full_cleanup.sh:16`

```bash
if ! gh auth status &> /dev/null; then
```

**Issue**: While authentication is checked, there's no verification that the authenticated user has **write permissions** to the repository.

**Recommendation**:
```bash
# Check repository access level
if ! gh api user -q '.login' &> /dev/null; then
  echo "❌ Failed to verify GitHub authentication"
  exit 1
fi

# Verify repo write access (optional but recommended)
if ! gh api "repos/{owner}/{repo}" -q '.permissions.push' 2>/dev/null | grep -q "true"; then
  echo "⚠️  Warning: User may not have push access to repository"
fi
```

---

### 9. No Rate Limiting Protection

**Issue**: Scripts make multiple sequential `gh` API calls without rate limit checks.

**Impact**: Could hit GitHub API rate limits (5000/hour for authenticated users), causing failures.

**Recommendation**:
```bash
# Add rate limit check before batch operations
check_rate_limit() {
  local remaining=$(gh api rate_limit -q '.rate.remaining')
  if [[ "$remaining" -lt 100 ]]; then
    echo "⚠️  Warning: Only $remaining API calls remaining. Consider waiting." >&2
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1
  fi
}

check_rate_limit
```

---

### 10. Hardcoded PR/Issue Numbers

**Location**: `cleanup_prs.sh:17`, `cleanup_issues.sh:8`

**Issue**: 
- Hardcoded values are difficult to maintain
- Could become outdated
- No way to override without editing the script

**Recommendation**:
```bash
# Use environment variables or config file
OBSOLETE_PRS="${OBSOLETE_PRS:-70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96}"
EXCLUDED_PRS="${EXCLUDED_PRS:-83}"

for pr in $OBSOLETE_PRS; do
  if [[ "$pr" == "$EXCLUDED_PRS" ]]; then
    echo "  Skipping excluded PR #$pr"
    continue
  fi
  # ... close PR
done
```

---

## 🔧 Secure Script Templates

### Recommended: cleanup_prs_secure.sh

```bash
#!/bin/bash
set -euo pipefail

# Security: Validate inputs
validate_number() {
  [[ "$1" =~ ^[0-9]+$ ]] || return 1
}

# Security: Check rate limits
check_rate_limit() {
  local remaining
  remaining=$(gh api rate_limit -q '.rate.remaining' 2>/dev/null || echo "0")
  if [[ "$remaining" -lt 50 ]]; then
    echo "⚠️  Low API rate limit: $remaining remaining" >&2
    return 1
  fi
  return 0
}

echo "🧹 Starting PR cleanup..."

# Check prerequisites
check_rate_limit || exit 1

# Configuration (can be overridden via env vars)
EXCLUDED_PR="${EXCLUDED_PR:-83}"
OBSOLETE_PRS="${OBSOLETE_PRS:-70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96}"

# Close draft PRs (except excluded)
echo "Closing draft PRs..."
gh pr list --state open --draft --json number,title | \
  jq -r '.[] | select(.number != '"$EXCLUDED_PR"') | .number' | \
  while IFS= read -r pr_number; do
    # Security: Validate PR number
    if ! validate_number "$pr_number"; then
      echo "⚠️  Invalid PR number from API: $pr_number (skipped)" >&2
      continue
    fi
    
    echo "  Closing PR #$pr_number"
    if ! gh pr close "$pr_number" --comment "🤖 Automated Cleanup: Closing draft PR." 2>&1; then
      echo "⚠️  Failed to close PR #$pr_number" >&2
    fi
  done

# Close obsolete PRs
echo "Closing obsolete PRs..."
for pr in $OBSOLETE_PRS; do
  # Security: Validate PR number
  if ! validate_number "$pr"; then
    echo "⚠️  Invalid PR number in list: $pr (skipped)" >&2
    continue
  fi
  
  echo "  Closing PR #$pr"
  if ! gh pr close "$pr" --comment "🤖 Automated Cleanup: Consolidated functionality." 2>&1; then
    echo "⚠️  Failed to close PR #$pr (may already be closed)" >&2
  fi
done

echo "✅ PR cleanup completed"
```

---

## 📊 Security Checklist

### Before Running Scripts
- [x] ✅ Authentication validated
- [ ] ⚠️ Write permissions verified
- [ ] ⚠️ API rate limits checked
- [ ] ❌ Input validation implemented
- [ ] ❌ Dry-run mode available
- [ ] ⚠️ Backup mechanism tested

### Script Hardening
- [x] ✅ `set -e` enabled (fail on error)
- [ ] ❌ `set -u` enabled (fail on undefined variables)
- [ ] ❌ `set -o pipefail` enabled (fail on pipe errors)
- [ ] ⚠️ Variables properly quoted
- [ ] ❌ Input validation implemented
- [ ] ⚠️ Error handling comprehensive
- [ ] ❌ Logging to separate log file

### Audit Trail
- [ ] ❌ Actions logged with timestamps
- [ ] ❌ Affected PRs/issues recorded
- [ ] ❌ User confirmation before destructive operations
- [ ] ❌ Dry-run mode to preview actions

---

## 🎯 Priority Fixes

### Immediate (HIGH Priority)
1. **Add input validation** for all PR/issue numbers
2. **Quote all variables** consistently
3. **Implement proper error handling** (don't silence all errors)

### Short-term (MEDIUM Priority)
4. Add rate limit checking
5. Add user confirmation before batch deletions
6. Implement dry-run mode
7. Add comprehensive logging

### Long-term (LOW Priority)
8. Move hardcoded values to config file
9. Add unit tests for validation functions
10. Implement atomic operations with rollback

---

## 🚨 Recommendations

### 1. Add Dry-Run Mode
```bash
DRY_RUN="${DRY_RUN:-false}"

close_pr() {
  local pr="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  [DRY-RUN] Would close PR #$pr"
  else
    gh pr close "$pr" --comment "..."
  fi
}
```

### 2. Add User Confirmation
```bash
echo "⚠️  This will close ${#OBSOLETE_PRS[@]} PRs and ${#OBSOLETE_ISSUES[@]} issues"
read -p "Continue? (yes/no): " -r
if [[ ! $REPLY =~ ^yes$ ]]; then
  echo "Aborted by user"
  exit 0
fi
```

### 3. Comprehensive Logging
```bash
LOG_FILE="/tmp/cleanup-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "📝 Logging to: $LOG_FILE"
```

### 4. Rollback Mechanism
```bash
# Store closed PRs for potential reopening
CLOSED_PRS=()
close_pr() {
  local pr="$1"
  if gh pr close "$pr" --comment "..."; then
    CLOSED_PRS+=("$pr")
  fi
}

# On error, offer to rollback
trap 'rollback' ERR
rollback() {
  echo "❌ Error occurred. Rollback closed PRs?"
  read -p "Reopen ${#CLOSED_PRS[@]} closed PRs? (y/N): " -r
  [[ $REPLY =~ ^[Yy]$ ]] && reopen_prs
}
```

---

## 📝 Summary of Findings

| Severity | Count | Fixed | Remaining |
|----------|-------|-------|-----------|
| 🔴 HIGH | 3 | 0 | 3 |
| 🟡 MEDIUM | 3 | 0 | 3 |
| 🔵 LOW | 1 | 0 | 1 |
| **TOTAL** | **7** | **0** | **7** |

### Risk Assessment
- **Exploitation Likelihood**: MEDIUM (requires repository access or script modification)
- **Impact**: HIGH (could cause data loss, unintended deletions)
- **Overall Risk**: **MEDIUM-HIGH**

---

## ✅ Secure Usage Guidelines

### For Repository Maintainers

1. **Always review the script before running**:
   ```bash
   cat scripts/run_full_cleanup.sh
   ```

2. **Use dry-run mode first** (after implementing it):
   ```bash
   DRY_RUN=true bash scripts/run_full_cleanup.sh
   ```

3. **Verify backup was created**:
   ```bash
   git branch -a | grep backup
   ```

4. **Review changes before pushing**:
   ```bash
   gh pr list --state closed --limit 20
   gh issue list --state closed --limit 20
   ```

5. **Keep audit logs**:
   ```bash
   bash scripts/run_full_cleanup.sh 2>&1 | tee cleanup-$(date +%Y%m%d).log
   ```

---

## 🔄 Next Steps

1. **Implement fixes** for HIGH severity issues immediately
2. **Test scripts** in a fork/test repository first
3. **Add CI/CD checks** to validate scripts before merging
4. **Document** the cleanup process in repository docs
5. **Schedule periodic security reviews** of automation scripts

---

**Security Agent Signature**  
Tokyo Roulette Project Security Team  
*Review Date: 2025-12-21*
