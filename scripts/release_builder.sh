#!/bin/bash
# Bot 5A: ReleaseBuilder
# Script que construye APKs/AABs de release con signing automático
# Autor: AGENTE 5 - Release Master
# Fecha: 2025-12-15

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DRY_RUN=false
BUILD_APK=false
BUILD_AAB=false
VERIFY_ONLY=false
PROJECT_ROOT=$(pwd)

# Función para logging con timestamp
log() {
    echo -e "${GREEN}[$(date +"%Y-%m-%d %H:%M:%S")]${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +"%Y-%m-%d %H:%M:%S")] ERROR:${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +"%Y-%m-%d %H:%M:%S")] WARNING:${NC} $1"
}

log_info() {
    echo -e "${BLUE}[$(date +"%Y-%m-%d %H:%M:%S")] INFO:${NC} $1"
}

# Función para mostrar ayuda
show_help() {
    cat << EOF
${GREEN}Bot 5A: ReleaseBuilder${NC} - Sistema de builds de producción y signing

${BLUE}USO:${NC}
    $0 [OPCIONES]

${BLUE}OPCIONES:${NC}
    --apk               Build APK release firmado
    --aab               Build AAB (Android App Bundle) firmado
    --all               Build tanto APK como AAB
    --verify            Solo verificar signing de builds existentes
    --dry-run           Simular sin ejecutar
    --help              Mostrar esta ayuda

${BLUE}EJEMPLOS:${NC}
    # Build APK release
    $0 --apk

    # Build AAB release
    $0 --aab

    # Build ambos
    $0 --all

    # Verificar signing
    $0 --verify

    # Modo dry-run
    $0 --apk --dry-run

${BLUE}REQUISITOS:${NC}
    - Flutter instalado y configurado
    - Keystore configurado en android/key.properties
    - Java JDK instalado (para jarsigner)

${BLUE}ARCHIVOS GENERADOS:${NC}
    - build/app/outputs/flutter-apk/app-release.apk
    - build/app/outputs/bundle/release/app-release.aab
    - build/app/outputs/checksums.txt (SHA-256)

EOF
}

# Función para validar dependencias
check_dependencies() {
    log "Validando dependencias..."
    
    local missing_deps=()
    
    if ! command -v flutter &> /dev/null; then
        missing_deps+=("flutter")
    fi
    
    if ! command -v keytool &> /dev/null; then
        missing_deps+=("keytool (Java JDK)")
    fi
    
    if ! command -v jarsigner &> /dev/null; then
        missing_deps+=("jarsigner (Java JDK)")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Dependencias faltantes: ${missing_deps[*]}"
        log_error "Por favor instala las dependencias necesarias"
        exit 1
    fi
    
    log "✓ Todas las dependencias instaladas"
}

# Función para validar keystore
validate_keystore() {
    log "Validando keystore..."
    
    local key_properties="android/key.properties"
    
    if [ ! -f "$key_properties" ]; then
        log_error "No se encontró android/key.properties"
        log_error "Ejecuta: ./scripts/keystore_manager.sh --generate"
        exit 1
    fi
    
    # Leer propiedades del keystore
    if grep -q "storeFile=" "$key_properties"; then
        log "✓ Configuración de keystore encontrada"
    else
        log_error "Configuración de keystore incompleta en $key_properties"
        exit 1
    fi
}

# Función para build APK release
build_apk() {
    log "Construyendo APK release..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Ejecutaría: flutter build apk --release"
        return 0
    fi
    
    flutter clean
    flutter pub get
    flutter build apk --release
    
    local apk_path="build/app/outputs/flutter-apk/app-release.apk"
    
    if [ -f "$apk_path" ]; then
        local size=$(ls -lh "$apk_path" | awk '{print $5}')
        log "✓ APK generado exitosamente: $apk_path ($size)"
        
        # Generar checksum
        generate_checksum "$apk_path"
    else
        log_error "No se pudo generar el APK"
        exit 1
    fi
}

