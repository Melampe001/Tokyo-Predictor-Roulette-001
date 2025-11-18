#!/bin/bash
# Script para ejecutar solo el workflow de Test

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="/home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001"
cd "$REPO_DIR"

echo "🧪 Ejecutando Workflow: Test"
echo "============================"
echo ""

# 1. Unit Tests
echo "1/3: Ejecutando tests unitarios con cobertura..."
if flutter test --coverage; then
    echo -e "${GREEN}✓ Tests unitarios pasaron${NC}"
else
    echo -e "${RED}✗ Tests unitarios fallaron${NC}"
    exit 1
fi

echo ""

# 2. Widget Tests
echo "2/3: Ejecutando widget tests..."
if flutter test test/widget_test.dart; then
    echo -e "${GREEN}✓ Widget tests pasaron${NC}"
else
    echo -e "${RED}✗ Widget tests fallaron${NC}"
    exit 1
fi

echo ""

# 3. Performance Tests
echo "3/3: Ejecutando performance tests..."
if flutter test test/roulette_logic_test.dart --reporter expanded; then
    echo -e "${GREEN}✓ Performance tests pasaron${NC}"
else
    echo -e "${RED}✗ Performance tests fallaron${NC}"
    exit 1
fi

echo ""

# Reporte de cobertura
if [ -f "coverage/lcov.info" ]; then
    LINES=$(grep -c "^DA:" coverage/lcov.info || echo "0")
    echo "Cobertura generada: $LINES líneas cubiertas"
fi

echo ""
echo -e "${GREEN}✅ Workflow Test completado exitosamente${NC}"
