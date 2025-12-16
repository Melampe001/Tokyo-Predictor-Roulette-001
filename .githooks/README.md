# Git Hooks

This directory contains Git hooks for Tokyo Roulette Predictor that enforce code quality standards automatically.

## Available Hooks

### `pre-commit`
Runs before each commit to ensure code quality.

**What it checks:**
- ✅ Code formatting (dart format)
- ✅ Static analysis (flutter analyze)
- ✅ Secret detection (API keys, passwords)
- ✅ Secure RNG usage (Random.secure())

**When it runs:** Before `git commit`

**How to bypass (emergencies only):**
```bash
git commit --no-verify -m "your message"
```

---

### `commit-msg`
Validates commit messages follow Conventional Commits format.

**Required format:**
```
<type>[(scope)]: <description>

[optional body]

[optional footer]
```

**Valid types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting)
- `refactor:` - Code refactoring
- `test:` - Adding/updating tests
- `chore:` - Maintenance tasks
- `perf:` - Performance improvements
- `ci:` - CI/CD changes
- `build:` - Build system changes

**Examples:**
```bash
✅ feat: add Martingale strategy calculator
✅ fix: correct balance calculation in RouletteLogic
✅ docs: update README with installation steps
✅ test(logic): add tests for predictNext function
✅ refactor(ui): extract wheel widget to separate file

❌ update code
❌ fix bug
❌ changes
```

**When it runs:** After writing commit message, before finalizing commit

---

## Installation

### Automatic (Recommended)
```bash
bash scripts/install-hooks.sh
# or
make setup
```

### Manual
```bash
cp .githooks/* .git/hooks/
chmod +x .git/hooks/*
```

---

## How Hooks Work

Git hooks are scripts that Git executes before or after events such as:
- `pre-commit` - Before a commit is created
- `commit-msg` - After commit message is written
- `post-merge` - After a successful merge
- etc.

Hooks in `.githooks/` are **templates**. They must be copied to `.git/hooks/` to be active.

---

## Customization

### Disabling Specific Checks

Edit the hook file (in `.git/hooks/`, not `.githooks/`) to comment out checks:

```bash
# In .git/hooks/pre-commit
# Comment out the security check:
# echo -e "${BLUE}🔒 Checking for secrets...${NC}"
# ... (rest of security check)
```

### Adding New Checks

1. Edit hook file in `.githooks/`
2. Add your check with clear output
3. Test thoroughly
4. Reinstall: `bash scripts/install-hooks.sh`

---

## Troubleshooting

### Hook not running
```bash
# Verify hooks are installed
ls -l .git/hooks/

# Reinstall hooks
bash scripts/install-hooks.sh

# Check if executable
chmod +x .git/hooks/pre-commit .git/hooks/commit-msg
```

### Hook failing unexpectedly
```bash
# Run hook manually to see detailed output
bash .git/hooks/pre-commit

# Check for syntax errors
bash -n .git/hooks/pre-commit
```

### "Dart not found" error
Hooks gracefully handle missing Flutter/Dart. If you have Flutter installed:
```bash
which flutter
which dart

# Add Flutter to PATH if needed
export PATH="$PATH:/path/to/flutter/bin"
```

### Bypassing hooks
Only use in emergencies:
```bash
git commit --no-verify -m "message"
```

⚠️ **Warning:** CI will still check your code even if you bypass hooks.

---

## Best Practices

1. **Keep hooks fast** - Hooks should complete in < 5 seconds
2. **Only check staged files** - Don't analyze entire codebase on every commit
3. **Provide clear error messages** - Tell developers exactly what's wrong
4. **Make hooks bypassable** - Use `--no-verify` for emergencies
5. **Test hooks regularly** - Ensure they work on different systems

---

## CI/CD Integration

These hooks enforce the same standards as the CI pipeline:
- `.github/workflows/quality-checks.yml` - Comprehensive quality checks
- Format, lint, test, security scans all run in CI
- Hooks catch issues early, before pushing to remote

---

## Resources

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Project CONTRIBUTING.md](../CONTRIBUTING.md)
- [Makefile](../Makefile)

---

**Last updated:** 2024  
**Maintainer:** Tokyo Roulette Predictor Team
