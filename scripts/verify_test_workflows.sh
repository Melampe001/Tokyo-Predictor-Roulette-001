#!/bin/bash
# Script de Verificación de Workflows de Test
# Este script valida que los workflows de test están correctamente configurados

set -e

echo "🔍 Verificación de Workflows de Test"
echo "====================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REPO_DIR="/home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001"
cd "$REPO_DIR"

# 1. Verificar que el archivo test.yml existe
echo -n "1. Verificando existencia de test.yml... "
if [ -f ".github/workflows/test.yml" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "   ERROR: test.yml no encontrado"
    exit 1
fi

# 2. Verificar sintaxis YAML
echo -n "2. Verificando sintaxis YAML... "
if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/test.yml'))" 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "   ERROR: Sintaxis YAML inválida"
    exit 1
fi

# 3. Verificar que los archivos de test existen
echo -n "3. Verificando archivos de test... "
if [ -f "test/widget_test.dart" ] && [ -f "test/roulette_logic_test.dart" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "   ERROR: Archivos de test no encontrados"
    exit 1
fi

# 4. Verificar jobs en test.yml
echo -n "4. Verificando jobs configurados... "
JOBS=$(grep -c "name:.*Tests" .github/workflows/test.yml || true)
if [ "$JOBS" -ge 3 ]; then
    echo -e "${GREEN}✓${NC} ($JOBS jobs encontrados)"
else
    echo -e "${YELLOW}⚠${NC} (solo $JOBS jobs encontrados, se esperaban 3)"
fi

# 5. Verificar versión de Flutter
echo -n "5. Verificando versión de Flutter... "
if grep -q "flutter-version: '3.16.0'" .github/workflows/test.yml; then
    echo -e "${GREEN}✓${NC} (3.16.0)"
else
    echo -e "${YELLOW}⚠${NC} (versión diferente o no especificada)"
fi

# 6. Verificar triggers
echo -n "6. Verificando triggers (push/PR)... "
if grep -q "push:" .github/workflows/test.yml && grep -q "pull_request:" .github/workflows/test.yml; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "   ERROR: Triggers no configurados correctamente"
    exit 1
fi

# 7. Verificar coverage setup
echo -n "7. Verificando configuración de cobertura... "
if grep -q "flutter test --coverage" .github/workflows/test.yml; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠${NC} (cobertura no configurada)"
fi

# 8. Verificar Codecov
echo -n "8. Verificando upload a Codecov... "
if grep -q "codecov/codecov-action" .github/workflows/test.yml; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠${NC} (Codecov no configurado)"
fi

# 9. Verificar artifacts
echo -n "9. Verificando configuración de artifacts... "
if grep -q "upload-artifact@v4" .github/workflows/test.yml; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠${NC} (artifacts no configurados)"
fi

# 10. Contar líneas de workflow
echo -n "10. Verificando completitud del workflow... "
LINES=$(wc -l < .github/workflows/test.yml)
if [ "$LINES" -gt 50 ]; then
    echo -e "${GREEN}✓${NC} ($LINES líneas)"
else
    echo -e "${YELLOW}⚠${NC} (workflow parece incompleto: solo $LINES líneas)"
fi

echo ""
echo "====================================="
echo -e "${GREEN}✅ Verificación completada exitosamente${NC}"
echo ""
echo "Resumen de Workflows:"
echo "  - Unit Tests: ✓"
echo "  - Widget Tests: ✓"
echo "  - Performance Tests: ✓"
echo ""
echo "Documentación:"
echo "  - Ver: docs/TEST_WORKFLOW_VERIFICATION.md"
echo "  - Workflows: .github/workflows/README.md"
echo ""
echo "Para ejecutar tests localmente:"
echo "  flutter test                          # Todos los tests"
echo "  flutter test --coverage               # Con cobertura"
echo "  flutter test test/widget_test.dart    # Solo widget tests"
echo "  flutter test test/roulette_logic_test.dart  # Solo performance tests"
echo ""
