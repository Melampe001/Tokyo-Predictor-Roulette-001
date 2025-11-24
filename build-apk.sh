#!/bin/bash

################################################################################
# Script: build-apk.sh
# Descripción: Script automatizado para construir el APK release de 
#              Tokyo Roulette Predicciones
# Uso: ./build-apk.sh
################################################################################

set -e  # Salir si algún comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con formato
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Banner
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     Tokyo Roulette Predicciones - APK Build Script            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar que Flutter está instalado
print_step "Verificando instalación de Flutter..."
if ! command -v flutter &> /dev/null
then
    print_error "Flutter no está instalado o no está en el PATH"
    echo "Por favor, instala Flutter desde: https://flutter.dev/docs/get-started/install"
    exit 1
fi
print_success "Flutter encontrado: $(flutter --version | head -n 1)"
echo ""

# Verificar versión de Flutter
print_step "Verificando versión de Flutter..."
flutter --version
echo ""

# Mostrar información del doctor (opcional, comentar si toma mucho tiempo)
# print_step "Ejecutando Flutter Doctor..."
# flutter doctor
# echo ""

# Limpiar builds anteriores
print_step "Limpiando builds anteriores..."
flutter clean
print_success "Limpieza completada"
echo ""

# Obtener dependencias
print_step "Obteniendo dependencias del proyecto..."
flutter pub get
print_success "Dependencias instaladas"
echo ""

# Ejecutar análisis de código
print_step "Analizando código Dart..."
flutter analyze
if [ $? -eq 0 ]; then
    print_success "Análisis de código completado sin errores"
else
    print_warning "Se encontraron advertencias durante el análisis"
fi
echo ""

# Ejecutar pruebas (comentar si no hay pruebas o quieres saltar este paso)
print_step "Ejecutando pruebas..."
if flutter test; then
    print_success "Todas las pruebas pasaron"
else
    print_warning "Algunas pruebas fallaron. Considera revisarlas antes de continuar."
    read -p "¿Deseas continuar con el build? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]
    then
        print_error "Build cancelado por el usuario"
        exit 1
    fi
fi
echo ""

# Preguntar por el tipo de build
echo "Selecciona el tipo de build:"
echo "  1) APK Universal (recomendado para pruebas)"
echo "  2) APK por arquitectura (recomendado para distribución)"
echo "  3) APK con ofuscación (recomendado para producción)"
read -p "Opción [1-3, default: 1]: " build_option
build_option=${build_option:-1}

# Construir el APK según la opción seleccionada
case $build_option in
    1)
        print_step "Construyendo APK Universal release..."
        flutter build apk --release
        ;;
    2)
        print_step "Construyendo APK por arquitectura..."
        flutter build apk --release --split-per-abi
        ;;
    3)
        print_step "Construyendo APK con ofuscación..."
        flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
        ;;
    *)
        print_error "Opción inválida"
        exit 1
        ;;
esac

# Verificar que el build fue exitoso
if [ $? -eq 0 ]; then
    print_success "¡Build completado exitosamente!"
    echo ""
    
    # Mostrar información sobre los APKs generados
    print_step "APKs generados:"
    echo ""
    
    # Buscar y listar todos los APKs generados
    apk_dir="build/app/outputs/flutter-apk"
    if [ -d "$apk_dir" ]; then
        find "$apk_dir" -name "*.apk" -exec ls -lh {} \; | while read -r line; do
            size=$(echo "$line" | awk '{print $5}')
            file=$(echo "$line" | awk '{print $NF}')
            filename=$(basename "$file")
            echo -e "  ${GREEN}✓${NC} $filename (${YELLOW}$size${NC})"
        done
    else
        print_error "No se encontró el directorio de APKs"
    fi
    
    echo ""
    print_step "Ubicación de los APKs:"
    echo "  $apk_dir/"
    echo ""
    
    # Mostrar instrucciones de instalación
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║  Próximos pasos:                                               ║"
    echo "╠════════════════════════════════════════════════════════════════╣"
    echo "║  1. Los APKs se encuentran en build/app/outputs/flutter-apk/  ║"
    echo "║  2. Para instalar en un dispositivo:                           ║"
    echo "║     adb install build/app/outputs/flutter-apk/app-release.apk ║"
    echo "║  3. Para distribución, considera firmar el APK                 ║"
    echo "║     (ver BUILD.md para más detalles)                           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    
else
    print_error "El build falló. Por favor revisa los errores anteriores."
    exit 1
fi

echo ""
print_success "Script completado"
