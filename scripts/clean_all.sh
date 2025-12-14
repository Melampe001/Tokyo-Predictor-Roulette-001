#!/bin/bash
# Script de limpieza y reset completo del proyecto

echo "🧹 Iniciando limpieza profunda del proyecto..."
echo ""

# 1. Flutter clean
echo "🗑️  Limpiando builds de Flutter..."
flutter clean

# 2. Eliminar archivos generados
echo "🗑️  Eliminando archivos generados..."
find . -name "*.g.dart" -type f -delete
find . -name "*.freezed.dart" -type f -delete

# 3. Limpiar caché de pub
echo "🗑️  Limpiando caché de pub..."
flutter pub cache clean

# 4. Reinstalar dependencias
echo "📦 Reinstalando dependencias..."
flutter pub get

# 5. Limpiar Android
if [ -d "android" ]; then
    echo "🗑️  Limpiando build de Android..."
    cd android
    if [ -d "build" ]; then
        rm -rf build
    fi
    if [ -d ".gradle" ]; then
        rm -rf .gradle
    fi
    if [ -d "app/build" ]; then
        rm -rf app/build
    fi
    cd ..
fi

# 6. Limpiar Linux
if [ -d "linux/build" ]; then
    echo "🗑️  Limpiando build de Linux..."
    rm -rf linux/build
fi

# 7. Limpiar coverage
if [ -d "coverage" ]; then
    echo "🗑️  Limpiando reportes de cobertura..."
    rm -rf coverage
fi

echo ""
echo "✅ Limpieza completada"
echo ""
echo "El proyecto está listo para un build limpio."
echo "Ejecuta: ./scripts/build_all.sh"