# Función para build AAB release
build_aab() {
    log "Construyendo AAB (Android App Bundle)..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Ejecutaría: flutter build appbundle --release"
        return 0
    fi
    
    flutter clean
    flutter pub get
    flutter build appbundle --release
    
    local aab_path="build/app/outputs/bundle/release/app-release.aab"
    
    if [ -f "$aab_path" ]; then
        local size=$(ls -lh "$aab_path" | awk '{print $5}')
        log "✓ AAB generado exitosamente: $aab_path ($size)"
        
        # Generar checksum
        generate_checksum "$aab_path"
    else
        log_error "No se pudo generar el AAB"
        exit 1
    fi
}

# Función para generar checksums
generate_checksum() {
    local file_path=$1
    log "Generando checksum SHA-256 para $file_path..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Generaría checksum para $file_path"
        return 0
    fi
    
    local checksum_file="build/app/outputs/checksums.txt"
    local checksum=$(sha256sum "$file_path" | awk '{print $1}')
    
    echo "$(date) - $file_path: $checksum" >> "$checksum_file"
    log "✓ Checksum: $checksum"
}

# Función para verificar signing
verify_signing() {
    log "Verificando signing de builds..."
    
    local apk_path="build/app/outputs/flutter-apk/app-release.apk"
    local aab_path="build/app/outputs/bundle/release/app-release.aab"
    
    local verified=false
    
    # Verificar APK
    if [ -f "$apk_path" ]; then
        log_info "Verificando APK: $apk_path"
        
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY-RUN] Verificaría signing de APK"
        else
            if jarsigner -verify -verbose -certs "$apk_path" &> /dev/null; then
                log "✓ APK firmado correctamente"
                verified=true
            else
                log_error "APK no está firmado o la firma es inválida"
            fi
        fi
    fi
    
    # Verificar AAB
    if [ -f "$aab_path" ]; then
        log_info "Verificando AAB: $aab_path"
        
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY-RUN] Verificaría signing de AAB"
        else
            if jarsigner -verify -verbose -certs "$aab_path" &> /dev/null; then
                log "✓ AAB firmado correctamente"
                verified=true
            else
                log_error "AAB no está firmado o la firma es inválida"
            fi
        fi
    fi
    
    if [ "$verified" = false ] && [ "$DRY_RUN" = false ]; then
        log_error "No se encontraron builds para verificar"
        exit 1
    fi
}

# Función principal
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║          Bot 5A: ReleaseBuilder                           ║"
    echo "║          Sistema de Builds de Producción                  ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Si no hay argumentos, mostrar ayuda
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --apk)
                BUILD_APK=true
                shift
                ;;
            --aab)
                BUILD_AAB=true
                shift
                ;;
            --all)
                BUILD_APK=true
                BUILD_AAB=true
                shift
                ;;
            --verify)
                VERIFY_ONLY=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                log_warning "Modo DRY-RUN activado - No se ejecutarán cambios reales"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Validar dependencias
    check_dependencies
    
    # Si solo es verificación
    if [ "$VERIFY_ONLY" = true ]; then
        verify_signing
        exit 0
    fi
    
    # Validar keystore antes de build
    validate_keystore
    
    # Ejecutar builds
    if [ "$BUILD_APK" = true ]; then
        build_apk
    fi
    
    if [ "$BUILD_AAB" = true ]; then
        build_aab
    fi
    
    # Verificar signing después de build
    if [ "$BUILD_APK" = true ] || [ "$BUILD_AAB" = true ]; then
        verify_signing
    fi
    
    log "✓ Proceso completado exitosamente"
    
    # Mostrar resumen
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    log "RESUMEN DE BUILDS:"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    
    if [ "$BUILD_APK" = true ]; then
        log_info "APK: build/app/outputs/flutter-apk/app-release.apk"
    fi
    
    if [ "$BUILD_AAB" = true ]; then
        log_info "AAB: build/app/outputs/bundle/release/app-release.aab"
    fi
    
    if [ -f "build/app/outputs/checksums.txt" ]; then
        log_info "Checksums: build/app/outputs/checksums.txt"
    fi
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
}

# Ejecutar script
main "$@"
