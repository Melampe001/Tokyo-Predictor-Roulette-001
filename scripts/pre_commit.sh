#!/bin/bash
# Script de CI/CD simulado para verificar antes de commit/push

echo "🔄 Verificación Pre-Commit/CI"
echo "======================================"
echo ""

EXIT_CODE=0

# 1. Verificar formato
echo "📝 Verificando formato de código..."
if flutter format --set-exit-if-changed .; then
    echo "  ✅ Código formateado correctamente"
else
    echo "  ⚠️  Código necesita formato (ejecuta: flutter format .)"
    EXIT_CODE=1
fi

# 2. Análisis estático
echo ""
echo "🔍 Análisis estático..."
if flutter analyze --fatal-infos; then
    echo "  ✅ Sin problemas de análisis"
else
    echo "  ❌ Problemas de análisis encontrados"
    EXIT_CODE=1
fi

# 3. Tests
echo ""
echo "🧪 Ejecutando tests..."
if flutter test; then
    echo "  ✅ Todos los tests pasaron"
else
    echo "  ❌ Tests fallaron"
    EXIT_CODE=1
fi

# 4. Verificar TODOs críticos
echo ""
echo "🔍 Buscando TODOs críticos..."
TODO_COUNT=$(grep -r "TODO:" lib/ test/ | grep -v ".g.dart" | wc -l)
if [ "$TODO_COUNT" -gt 0 ]; then
    echo "  ⚠️  $TODO_COUNT TODOs encontrados"
    grep -r "TODO:" lib/ test/ | grep -v ".g.dart" | head -5
fi

# 5. Verificar que no hay prints en producción
echo ""
echo "🔍 Verificando prints en código..."
PRINT_COUNT=$(grep -r "print(" lib/ | grep -v ".g.dart" | grep -v "// print" | wc -l)
if [ "$PRINT_COUNT" -gt 5 ]; then
    echo "  ⚠️  $PRINT_COUNT statements print() encontrados (considera usar logging)"
fi

# Resumen
echo ""
echo "======================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ LISTO PARA COMMIT/PUSH"
else
    echo "❌ CORRIGE LOS PROBLEMAS ANTES DE COMMIT"
fi
echo "======================================"

exit $EXIT_CODE
