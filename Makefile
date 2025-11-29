# Makefile for Tokyo Roulette Predicciones - Flutter/Dart Project
# This Makefile provides convenient commands for building, testing, and linting.
# Compatible with both macOS and Linux environments.

.PHONY: help build test lint analyze format apk aab clean deps doctor

# Default shell and settings for cross-platform compatibility
SHELL := /bin/bash
.DEFAULT_GOAL := help

# Color codes for pretty output (works on both macOS and Linux)
GREEN  := $(shell tput -Txterm setaf 2 2>/dev/null || echo "")
YELLOW := $(shell tput -Txterm setaf 3 2>/dev/null || echo "")
BLUE   := $(shell tput -Txterm setaf 4 2>/dev/null || echo "")
RESET  := $(shell tput -Txterm sgr0 2>/dev/null || echo "")

## help: Display this help message
help:
	@echo "$(BLUE)Tokyo Roulette Predicciones - Build Commands$(RESET)"
	@echo ""
	@echo "$(YELLOW)Usage:$(RESET)"
	@echo "  make <target>"
	@echo ""
	@echo "$(YELLOW)Targets:$(RESET)"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed -e 's/^## /  /' | column -t -s ':'

## deps: Install Flutter dependencies
deps:
	@echo "$(GREEN)Installing dependencies...$(RESET)"
	flutter pub get

## doctor: Run Flutter doctor to check environment
doctor:
	@echo "$(GREEN)Running Flutter doctor...$(RESET)"
	flutter doctor -v

## build: Build the Flutter project (debug mode)
build: deps
	@echo "$(GREEN)Building Flutter project (debug)...$(RESET)"
	flutter build apk --debug

## test: Run all unit and widget tests
test: deps
	@echo "$(GREEN)Running tests...$(RESET)"
	flutter test --coverage

## lint: Run static analysis (dart analyze)
lint: deps
	@echo "$(GREEN)Running static analysis...$(RESET)"
	flutter analyze

## analyze: Alias for lint
analyze: lint

## format: Format Dart code
format:
	@echo "$(GREEN)Formatting code...$(RESET)"
	dart format lib/ test/

## format-check: Check if code is formatted correctly
format-check:
	@echo "$(GREEN)Checking code format...$(RESET)"
	dart format --set-exit-if-changed lib/ test/

## apk: Build release APK
apk: deps
	@echo "$(GREEN)Building release APK...$(RESET)"
	flutter build apk --release
	@echo "$(GREEN)APK built successfully!$(RESET)"
	@ls -lh build/app/outputs/flutter-apk/app-release.apk 2>/dev/null || echo "APK location may vary"

## aab: Build release Android App Bundle (AAB)
aab: deps
	@echo "$(GREEN)Building release AAB...$(RESET)"
	flutter build appbundle --release
	@echo "$(GREEN)AAB built successfully!$(RESET)"
	@ls -lh build/app/outputs/bundle/release/app-release.aab 2>/dev/null || echo "AAB location may vary"

## clean: Clean build artifacts
clean:
	@echo "$(GREEN)Cleaning build artifacts...$(RESET)"
	flutter clean
	@rm -rf coverage/
	@rm -rf build/
	@echo "$(GREEN)Clean complete!$(RESET)"

## ci: Run all CI checks (lint, format-check, test)
ci: deps lint format-check test
	@echo "$(GREEN)All CI checks passed!$(RESET)"

## release: Build both APK and AAB for release
release: apk aab
	@echo "$(GREEN)Release builds complete!$(RESET)"

## coverage: Generate test coverage report
coverage: test
	@echo "$(GREEN)Coverage report generated at coverage/lcov.info$(RESET)"
	@if command -v genhtml &> /dev/null; then \
		genhtml coverage/lcov.info -o coverage/html; \
		echo "$(GREEN)HTML report generated at coverage/html/index.html$(RESET)"; \
	fi

## run: Run the app in debug mode
run: deps
	@echo "$(GREEN)Starting app...$(RESET)"
	flutter run
