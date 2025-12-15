# Makefile for Tokyo Roulette Predictor
# Compatible with Linux, macOS, and Windows (Git Bash)

.PHONY: help setup format lint test test-unit test-widget build-debug build-release check clean validate-structure check-security

# Default target
.DEFAULT_GOAL := help

# Colors for output (works on Unix-like systems)
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Check if Flutter is installed
FLUTTER := $(shell command -v flutter 2> /dev/null)
DART := $(shell command -v dart 2> /dev/null)

help: ## Display this help message
	@echo "$(BLUE)Tokyo Roulette Predictor - Available Commands$(NC)"
	@echo "=============================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Usage: make <target>$(NC)"
	@echo ""

setup: ## Install dependencies and setup development environment
	@echo "$(BLUE)Setting up development environment...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found. Please install Flutter first.$(NC)"
	@echo "Visit: https://docs.flutter.dev/get-started/install"
	@exit 1
endif
	@echo "$(GREEN)✓ Flutter found$(NC)"
	@flutter --version
	@echo ""
	@echo "$(BLUE)Installing dependencies...$(NC)"
	@flutter pub get
	@echo ""
	@echo "$(BLUE)Installing Git hooks...$(NC)"
	@bash scripts/install-hooks.sh
	@echo ""
	@echo "$(GREEN)✓ Setup complete!$(NC)"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'make check' to verify everything works"
	@echo "  2. Run 'make test' to run tests"
	@echo "  3. Start coding! Pre-commit hooks will run automatically"

format: ## Format all Dart files
	@echo "$(BLUE)Formatting Dart files...$(NC)"
ifndef DART
	@echo "$(RED)Error: Dart not found.$(NC)"
	@exit 1
endif
	@dart format lib/ test/
	@echo "$(GREEN)✓ Formatting complete$(NC)"

format-check: ## Check if code is formatted (used in CI)
	@echo "$(BLUE)Checking code formatting...$(NC)"
ifndef DART
	@echo "$(RED)Error: Dart not found.$(NC)"
	@exit 1
endif
	@dart format --set-exit-if-changed lib/ test/ || (echo "$(RED)✗ Code needs formatting. Run 'make format'$(NC)" && exit 1)
	@echo "$(GREEN)✓ Code is properly formatted$(NC)"

lint: ## Run Dart analyzer
	@echo "$(BLUE)Running static analysis...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found.$(NC)"
	@exit 1
endif
	@flutter analyze --fatal-infos || (echo "$(RED)✗ Analysis failed$(NC)" && exit 1)
	@echo "$(GREEN)✓ Analysis passed$(NC)"

test: ## Run all tests with coverage
	@echo "$(BLUE)Running all tests with coverage...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found.$(NC)"
	@exit 1
endif
	@flutter test --coverage
	@echo "$(GREEN)✓ Tests passed$(NC)"
	@echo ""
	@echo "$(BLUE)Checking coverage...$(NC)"
	@bash scripts/check-coverage.sh || true

test-unit: ## Run unit tests only
	@echo "$(BLUE)Running unit tests...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found.$(NC)"
	@exit 1
endif
	@flutter test test/roulette_logic_test.dart
	@echo "$(GREEN)✓ Unit tests passed$(NC)"

test-widget: ## Run widget tests only
	@echo "$(BLUE)Running widget tests...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found.$(NC)"
	@exit 1
endif
	@flutter test test/widget_test.dart
	@echo "$(GREEN)✓ Widget tests passed$(NC)"

build-debug: ## Build debug APK
	@echo "$(BLUE)Building debug APK...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found.$(NC)"
	@exit 1
endif
	@flutter build apk --debug
	@echo "$(GREEN)✓ Debug APK built successfully$(NC)"
	@echo "Location: build/app/outputs/flutter-apk/app-debug.apk"

build-release: ## Build release APK and AAB
	@echo "$(BLUE)Building release APK and AAB...$(NC)"
ifndef FLUTTER
	@echo "$(RED)Error: Flutter not found.$(NC)"
	@exit 1
endif
	@echo "$(BLUE)Building APK...$(NC)"
	@flutter build apk --release
	@echo "$(BLUE)Building AAB...$(NC)"
	@flutter build appbundle --release
	@echo "$(GREEN)✓ Release builds completed$(NC)"
	@echo "APK: build/app/outputs/flutter-apk/app-release.apk"
	@echo "AAB: build/app/outputs/bundle/release/app-release.aab"

check: ## Run all quality checks (format, lint, test, security)
	@echo "$(BLUE)========================================$(NC)"
	@echo "$(BLUE)Running all quality checks...$(NC)"
	@echo "$(BLUE)========================================$(NC)"
	@echo ""
	@$(MAKE) format-check
	@echo ""
	@$(MAKE) lint
	@echo ""
	@$(MAKE) test
	@echo ""
	@$(MAKE) check-security
	@echo ""
	@$(MAKE) validate-structure
	@echo ""
	@echo "$(GREEN)========================================$(NC)"
	@echo "$(GREEN)✓ All quality checks passed!$(NC)"
	@echo "$(GREEN)========================================$(NC)"

clean: ## Clean build artifacts
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
ifndef FLUTTER
	@echo "$(YELLOW)Warning: Flutter not found. Cleaning manually...$(NC)"
	@rm -rf build/
	@rm -rf .dart_tool/
else
	@flutter clean
endif
	@echo "$(GREEN)✓ Clean complete$(NC)"

validate-structure: ## Validate project structure
	@echo "$(BLUE)Validating project structure...$(NC)"
	@echo "Checking required files..."
	@test -f pubspec.yaml || (echo "$(RED)✗ pubspec.yaml missing$(NC)" && exit 1)
	@test -f analysis_options.yaml || (echo "$(RED)✗ analysis_options.yaml missing$(NC)" && exit 1)
	@test -f README.md || (echo "$(RED)✗ README.md missing$(NC)" && exit 1)
	@test -d lib || (echo "$(RED)✗ lib/ directory missing$(NC)" && exit 1)
	@test -d test || (echo "$(RED)✗ test/ directory missing$(NC)" && exit 1)
	@test -f lib/main.dart || (echo "$(RED)✗ lib/main.dart missing$(NC)" && exit 1)
	@test -f lib/roulette_logic.dart || (echo "$(RED)✗ lib/roulette_logic.dart missing$(NC)" && exit 1)
	@echo "Checking security files..."
	@test -f .gitignore || (echo "$(RED)✗ .gitignore missing$(NC)" && exit 1)
	@grep -q "*.keystore" .gitignore || (echo "$(YELLOW)⚠ .gitignore should include *.keystore$(NC)")
	@grep -q "key.properties" .gitignore || (echo "$(YELLOW)⚠ .gitignore should include key.properties$(NC)")
	@grep -q ".env" .gitignore || (echo "$(YELLOW)⚠ .gitignore should include .env$(NC)")
	@echo "$(GREEN)✓ Project structure validated$(NC)"

check-security: ## Run security scan
	@echo "$(BLUE)Running security scan...$(NC)"
	@bash scripts/security-scan.sh

# Internal target for CI
ci-check: format-check lint test check-security
	@echo "$(GREEN)✓ CI checks passed$(NC)"
