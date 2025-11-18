#!/bin/bash
# Script para ejecutar solo el workflow de Build

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="/home/runner/work/Tokyo-Predictor-Roulette-001/Tokyo-Predictor-Roulette-001"
cd "$REPO_DIR"

echo "🔨 Ejecutando Workflow: Build"
echo "============================="
echo ""

# 1. Verificar Flutter
echo "1/4: Verificando instalación de Flutter..."
flutter doctor -v || true

echo ""

# 2. Clean
echo "2/4: Limpiando build anterior..."
flutter clean
echo -e "${GREEN}✓ Limpieza completada${NC}"

echo ""

# 3. Dependencias
echo "3/4: Instalando dependencias..."
if flutter pub get; then
    echo -e "${GREEN}✓ Dependencias instaladas${NC}"
else
    echo -e "${RED}✗ Error al instalar dependencias${NC}"
    exit 1
fi

echo ""

# 4. Build Android
echo "4/4: Compilando APK de Android (debug)..."
echo "  Nota: Esto puede tardar varios minutos..."
if flutter build apk --debug; then
    echo -e "${GREEN}✓ Build de Android completado${NC}"
    
    if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
        SIZE=$(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)
        echo "  APK generado: $SIZE"
        echo "  Ubicación: build/app/outputs/flutter-apk/app-debug.apk"
    fi
else
    echo -e "${RED}✗ Build de Android falló${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Workflow Build completado exitosamente${NC}"
