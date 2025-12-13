#!/bin/bash

# Build script para Tokyo Roulette Predicciones
# Este script automatiza el proceso de build del APK

set -e

echo "🎰 Tokyo Roulette Predicciones - Build Script"
echo "=============================================="
echo ""

# Verificar que Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter no está instalado o no está en el PATH"
    echo "Por favor instala Flutter desde: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -n 1)"
echo ""

# Verificar estado de Flutter
echo "📋 Verificando instalación de Flutter..."
flutter doctor -v
echo ""

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
flutter clean
echo ""

# Obtener dependencias
echo "📦 Instalando dependencias..."
flutter pub get
echo ""

# Analizar código
echo "🔍 Analizando código..."
flutter analyze
if [ $? -ne 0 ]; then
    echo "⚠️  Advertencia: Se encontraron problemas en el análisis de código"
    read -p "¿Continuar de todos modos? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        exit 1
    fi
fi
echo ""

# Ejecutar tests
echo "🧪 Ejecutando tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "⚠️  Advertencia: Algunos tests fallaron"
    read -p "¿Continuar de todos modos? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[SsYy]$ ]]; then
        exit 1
    fi
fi
echo ""

# Build APK
echo "🔨 Construyendo APK de producción..."
flutter build apk --release
echo ""

# Verificar que el APK fue creado
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "✅ ¡Build exitoso!"
    echo ""
    echo "📱 APK generado en:"
    echo "   $APK_PATH"
    echo "   Tamaño: $APK_SIZE"
    echo ""
    echo "🎉 ¡Listo! Ahora puedes instalar el APK en tu dispositivo Android"
    echo ""
    echo "Para instalar:"
    echo "  1. Copia el APK a tu dispositivo Android"
    echo "  2. Abre el archivo en tu dispositivo"
    echo "  3. Permite instalación de fuentes desconocidas si es necesario"
    echo "  4. ¡Instala y disfruta!"
else
    echo "❌ Error: No se pudo generar el APK"
    exit 1
fi
