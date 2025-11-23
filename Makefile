.PHONY: fmt
fmt:
	@echo "Running formatters..."
	@# Format shell scripts if shfmt is available
	@if command -v shfmt >/dev/null 2>&1; then \
		echo "Formatting shell scripts with shfmt..."; \
		find scripts -type f -name "*.sh" -exec shfmt -w {} \; 2>/dev/null || true; \
	else \
		echo "shfmt not found, skipping shell script formatting"; \
	fi
	@echo "Formatting complete."
