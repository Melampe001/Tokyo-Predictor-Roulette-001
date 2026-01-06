#!/bin/bash
# Complete test runner with coverage and HTML report generation
# This is the main script for running all tests

set -e

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║          Tokyo Roulette - Complete Test Suite            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Run all tests with coverage
echo "🧪 Running all tests with coverage..."
flutter test --coverage --reporter expanded

echo ""
echo "📊 Test Summary:"
echo "════════════════════════════════════════════════════════════"

# Count tests
UNIT_TESTS=$(find test/unit -name "*_test.dart" 2>/dev/null | wc -l || echo "0")
WIDGET_TESTS=$(find test/widget -name "*_test.dart" 2>/dev/null | wc -l || echo "0")
INTEGRATION_TESTS=$(find integration_test -name "*_test.dart" 2>/dev/null | wc -l || echo "0")
TOTAL_TEST_FILES=$((UNIT_TESTS + WIDGET_TESTS + INTEGRATION_TESTS))

echo "  Unit test files: $UNIT_TESTS"
echo "  Widget test files: $WIDGET_TESTS"
echo "  Integration test files: $INTEGRATION_TESTS"
echo "  Total test files: $TOTAL_TEST_FILES"
echo ""

# Generate coverage report if lcov is available
if command -v genhtml &> /dev/null; then
    echo "📈 Generating HTML coverage report..."
    genhtml coverage/lcov.info -o coverage/html --quiet
    echo "✅ Coverage report generated: coverage/html/index.html"
    echo ""
    echo "To view the report:"
    echo "  Open: file://$(pwd)/coverage/html/index.html"
else
    echo "⚠️  genhtml not found. Install lcov to generate HTML reports:"
    echo "  Ubuntu/Debian: sudo apt-get install lcov"
    echo "  macOS: brew install lcov"
fi

echo ""

# Calculate coverage percentage if lcov is available
if command -v lcov &> /dev/null; then
    echo "📊 Coverage Summary:"
    echo "════════════════════════════════════════════════════════════"
    lcov --summary coverage/lcov.info 2>&1 | grep -E "lines|functions"
else
    echo "⚠️  Install lcov to see coverage summary"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ All tests completed successfully!"
echo "════════════════════════════════════════════════════════════"
