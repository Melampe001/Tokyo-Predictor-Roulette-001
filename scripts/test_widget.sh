#!/bin/bash
# Test runner script for widget tests only
# Runs all tests in test/widget/ directory

set -e

echo "🎨 Running Widget Tests..."
echo ""

# Run widget tests
flutter test test/widget/ --reporter expanded

echo ""
echo "✅ Widget tests completed successfully"
