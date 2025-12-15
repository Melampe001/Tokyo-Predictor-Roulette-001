#!/bin/bash
# Security scanner for Tokyo Roulette Predictor
# Scans for hardcoded secrets, API keys, and security vulnerabilities

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔒 Running security scan...${NC}"
echo "======================================"

ISSUES_FOUND=0

# Function to report security issue
report_issue() {
    echo -e "${RED}✗ $1${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
}

report_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 1. Check for hardcoded API keys
echo -e "\n${BLUE}Checking for hardcoded API keys...${NC}"

# Stripe keys
if grep -r "sk_live_\|pk_live_\|sk_test_\|pk_test_" lib/ test/ 2>/dev/null | grep -v "example\|TODO\|test fixture" | grep -v ".git"; then
    report_issue "Stripe API keys found in code"
fi

# Generic API key patterns
if grep -rE "(api_key|apiKey|API_KEY)\s*=\s*['\"][a-zA-Z0-9]{20,}['\"]" lib/ 2>/dev/null | grep -v "example\|TODO\|test" | grep -v ".git"; then
    report_issue "Possible hardcoded API keys found"
fi

# Firebase keys in code (should be in config files only)
if grep -rE "(firebase|FIREBASE).*['\"][a-zA-Z0-9]{30,}['\"]" lib/*.dart 2>/dev/null | grep -v "TODO\|example"; then
    report_warning "Firebase configuration found in Dart code - should be in config files"
fi

# 2. Check for hardcoded secrets
echo -e "\n${BLUE}Checking for hardcoded secrets...${NC}"

# Passwords
if grep -rE "(password|PASSWORD|pwd|PWD)\s*=\s*['\"][^'\"]{6,}['\"]" lib/ test/ 2>/dev/null | grep -v "TODO\|example\|test" | grep -v ".git"; then
    report_issue "Hardcoded passwords found"
fi

# Secret keys
if grep -rE "(secret|SECRET|secret_key|SECRET_KEY)\s*=\s*['\"][^'\"]{10,}['\"]" lib/ 2>/dev/null | grep -v "TODO\|example" | grep -v ".git"; then
    report_issue "Hardcoded secrets found"
fi

# Private keys
if grep -r "BEGIN PRIVATE KEY\|BEGIN RSA PRIVATE KEY" . 2>/dev/null | grep -v ".git"; then
    report_issue "Private keys found in repository"
fi

# 3. Check .gitignore
echo -e "\n${BLUE}Checking .gitignore configuration...${NC}"

required_patterns=("*.keystore" "key.properties" ".env" "*.jks")
missing_patterns=()

for pattern in "${required_patterns[@]}"; do
    if ! grep -q "$pattern" .gitignore 2>/dev/null; then
        missing_patterns+=("$pattern")
    fi
done

if [ ${#missing_patterns[@]} -gt 0 ]; then
    report_warning ".gitignore missing patterns: ${missing_patterns[*]}"
else
    echo -e "${GREEN}✓ .gitignore properly configured${NC}"
fi

# 4. Check for sensitive files
echo -e "\n${BLUE}Checking for sensitive files...${NC}"

sensitive_files=("key.properties" "keystore.jks" "*.keystore" "google-services.json" ".env")
found_sensitive=false

for pattern in "${sensitive_files[@]}"; do
    if find . -name "$pattern" -not -path "./.git/*" 2>/dev/null | grep -q .; then
        files=$(find . -name "$pattern" -not -path "./.git/*")
        for file in $files; do
            # Check if file is tracked by git
            if git ls-files --error-unmatch "$file" 2>/dev/null; then
                report_issue "Sensitive file tracked in git: $file"
                found_sensitive=true
            fi
        done
    fi
done

if [ "$found_sensitive" = false ]; then
    echo -e "${GREEN}✓ No sensitive files tracked in git${NC}"
fi

# 5. Check for insecure Random() usage
echo -e "\n${BLUE}Checking for secure RNG usage...${NC}"

if grep -r "Random()" lib/ 2>/dev/null | grep -v "Random.secure()" | grep -v "test\|example" | grep -v ".git"; then
    report_warning "Found insecure Random() usage - consider Random.secure() for gambling/gaming"
    echo -e "${YELLOW}   Replace 'Random()' with 'Random.secure()' in gambling logic${NC}"
fi

# 6. Check for print statements in production code
echo -e "\n${BLUE}Checking for debug print statements...${NC}"

print_count=$(grep -r "print(" lib/ 2>/dev/null | grep -v "// print\|test\|example" | wc -l || echo "0")

if [ "$print_count" -gt 5 ]; then
    report_warning "Found $print_count print() statements in lib/ - consider using proper logging"
fi

# 7. Check for TODO/FIXME with security implications
echo -e "\n${BLUE}Checking for security-related TODOs...${NC}"

security_todos=$(grep -ri "TODO.*secur\|FIXME.*secur\|TODO.*auth\|FIXME.*auth\|TODO.*encrypt\|FIXME.*encrypt" lib/ test/ 2>/dev/null || echo "")

if [ -n "$security_todos" ]; then
    report_warning "Found security-related TODOs:"
    echo "$security_todos" | head -3
fi

# 8. Check for outdated dependencies (basic check)
echo -e "\n${BLUE}Checking dependencies...${NC}"

if [ -f "pubspec.lock" ]; then
    # Check for very old Flutter packages (this is a basic check)
    # In a real scenario, you'd use a tool like 'pub outdated' or check against a vulnerability database
    
    # Check if firebase packages are present and reasonably updated
    if grep -q "firebase" pubspec.yaml; then
        echo -e "${GREEN}✓ Firebase dependencies found in pubspec.yaml${NC}"
        echo -e "${YELLOW}   Run 'flutter pub outdated' to check for updates${NC}"
    fi
    
    # Check for deprecated packages
    if grep -q "charts_flutter" pubspec.yaml; then
        report_warning "Using deprecated package: charts_flutter (use fl_chart instead)"
    fi
else
    report_warning "pubspec.lock not found"
fi

# 9. Summary
echo ""
echo "======================================"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ Security scan passed!${NC}"
    echo -e "${GREEN}No critical security issues found${NC}"
    exit 0
else
    echo -e "${RED}❌ Security scan failed!${NC}"
    echo -e "${RED}Found $ISSUES_FOUND security issue(s)${NC}"
    echo ""
    echo -e "${YELLOW}Action required:${NC}"
    echo "1. Remove hardcoded secrets from code"
    echo "2. Use environment variables for sensitive data"
    echo "3. Update .gitignore to exclude sensitive files"
    echo "4. Use Firebase Remote Config for API keys"
    echo ""
    echo -e "${BLUE}Resources:${NC}"
    echo "- Environment variables: https://dart.dev/guides/environment-declarations"
    echo "- Firebase Remote Config: https://firebase.google.com/docs/remote-config"
    echo "- Secure storage: https://pub.dev/packages/flutter_secure_storage"
    echo ""
    exit 1
fi
