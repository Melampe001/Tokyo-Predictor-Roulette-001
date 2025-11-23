.PHONY: help fmt build test lint ci

# Ayuda por defecto
help:
	@echo "Comandos disponibles para desarrollo en Dart/Flutter:"
	@echo ""
	@echo "  make fmt     - Formatear código Dart/Flutter"
	@echo "  make build   - Construir aplicación Flutter"
	@echo "  make test    - Ejecutar pruebas Dart/Flutter"
	@echo "  make lint    - Analizar código Dart (linter)"
	@echo "  make ci      - Ejecutar todos los comandos en secuencia (CI manual)"
	@echo "  make help    - Mostrar esta ayuda"
	@echo ""

# Formatear código Dart usando dart format
fmt:
	@echo "🎨 Formateando código Dart..."
	dart format .
	@echo "✅ Formato completado"

# Construir aplicación Flutter (APK para Android)
build:
	@echo "🔨 Construyendo aplicación Flutter..."
	flutter build apk --release
	@echo "✅ Build completado"

# Ejecutar pruebas Dart/Flutter
test:
	@echo "🧪 Ejecutando pruebas..."
	flutter test
	@echo "✅ Pruebas completadas"

# Analizar código Dart (lint)
lint:
	@echo "🔍 Analizando código Dart..."
	dart analyze
	@echo "✅ Análisis completado"

# Pipeline CI manual: ejecuta todos los comandos en secuencia
ci: fmt lint test build
	@echo "✅ Pipeline CI completado exitosamente"
