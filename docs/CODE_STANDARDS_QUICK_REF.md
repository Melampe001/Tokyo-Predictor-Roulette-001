# Code Standards Quick Reference

Quick reference guide for Tokyo Roulette Predictor code standards and quality tools.

## 🚀 Quick Start

```bash
# First time setup
bash scripts/dev-setup.sh

# Before committing
make check

# Fix formatting
make format

# Run tests
make test
```

---

## 📋 Available Commands

```bash
make help              # Show all commands
make setup             # Setup development environment
make format            # Format code
make lint              # Run static analysis
make test              # Run tests with coverage
make check             # Run all quality checks
make check-security    # Security scan
make build-debug       # Build debug APK
make build-release     # Build release APK/AAB
make clean             # Clean build artifacts
```

---

## ✅ Pre-commit Checklist

Before committing, ensure:

- [ ] Code is formatted: `make format`
- [ ] No analyzer warnings: `make lint`
- [ ] Tests pass: `make test`
- [ ] No secrets in code: `make check-security`
- [ ] Commit message follows convention

Or simply run:
```bash
make check
```

---

## 📝 Commit Message Format

```
<type>[(scope)]: <description>

[optional body]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`

**Examples:**
- `feat: add Martingale calculator`
- `fix: correct balance calculation`
- `docs: update README`
- `test: add tests for predictNext`

---

## 🔍 Quality Checks

### Format Check
```bash
make format-check     # Check only (CI)
make format           # Fix formatting
```

### Static Analysis
```bash
make lint             # Run analyzer
flutter analyze       # Direct command
```

### Tests
```bash
make test             # All tests + coverage
make test-unit        # Unit tests only
make test-widget      # Widget tests only
flutter test          # Direct command
```

### Security
```bash
make check-security   # Security scan
bash scripts/security-scan.sh
```

---

## 📊 Coverage Requirements

- **Overall:** ≥ 80%
- **Core logic:** ≥ 90%

```bash
flutter test --coverage
bash scripts/check-coverage.sh
```

---

## 🔒 Security Guidelines

### Never commit:
- ❌ API keys (`sk_live_`, `pk_live_`)
- ❌ Passwords or secrets
- ❌ `*.keystore`, `key.properties`
- ❌ `.env` files with secrets
- ❌ Firebase config with real keys

### Always use:
- ✅ Environment variables
- ✅ Firebase Remote Config
- ✅ `Random.secure()` for gambling
- ✅ `.gitignore` for sensitive files

---

## 🎯 Code Style

### Naming Conventions
```dart
// Classes: PascalCase
class RouletteLogic {}

// Methods/Variables: camelCase
int generateSpin() {}
double currentBet = 10.0;

// Constants: camelCase
const double minBet = 1.0;

// Private: _prefix
void _updateBalance() {}

// Files: snake_case
// roulette_logic.dart
```

### Documentation
```dart
/// Brief description.
///
/// Detailed explanation if needed.
///
/// Example:
/// ```dart
/// final logic = RouletteLogic();
/// final spin = logic.generateSpin();
/// ```
int generateSpin() {
  // Implementation
}
```

---

## 🔧 Troubleshooting

### Format errors
```bash
make format
```

### Analyzer warnings
```bash
flutter analyze
# Fix reported issues
```

### Tests failing
```bash
flutter test
# Fix failing tests
```

### Secrets detected
```bash
# Remove secrets from code
# Use environment variables
git rm --cached sensitive-file
```

### Coverage too low
```bash
# Add more tests
flutter test --coverage
```

---

## 🚫 Bypass Hooks (Emergencies Only)

```bash
git commit --no-verify -m "message"
```

⚠️ **Warning:** CI will still check your code.

---

## 📚 Resources

- **Makefile:** `make help`
- **Scripts:** `scripts/README.md`
- **Contributing:** `CONTRIBUTING.md`
- **Hooks:** `.githooks/README.md`
- **CI/CD:** `.github/workflows/quality-checks.yml`

---

## 🆘 Getting Help

1. Check this guide
2. Run `make help`
3. Read `CONTRIBUTING.md`
4. Check script documentation in `scripts/README.md`
5. Review `.githooks/README.md` for hook issues

---

## ⚡ Pro Tips

1. **Run `make check` before pushing** - Catch issues early
2. **Use pre-commit hooks** - Installed via `make setup`
3. **Write tests first** - TDD approach
4. **Keep commits atomic** - One logical change per commit
5. **Use conventional commits** - Better changelog generation
6. **Check coverage regularly** - Aim for > 80%
7. **Scan for secrets** - Before committing sensitive code
8. **Update dependencies** - Run `flutter pub outdated`

---

**Quick Start:**
```bash
# Clone repo
git clone <repo-url>
cd Tokyo-Predictor-Roulette-001

# Setup environment
bash scripts/dev-setup.sh

# Make changes
# ... edit files ...

# Check quality
make check

# Commit (hooks will run automatically)
git commit -m "feat: add new feature"

# Push
git push
```

---

**Last updated:** 2024  
**For detailed information, see:** `CONTRIBUTING.md`
