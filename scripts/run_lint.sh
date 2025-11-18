#!/bin/bash
# Script para ejecutar solo el workflow de Lint

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="/home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001"
cd "$REPO_DIR"

echo "🔍 Ejecutando Workflow: Lint"
echo "============================"
echo ""

# 1. Dart Format
echo "1/3: Verificando formato de código..."
if dart format --output=none --set-exit-if-changed .; then
    echo -e "${GREEN}✓ Formato correcto${NC}"
else
    echo -e "${RED}✗ Algunos archivos necesitan formato${NC}"
    echo "Ejecuta: dart format ."
    exit 1
fi

echo ""

# 2. Flutter Analyze
echo "2/3: Ejecutando análisis estático..."
if flutter analyze --no-fatal-infos; then
    echo -e "${GREEN}✓ Análisis estático pasó${NC}"
else
    echo -e "${RED}✗ Análisis encontró problemas${NC}"
    exit 1
fi

echo ""

# 3. Pub Check
echo "3/3: Verificando dependencias..."
flutter pub outdated || true
echo -e "${GREEN}✓ Verificación de dependencias completada${NC}"

echo ""
echo -e "${GREEN}✅ Workflow Lint completado exitosamente${NC}"
