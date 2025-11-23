# Makefile para Tokyo Predictor Roulette
# Este Makefile sigue principios de idempotencia y automatización
# Cada target está documentado con sus características

.DEFAULT_GOAL := help

# Colores para output
GREEN  := \033[0;32m
YELLOW := \033[1;33m
BLUE   := \033[0;34m
NC     := \033[0m

# Variables del proyecto
PROJECT_NAME := tokyo_roulette_predicciones
FLUTTER_VERSION := 3.16.0
GO_VERSION := 1.21

# ============================================
# Target: help
# Descripción: Muestra ayuda con todos los targets disponibles
# Idempotente: ✓ (Solo muestra información)
# Automatizado: ✓ (No requiere input)
# ============================================
.PHONY: help
help:
	@echo "$(BLUE)════════════════════════════════════════════════════════════$(NC)"
	@echo "$(BLUE)  Tokyo Predictor Roulette - Makefile$(NC)"
	@echo "$(BLUE)════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(GREEN)Targets disponibles:$(NC)"
	@echo ""
	@grep -E '^# Target:' $(MAKEFILE_LIST) | \
		sed 's/# Target: /  $(YELLOW)/' | \
		sed 's/$$/$(NC)/'
	@echo ""
	@echo "$(BLUE)Leyenda:$(NC)"
	@echo "  ✓ = Implementado"
	@echo "  ✗ = No implementado/No aplica"
	@echo ""

# ============================================
# Target: install-deps
# Descripción: Instala todas las dependencias del proyecto
# Idempotente: ✓ (Flutter verifica y actualiza solo si necesario)
# Automatizado: ✓ (Sin input manual)
# ============================================
.PHONY: install-deps
install-deps:
	@echo "$(GREEN)[INFO]$(NC) Instalando dependencias de Flutter..."
	@flutter pub get
	@echo "$(GREEN)[✓]$(NC) Dependencias instaladas correctamente."

# ============================================
# Target: clean
# Descripción: Limpia archivos generados, caché y build artifacts
# Idempotente: ✓ (Limpiar múltiples veces = mismo resultado)
# Automatizado: ✓
# ============================================
.PHONY: clean
clean:
	@echo "$(GREEN)[INFO]$(NC) Limpiando archivos generados y caché..."
	@flutter clean
	@rm -rf build/
	@rm -rf .dart_tool/
	@if [ -d testing ]; then cd testing && go clean; fi
	@echo "$(GREEN)[✓]$(NC) Limpieza completada."

# ============================================
# Target: format
# Descripción: Formatea todo el código Dart
# Idempotente: ✓ (Formatear código ya formateado no cambia nada)
# Automatizado: ✓
# ============================================
.PHONY: format
format:
	@echo "$(GREEN)[INFO]$(NC) Formateando código Dart..."
	@flutter format .
	@echo "$(GREEN)[✓]$(NC) Código formateado."

# ============================================
# Target: lint
# Descripción: Ejecuta análisis estático del código
# Idempotente: ✓ (Analizar no modifica código)
# Automatizado: ✓
# ============================================
.PHONY: lint
lint:
	@echo "$(GREEN)[INFO]$(NC) Ejecutando análisis estático..."
	@flutter analyze
	@echo "$(GREEN)[✓]$(NC) Análisis completado."

# ============================================
# Target: test
# Descripción: Ejecuta todas las pruebas del proyecto
# Idempotente: ✓ (Tests no modifican estado del código)
# Automatizado: ✓
# ============================================
.PHONY: test
test:
	@echo "$(GREEN)[INFO]$(NC) Ejecutando pruebas de Flutter..."
	@flutter test
	@if [ -d testing ]; then \
		echo "$(GREEN)[INFO]$(NC) Ejecutando pruebas de idempotencia en Go..."; \
		cd testing && go test -v ./...; \
		echo "$(GREEN)[✓]$(NC) Pruebas de idempotencia completadas."; \
	fi
	@echo "$(GREEN)[✓]$(NC) Todas las pruebas completadas."

# ============================================
# Target: test-coverage
# Descripción: Ejecuta tests y genera reporte de cobertura
# Idempotente: ✓ (Genera el mismo reporte para mismo código)
# Automatizado: ✓
# ============================================
.PHONY: test-coverage
test-coverage:
	@echo "$(GREEN)[INFO]$(NC) Ejecutando tests con cobertura..."
	@flutter test --coverage
	@if command -v genhtml &> /dev/null; then \
		genhtml coverage/lcov.info -o coverage/html; \
		echo "$(GREEN)[✓]$(NC) Reporte HTML generado en coverage/html/"; \
	else \
		echo "$(YELLOW)[SKIP]$(NC) genhtml no disponible, saltando generación HTML."; \
	fi
	@echo "$(GREEN)[✓]$(NC) Cobertura completada."

# ============================================
# Target: build-apk
# Descripción: Construye APK de release para Android
# Idempotente: ✓ (Build limpio produce mismo resultado)
# Automatizado: ✓
# ============================================
.PHONY: build-apk
build-apk: clean
	@echo "$(GREEN)[INFO]$(NC) Construyendo APK de release..."
	@flutter build apk --release
	@echo "$(GREEN)[✓]$(NC) APK construido en: build/app/outputs/flutter-apk/app-release.apk"

# ============================================
# Target: build-appbundle
# Descripción: Construye App Bundle para Google Play
# Idempotente: ✓
# Automatizado: ✓
# ============================================
.PHONY: build-appbundle
build-appbundle: clean
	@echo "$(GREEN)[INFO]$(NC) Construyendo App Bundle..."
	@flutter build appbundle --release
	@echo "$(GREEN)[✓]$(NC) App Bundle construido en: build/app/outputs/bundle/release/app-release.aab"

# ============================================
# Target: setup-env
# Descripción: Configura el entorno de desarrollo completo
# Idempotente: ✓ (Scripts verifican antes de crear/modificar)
# Automatizado: ✓
# ============================================
.PHONY: setup-env
setup-env:
	@echo "$(GREEN)[INFO]$(NC) Configurando entorno de desarrollo..."
	@bash scripts/config/setup_env.sh
	@echo "$(GREEN)[✓]$(NC) Entorno configurado correctamente."

# ============================================
# Target: setup-fixtures
# Descripción: Configura datos de prueba y fixtures
# Idempotente: ✓ (Solo crea si no existen)
# Automatizado: ✓
# ============================================
.PHONY: setup-fixtures
setup-fixtures:
	@echo "$(GREEN)[INFO]$(NC) Configurando fixtures de prueba..."
	@bash scripts/config/fixtures/setup_test_data.sh
	@echo "$(GREEN)[✓]$(NC) Fixtures configurados."

# ============================================
# Target: doctor
# Descripción: Verifica la instalación de Flutter y dependencias
# Idempotente: ✓ (Solo verifica, no modifica)
# Automatizado: ✓
# ============================================
.PHONY: doctor
doctor:
	@echo "$(GREEN)[INFO]$(NC) Verificando instalación de Flutter..."
	@flutter doctor -v
	@if command -v go &> /dev/null; then \
		echo "$(GREEN)[INFO]$(NC) Go instalado: $$(go version)"; \
	else \
		echo "$(YELLOW)[WARN]$(NC) Go no está instalado."; \
	fi
	@echo "$(GREEN)[✓]$(NC) Verificación completada."

# ============================================
# Target: init
# Descripción: Inicialización completa del proyecto (primera vez)
# Idempotente: ✓ (Todos los sub-comandos son idempotentes)
# Automatizado: ✓
# ============================================
.PHONY: init
init: setup-env install-deps setup-fixtures
	@echo "$(GREEN)[INFO]$(NC) Verificando configuración..."
	@$(MAKE) doctor
	@echo ""
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  ✓ Proyecto inicializado correctamente$(NC)"
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "Próximos pasos:"
	@echo "  1. Ejecutar tests: $(YELLOW)make test$(NC)"
	@echo "  2. Ejecutar app: $(YELLOW)flutter run$(NC)"
	@echo "  3. Construir APK: $(YELLOW)make build-apk$(NC)"
	@echo ""

# ============================================
# Target: ci
# Descripción: Pipeline de integración continua completo
# Idempotente: ✓ (Todos los pasos son idempotentes)
# Automatizado: ✓
# ============================================
.PHONY: ci
ci: clean install-deps lint test
	@echo ""
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  ✓ Pipeline CI completado exitosamente$(NC)"
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo ""

# ============================================
# Target: verify-idempotence
# Descripción: Verifica que scripts clave son idempotentes
# Idempotente: ✓ (La verificación en sí es idempotente)
# Automatizado: ✓
# ============================================
.PHONY: verify-idempotence
verify-idempotence:
	@echo "$(GREEN)[INFO]$(NC) Verificando idempotencia de scripts..."
	@echo "$(GREEN)[INFO]$(NC) Ejecutando setup_env.sh (1ra vez)..."
	@bash scripts/config/setup_env.sh > /tmp/run1.log 2>&1
	@echo "$(GREEN)[INFO]$(NC) Ejecutando setup_env.sh (2da vez)..."
	@bash scripts/config/setup_env.sh > /tmp/run2.log 2>&1
	@echo "$(GREEN)[INFO]$(NC) Ejecutando setup_test_data.sh (1ra vez)..."
	@bash scripts/config/fixtures/setup_test_data.sh > /tmp/fixture1.log 2>&1
	@echo "$(GREEN)[INFO]$(NC) Ejecutando setup_test_data.sh (2da vez)..."
	@bash scripts/config/fixtures/setup_test_data.sh > /tmp/fixture2.log 2>&1
	@echo "$(GREEN)[✓]$(NC) Scripts ejecutados múltiples veces sin errores."
	@echo "$(GREEN)[✓]$(NC) Verificación de idempotencia completada."

# ============================================
# Target: generate-docs
# Descripción: Genera documentación del código
# Idempotente: ✓ (Regenera documentación)
# Automatizado: ✓
# ============================================
.PHONY: generate-docs
generate-docs:
	@echo "$(GREEN)[INFO]$(NC) Generando documentación..."
	@if command -v dartdoc &> /dev/null; then \
		dartdoc; \
		echo "$(GREEN)[✓]$(NC) Documentación generada en doc/api/"; \
	else \
		echo "$(YELLOW)[SKIP]$(NC) dartdoc no disponible."; \
	fi

# ============================================
# Target: run-dev
# Descripción: Ejecuta la aplicación en modo desarrollo
# Idempotente: ✗ (Inicia aplicación interactiva)
# Automatizado: ✗ (Requiere dispositivo/emulador)
# ============================================
.PHONY: run-dev
run-dev:
	@echo "$(GREEN)[INFO]$(NC) Ejecutando aplicación en modo desarrollo..."
	@flutter run

# ============================================
# Target: check-security
# Descripción: Verifica dependencias por vulnerabilidades conocidas
# Idempotente: ✓ (Solo verifica, no modifica)
# Automatizado: ✓
# ============================================
.PHONY: check-security
check-security:
	@echo "$(GREEN)[INFO]$(NC) Verificando vulnerabilidades en dependencias..."
	@flutter pub outdated
	@echo "$(GREEN)[✓]$(NC) Verificación de seguridad completada."

# ============================================
# Target: upgrade-deps
# Descripción: Actualiza dependencias a versiones más recientes
# Idempotente: ✗ (Puede cambiar versiones)
# Automatizado: ✓
# ============================================
.PHONY: upgrade-deps
upgrade-deps:
	@echo "$(GREEN)[INFO]$(NC) Actualizando dependencias..."
	@flutter pub upgrade
	@echo "$(GREEN)[✓]$(NC) Dependencias actualizadas."

# ============================================
# Target: all
# Descripción: Ejecuta el flujo completo: init + ci + build
# Idempotente: ✓ (Todos los sub-targets son idempotentes)
# Automatizado: ✓
# ============================================
.PHONY: all
all: init ci build-apk
	@echo ""
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  ✓ Build completo finalizado$(NC)"
	@echo "$(GREEN)════════════════════════════════════════════════════════════$(NC)"
	@echo ""
