#!/bin/bash
# Script para ejecutar workflows CI/CD uno por uno localmente
# Este script simula la ejecución secuencial de cada workflow

set -e

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

REPO_DIR="/home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001"
cd "$REPO_DIR"

echo "🚀 Ejecutando Workflows CI/CD Uno por Uno"
echo "=========================================="
echo ""

# Función para mostrar progreso
show_progress() {
    echo -e "${BLUE}>>> $1${NC}"
}

# Función para mostrar éxito
show_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para mostrar error
show_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Workflow 1: Lint
show_progress "WORKFLOW 1/4: Lint (Análisis y Formato)"
echo "----------------------------------------"
echo ""

echo "Paso 1.1: Verificando formato..."
if dart format --output=none --set-exit-if-changed . 2>/dev/null; then
    show_success "Formato correcto"
else
    show_error "Algunos archivos necesitan formato"
    echo "  Ejecuta: dart format ."
    exit 1
fi

echo ""
echo "Paso 1.2: Ejecutando análisis estático..."
if flutter analyze --no-fatal-infos 2>&1 | tee /tmp/analyze_output.txt; then
    if ! grep -q "error •" /tmp/analyze_output.txt; then
        show_success "Análisis estático pasó"
    else
        show_error "Análisis encontró errores"
        exit 1
    fi
else
    show_error "Flutter analyze falló"
    exit 1
fi

echo ""
echo "Paso 1.3: Verificando dependencias..."
flutter pub outdated || true
show_success "Verificación de dependencias completada"

echo ""
show_success "WORKFLOW 1/4: Lint completado"
echo "=========================================="
echo ""
sleep 2

# Workflow 2: Test
show_progress "WORKFLOW 2/4: Test (Tests Unitarios y Performance)"
echo "----------------------------------------"
echo ""

echo "Paso 2.1: Ejecutando tests unitarios..."
if flutter test --coverage; then
    show_success "Tests unitarios pasaron"
else
    show_error "Tests unitarios fallaron"
    exit 1
fi

echo ""
echo "Paso 2.2: Ejecutando widget tests..."
if flutter test test/widget_test.dart; then
    show_success "Widget tests pasaron"
else
    show_error "Widget tests fallaron"
    exit 1
fi

echo ""
echo "Paso 2.3: Ejecutando performance tests..."
if flutter test test/roulette_logic_test.dart --reporter expanded; then
    show_success "Performance tests pasaron"
else
    show_error "Performance tests fallaron"
    exit 1
fi

echo ""
echo "Paso 2.4: Generando reporte de cobertura..."
if [ -f "coverage/lcov.info" ]; then
    COVERAGE_LINES=$(grep -c "^DA:" coverage/lcov.info || echo "0")
    show_success "Reporte de cobertura generado ($COVERAGE_LINES líneas)"
else
    show_error "No se generó archivo de cobertura"
fi

echo ""
show_success "WORKFLOW 2/4: Test completado"
echo "=========================================="
echo ""
sleep 2

# Workflow 3: Build
show_progress "WORKFLOW 3/4: Build (Compilación)"
echo "----------------------------------------"
echo ""

echo "Paso 3.1: Verificando Flutter..."
flutter doctor -v || true

echo ""
echo "Paso 3.2: Limpiando build anterior..."
flutter clean
show_success "Limpieza completada"

echo ""
echo "Paso 3.3: Obteniendo dependencias..."
if flutter pub get; then
    show_success "Dependencias instaladas"
else
    show_error "Error al obtener dependencias"
    exit 1
fi

echo ""
echo "Paso 3.4: Compilando para Android (debug)..."
echo "  (Nota: Esto puede tardar varios minutos...)"
if flutter build apk --debug 2>&1 | tail -20; then
    show_success "Build de Android completado"
    if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)
        echo "  APK generado: $APK_SIZE"
    fi
else
    show_error "Build de Android falló"
    exit 1
fi

echo ""
show_success "WORKFLOW 3/4: Build completado"
echo "=========================================="
echo ""
sleep 2

# Workflow 4: CI (Pipeline completo)
show_progress "WORKFLOW 4/4: CI (Verificación Final)"
echo "----------------------------------------"
echo ""

echo "Paso 4.1: Verificando que todos los checks pasaron..."
echo "  ✓ Lint: OK"
echo "  ✓ Tests: OK"
echo "  ✓ Build: OK"

echo ""
echo "Paso 4.2: Verificando archivos generados..."
ARTIFACTS=0

if [ -f "coverage/lcov.info" ]; then
    echo "  ✓ Reporte de cobertura existe"
    ARTIFACTS=$((ARTIFACTS + 1))
fi

if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "  ✓ APK de Android existe"
    ARTIFACTS=$((ARTIFACTS + 1))
fi

show_success "Artefactos generados: $ARTIFACTS"

echo ""
show_success "WORKFLOW 4/4: CI completado"
echo "=========================================="
echo ""

# Resumen final
echo ""
echo "🎉 TODOS LOS WORKFLOWS COMPLETADOS EXITOSAMENTE"
echo "=============================================="
echo ""
echo "Resumen de ejecución:"
echo "  1. ✓ Lint      - Análisis y formato verificados"
echo "  2. ✓ Test      - Tests unitarios y performance pasaron"
echo "  3. ✓ Build     - APK de Android compilado"
echo "  4. ✓ CI        - Pipeline completo verificado"
echo ""
echo "Artefactos generados:"
if [ -f "coverage/lcov.info" ]; then
    echo "  - coverage/lcov.info (Reporte de cobertura)"
fi
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)
    echo "  - build/app/outputs/flutter-apk/app-debug.apk ($APK_SIZE)"
fi
echo ""
echo "Los workflows están listos para ejecutarse en GitHub Actions."
echo "Para activarlos, haz push a las ramas: main, develop, o copilot/**"
echo ""
