#!/bin/bash
# Test runner script for unit tests only
# Runs all tests in test/unit/ directory

set -e

echo "🧪 Running Unit Tests..."
echo ""

# Run unit tests
flutter test test/unit/ --reporter expanded

echo ""
echo "✅ Unit tests completed successfully"
