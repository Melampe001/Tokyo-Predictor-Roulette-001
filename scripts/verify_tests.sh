#!/bin/bash
# Verification script for testing suite implementation
# Checks that all required test infrastructure is in place

set -e

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║     Testing Suite Implementation Verification            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

ERRORS=0
WARNINGS=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

echo "1. Checking directory structure..."
[ -d "test/unit" ] && check_pass "test/unit/ exists" || check_fail "test/unit/ missing"
[ -d "test/widget" ] && check_pass "test/widget/ exists" || check_fail "test/widget/ missing"
[ -d "test/fixtures" ] && check_pass "test/fixtures/ exists" || check_fail "test/fixtures/ missing"
[ -d "test/helpers" ] && check_pass "test/helpers/ exists" || check_fail "test/helpers/ missing"
[ -d "test/performance" ] && check_pass "test/performance/ exists" || check_fail "test/performance/ missing"
[ -d "test/mocks" ] && check_pass "test/mocks/ exists" || check_fail "test/mocks/ missing"
[ -d "test/golden" ] && check_pass "test/golden/ exists" || check_fail "test/golden/ missing"
[ -d "integration_test" ] && check_pass "integration_test/ exists" || check_fail "integration_test/ missing"

echo ""
echo "2. Checking test files..."
[ -f "test/unit/roulette_logic_test.dart" ] && check_pass "Unit test: roulette_logic_test.dart" || check_fail "Missing roulette_logic_test.dart"
[ -f "test/unit/validators_test.dart" ] && check_pass "Unit test: validators_test.dart" || check_fail "Missing validators_test.dart"
[ -f "test/widget/login_screen_test.dart" ] && check_pass "Widget test: login_screen_test.dart" || check_fail "Missing login_screen_test.dart"
[ -f "test/widget/main_screen_test.dart" ] && check_pass "Widget test: main_screen_test.dart" || check_fail "Missing main_screen_test.dart"
[ -f "test/performance/roulette_performance_test.dart" ] && check_pass "Performance test: roulette_performance_test.dart" || check_fail "Missing roulette_performance_test.dart"
[ -f "integration_test/app_test.dart" ] && check_pass "Integration test: app_test.dart" || check_fail "Missing app_test.dart"

echo ""
echo "3. Checking fixtures and helpers..."
[ -f "test/fixtures/user_fixtures.dart" ] && check_pass "Fixture: user_fixtures.dart" || check_fail "Missing user_fixtures.dart"
[ -f "test/fixtures/roulette_fixtures.dart" ] && check_pass "Fixture: roulette_fixtures.dart" || check_fail "Missing roulette_fixtures.dart"
[ -f "test/helpers/widget_tester_extension.dart" ] && check_pass "Helper: widget_tester_extension.dart" || check_fail "Missing widget_tester_extension.dart"

echo ""
echo "4. Checking scripts..."
[ -f "scripts/test.sh" ] && check_pass "Script: test.sh" || check_fail "Missing test.sh"
[ -f "scripts/test_unit.sh" ] && check_pass "Script: test_unit.sh" || check_fail "Missing test_unit.sh"
[ -f "scripts/test_widget.sh" ] && check_pass "Script: test_widget.sh" || check_fail "Missing test_widget.sh"
[ -f "scripts/test_integration.sh" ] && check_pass "Script: test_integration.sh" || check_fail "Missing test_integration.sh"

# Check if scripts are executable
[ -x "scripts/test.sh" ] && check_pass "test.sh is executable" || check_warn "test.sh not executable (run: chmod +x scripts/test.sh)"
[ -x "scripts/test_unit.sh" ] && check_pass "test_unit.sh is executable" || check_warn "test_unit.sh not executable"
[ -x "scripts/test_widget.sh" ] && check_pass "test_widget.sh is executable" || check_warn "test_widget.sh not executable"
[ -x "scripts/test_integration.sh" ] && check_pass "test_integration.sh is executable" || check_warn "test_integration.sh not executable"

echo ""
echo "5. Checking documentation..."
[ -f "docs/TESTING.md" ] && check_pass "Documentation: TESTING.md" || check_fail "Missing TESTING.md"
[ -f "test/README.md" ] && check_pass "Documentation: test/README.md" || check_fail "Missing test/README.md"
[ -f "docs/TESTING_IMPLEMENTATION_SUMMARY.md" ] && check_pass "Documentation: TESTING_IMPLEMENTATION_SUMMARY.md" || check_warn "Missing TESTING_IMPLEMENTATION_SUMMARY.md"

echo ""
echo "6. Checking dependencies in pubspec.yaml..."
if grep -q "mockito:" pubspec.yaml; then
    check_pass "Dependency: mockito"
else
    check_warn "Dependency missing: mockito"
fi

if grep -q "build_runner:" pubspec.yaml; then
    check_pass "Dependency: build_runner"
else
    check_warn "Dependency missing: build_runner"
fi

if grep -q "golden_toolkit:" pubspec.yaml; then
    check_pass "Dependency: golden_toolkit"
else
    check_warn "Dependency missing: golden_toolkit"
fi

echo ""
echo "7. Counting test files..."
DART_TEST_FILES=$(find test -name "*_test.dart" -type f | wc -l)
INTEGRATION_TEST_FILES=$(find integration_test -name "*_test.dart" -type f 2>/dev/null | wc -l || echo 0)
TOTAL_TEST_FILES=$((DART_TEST_FILES + INTEGRATION_TEST_FILES))

echo "   Test files found: $TOTAL_TEST_FILES"
if [ "$TOTAL_TEST_FILES" -ge 9 ]; then
    check_pass "Sufficient test files ($TOTAL_TEST_FILES >= 9)"
else
    check_warn "Expected at least 9 test files, found $TOTAL_TEST_FILES"
fi

echo ""
echo "8. Checking for coverage configuration..."
if [ -f "test/coverage_helper_test.dart" ]; then
    check_pass "Coverage helper exists"
else
    check_warn "Coverage helper missing (optional)"
fi

echo ""
echo "9. Checking CI/CD configuration..."
if [ -f ".github/workflows/ci.yml" ]; then
    check_pass "CI workflow exists"
    if grep -q "flutter test --coverage" .github/workflows/ci.yml; then
        check_pass "CI runs tests with coverage"
    else
        check_warn "CI might not generate coverage"
    fi
else
    check_fail "CI workflow missing"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "VERIFICATION SUMMARY"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Total test files: $TOTAL_TEST_FILES"
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "Testing suite implementation is complete and verified."
    echo ""
    echo "Next steps:"
    echo "  1. Run tests: flutter test"
    echo "  2. Generate coverage: flutter test --coverage"
    echo "  3. View coverage: genhtml coverage/lcov.info -o coverage/html"
    echo ""
    exit 0
else
    echo -e "${RED}✗ VERIFICATION FAILED${NC}"
    echo ""
    echo "Please fix the errors above before proceeding."
    echo ""
    exit 1
fi
