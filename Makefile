.PHONY: fmt format clean test build

# Format Dart code using dart format
fmt: format

format:
	@echo "Formatting Dart code..."
	@if command -v dart > /dev/null 2>&1; then \
		dart format .; \
	elif command -v flutter > /dev/null 2>&1; then \
		flutter format .; \
	else \
		echo "Warning: Neither dart nor flutter found in PATH. Skipping format."; \
	fi

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@if command -v flutter > /dev/null 2>&1; then \
		flutter clean; \
	else \
		rm -rf build/; \
		echo "Removed build directory"; \
	fi

# Run tests
test:
	@echo "Running tests..."
	@if command -v flutter > /dev/null 2>&1; then \
		flutter test; \
	else \
		echo "Error: flutter not found in PATH"; \
		exit 1; \
	fi

# Build APK
build:
	@echo "Building APK..."
	@if command -v flutter > /dev/null 2>&1; then \
		flutter build apk --release; \
	else \
		echo "Error: flutter not found in PATH"; \
		exit 1; \
	fi
