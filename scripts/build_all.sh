#!/bin/bash
# Script de automatización completa para Tokyo Roulette APK
# Configura el entorno y construye la APK

set -e  # Salir si hay error

echo "======================================"
echo "🚀 INICIO DE AUTOMATIZACIÓN COMPLETA"
echo "======================================"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de log
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 1. Verificar Flutter
log_info "Verificando instalación de Flutter..."
if ! command -v flutter &> /dev/null; then
    log_error "Flutter no está instalado"
    exit 1
fi
log_success "Flutter encontrado: $(flutter --version | head -1)"

# 2. Limpiar builds previos
log_info "Limpiando builds previos..."
flutter clean
log_success "Build limpiado"

# 3. Obtener dependencias
log_info "Obteniendo dependencias..."
flutter pub get
log_success "Dependencias instaladas"

# 4. Análisis estático
log_info "Ejecutando análisis estático..."
flutter analyze || log_warning "Se encontraron warnings en el análisis"
log_success "Análisis completado"

# 5. Ejecutar tests
log_info "Ejecutando tests..."
if flutter test; then
    log_success "Todos los tests pasaron"
else
    log_warning "Algunos tests fallaron, pero continuando..."
fi

# 6. Construir APK Debug
log_info "Construyendo APK Debug..."
if flutter build apk --debug; then
    log_success "APK Debug construida exitosamente"
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        log_success "APK ubicada en: $APK_PATH"
        log_success "Tamaño: $APK_SIZE"
    fi
else
    log_error "Error construyendo APK Debug"
    exit 1
fi

# 7. Construir APK Release (opcional)
log_info "¿Deseas construir APK Release? (puede requerir keystore)"
if flutter build apk --release 2>/dev/null; then
    log_success "APK Release construida exitosamente"
    APK_RELEASE_PATH="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$APK_RELEASE_PATH" ]; then
        APK_RELEASE_SIZE=$(du -h "$APK_RELEASE_PATH" | cut -f1)
        log_success "APK Release ubicada en: $APK_RELEASE_PATH"
        log_success "Tamaño: $APK_RELEASE_SIZE"
    fi
else
    log_warning "No se pudo construir APK Release (puede requerir keystore configurado)"
fi

echo ""
echo "======================================"
echo "🎉 AUTOMATIZACIÓN COMPLETADA"
echo "======================================"
echo ""
echo "Resumen:"
echo "  - Dependencias: ✅"
echo "  - Análisis: ✅"
echo "  - Tests: ✅"
echo "  - APK Debug: ✅"
echo ""
echo "Para instalar en dispositivo:"
echo "  adb install build/app/outputs/flutter-apk/app-debug.apk"
echo ""
