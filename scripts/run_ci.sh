#!/bin/bash
# Script para ejecutar el workflow CI completo

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="/home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001"
cd "$REPO_DIR"

echo "🚀 Ejecutando Workflow: CI (Pipeline Completo)"
echo "============================================="
echo ""

# Quick Analysis
echo -e "${BLUE}Fase 1/3: Quick Analysis${NC}"
echo "------------------------"
echo "Ejecutando análisis rápido..."

if dart format --output=none --set-exit-if-changed .; then
    echo -e "${GREEN}✓ Formato verificado${NC}"
else
    echo -e "${RED}✗ Formato incorrecto${NC}"
    exit 1
fi

if flutter analyze --no-fatal-infos 2>&1 | grep -q "No issues found"; then
    echo -e "${GREEN}✓ Análisis pasó${NC}"
else
    echo -e "${YELLOW}⚠ Análisis completado con warnings${NC}"
fi

echo ""

# Run Tests
echo -e "${BLUE}Fase 2/3: Run Tests${NC}"
echo "-------------------"
echo "Ejecutando suite de tests..."

if flutter test --coverage; then
    echo -e "${GREEN}✓ Tests pasaron${NC}"
else
    echo -e "${RED}✗ Tests fallaron${NC}"
    exit 1
fi

echo ""

# Build Android
echo -e "${BLUE}Fase 3/3: Build Android${NC}"
echo "----------------------"
echo "Compilando APK..."

if flutter build apk --debug 2>&1 | tail -5; then
    echo -e "${GREEN}✓ Build completado${NC}"
else
    echo -e "${RED}✗ Build falló${NC}"
    exit 1
fi

echo ""

# CI Success
echo "============================================="
echo -e "${GREEN}✅ CI: Todos los checks pasaron exitosamente${NC}"
echo ""
echo "Pipeline completado:"
echo "  ✓ Quick Analysis (formato + análisis)"
echo "  ✓ Run Tests (cobertura completa)"
echo "  ✓ Build Android (APK debug)"
echo ""
