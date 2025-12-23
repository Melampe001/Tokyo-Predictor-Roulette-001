#!/bin/bash
# Test runner script for integration tests
# Runs all tests in integration_test/ directory

set -e

echo "🔗 Running Integration Tests..."
echo ""

# Run integration tests
flutter test integration_test/ --reporter expanded

echo ""
echo "✅ Integration tests completed successfully"
