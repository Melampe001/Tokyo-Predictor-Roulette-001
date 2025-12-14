#!/bin/bash
# Script de verificación de salud del proyecto

echo "🏥 Verificación de Salud del Proyecto"
echo "======================================"
echo ""

ISSUES=0

# 1. Verificar Flutter
echo "🔍 Verificando Flutter..."
if command -v flutter &> /dev/null; then
    echo "  ✅ Flutter instalado: $(flutter --version | head -1)"
else
    echo "  ❌ Flutter no encontrado"
    ((ISSUES++))
fi

# 2. Verificar Dart
echo ""
echo "🔍 Verificando Dart..."
if command -v dart &> /dev/null; then
    echo "  ✅ Dart instalado: $(dart --version 2>&1)"
else
    echo "  ❌ Dart no encontrado"
    ((ISSUES++))
fi

# 3. Verificar Git
echo ""
echo "🔍 Verificando Git..."
if command -v git &> /dev/null; then
    echo "  ✅ Git instalado: $(git --version)"
    echo "  📍 Branch actual: $(git branch --show-current)"
else
    echo "  ❌ Git no encontrado"
    ((ISSUES++))
fi

# 4. Verificar archivos críticos
echo ""
echo "🔍 Verificando archivos críticos..."
CRITICAL_FILES=(
    "pubspec.yaml"
    "lib/main.dart"
    "lib/roulette_logic.dart"
    "android/app/build.gradle"
    "android/build.gradle"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file FALTA"
        ((ISSUES++))
    fi
done

# 5. Verificar dependencias
echo ""
echo "🔍 Verificando dependencias..."
if [ -f "pubspec.lock" ]; then
    echo "  ✅ pubspec.lock presente"
else
    echo "  ⚠️  pubspec.lock no encontrado (ejecuta: flutter pub get)"
fi

# 6. Verificar tests
echo ""
echo "🔍 Verificando tests..."
TEST_COUNT=$(find test -name "*_test.dart" 2>/dev/null | wc -l)
if [ "$TEST_COUNT" -gt 0 ]; then
    echo "  ✅ $TEST_COUNT archivos de test encontrados"
else
    echo "  ⚠️  No se encontraron tests"
fi

# 7. Análisis estático rápido
echo ""
echo "🔍 Ejecutando análisis rápido..."
if flutter analyze 2>&1 | grep -q "No issues found"; then
    echo "  ✅ Sin problemas de análisis"
else
    echo "  ⚠️  Se encontraron warnings (ejecuta: flutter analyze)"
fi

# 8. Verificar configuración Android
echo ""
echo "🔍 Verificando configuración Android..."
if [ -f "android/app/build.gradle" ] && grep -q "compileSdk 34" android/app/build.gradle; then
    echo "  ✅ Configuración Android actualizada"
else
    echo "  ⚠️  Revisar configuración de Android"
fi

# Resumen final
echo ""
echo "======================================"
if [ $ISSUES -eq 0 ]; then
    echo "✅ PROYECTO SALUDABLE - Todo OK"
else
    echo "⚠️  ATENCIÓN: $ISSUES problemas encontrados"
fi
echo "======================================"

exit $ISSUES
