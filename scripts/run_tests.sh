#!/bin/bash
# Script rápido de testing con reporte

set -e

echo "🧪 Ejecutando suite de tests..."
echo ""

# Ejecutar tests con cobertura
flutter test --coverage --reporter expanded

# Verificar si existe lcov
if command -v lcov &> /dev/null; then
    echo ""
    echo "📊 Generando reporte de cobertura..."
    
    # Generar reporte HTML
    genhtml coverage/lcov.info -o coverage/html
    
    echo "✅ Reporte de cobertura generado en: coverage/html/index.html"
else
    echo "⚠️  lcov no instalado. Para instalar: sudo apt-get install lcov"
fi

# Contar tests
TOTAL_TESTS=$(grep -c "test(" test/*.dart 2>/dev/null || echo "0")
echo ""
echo "📈 Total de tests: $TOTAL_TESTS"
echo "✅ Suite de tests completada"
