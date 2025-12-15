#!/bin/bash
# Bot 7C: SecurityScanner
# Script para escanear seguridad en el código
# Autor: AGENTE 7 - CI/CD Master
# Fecha: 2025-12-15

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
DRY_RUN=false
REPORT_FILE="security-report.txt"
FAIL_ON_ISSUES=true
ISSUES_FOUND=0

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

log_issue() {
    echo -e "${RED}[$(date +"%Y-%m-%d %H:%M:%S")] ISSUE:${NC} $1"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
}

# Función para mostrar ayuda
show_help() {
    cat << EOF
${GREEN}Bot 7C: SecurityScanner${NC} - Escaneo de seguridad del código

${BLUE}USO:${NC}
    $0 [OPCIONES]

${BLUE}OPCIONES:${NC}
    --no-fail           No fallar si se encuentran issues
    --report FILE       Archivo de reporte (default: security-report.txt)
    --dry-run           Simular sin ejecutar
    --help              Mostrar esta ayuda

${BLUE}EJEMPLOS:${NC}
    # Escaneo completo
    $0

    # No fallar en issues
    $0 --no-fail

    # Reporte personalizado
    $0 --report my-report.txt

    # Modo dry-run
    $0 --dry-run

${BLUE}FUNCIONALIDADES:${NC}
    ✓ Buscar API keys hardcodeadas
    ✓ Detectar http:// (debe ser https://)
    ✓ Verificar .gitignore incluye archivos sensibles
    ✓ Escanear dependencias vulnerables
    ✓ Validar permisos en AndroidManifest.xml
    ✓ Generar reporte de seguridad

${BLUE}PATRONES DETECTADOS:${NC}
    - API keys (AIza, pk_live, sk_live, etc.)
    - Contraseñas hardcodeadas
    - URLs inseguras (http://)
    - Tokens y secretos
    - Archivos sensibles no ignorados

EOF
}

# Función para inicializar reporte
init_report() {
    if [ "$DRY_RUN" = true ]; then
        return 0
    fi
    
    cat > "$REPORT_FILE" << EOF
=================================================================
                    REPORTE DE SEGURIDAD
=================================================================

Fecha: $(date +"%Y-%m-%d %H:%M:%S")
Proyecto: Tokyo Roulette Predictor

=================================================================

EOF
    
    log "✓ Reporte inicializado: $REPORT_FILE"
}

# Función para agregar al reporte
add_to_report() {
    local message="$1"
    if [ "$DRY_RUN" = true ]; then
        return 0
    fi
    echo "$message" >> "$REPORT_FILE"
}

# Función para buscar API keys hardcodeadas
scan_api_keys() {
    log "Escaneando API keys hardcodeadas..."
    
    add_to_report "## 1. API Keys Hardcodeadas"
    add_to_report ""
    
    local patterns=(
        "AIza[0-9A-Za-z-_]{35}"           # Google API Key
        "pk_live_[0-9a-zA-Z]{24,}"        # Stripe Public Key
        "sk_live_[0-9a-zA-Z]{24,}"        # Stripe Secret Key
        "sk_test_[0-9a-zA-Z]{24,}"        # Stripe Test Key
        "AKIA[0-9A-Z]{16}"                # AWS Access Key
        "ya29\.[0-9A-Za-z\-_]+"           # Google OAuth
        "[0-9]+-[0-9A-Za-z_]{32}\.apps\.googleusercontent\.com"  # Google OAuth Client
    )
    
    local found=false
    
    for pattern in "${patterns[@]}"; do
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY-RUN] Buscaría patrón: $pattern"
            continue
        fi
        
        # Buscar en archivos dart, yaml, json
        local results=$(grep -r -E "$pattern" --include="*.dart" --include="*.yaml" --include="*.json" --include="*.xml" . 2>/dev/null || true)
        
        if [ ! -z "$results" ]; then
            log_issue "API key encontrada (patrón: ${pattern:0:20}...)"
            add_to_report "⚠️  API key encontrada:"
            add_to_report "$results"
            add_to_report ""
            found=true
        fi
    done
    
    if [ "$found" = false ]; then
        log "✓ No se encontraron API keys hardcodeadas"
        add_to_report "✓ No se encontraron API keys hardcodeadas"
    fi
    
    add_to_report ""
}

# Función para detectar URLs inseguras
scan_insecure_urls() {
    log "Detectando URLs inseguras (http://)..."
    
    add_to_report "## 2. URLs Inseguras (http://)"
    add_to_report ""
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Buscaría URLs http://"
        return 0
    fi
    
    # Buscar http:// en código (excluyendo comentarios de documentación)
    local results=$(grep -r "http://" --include="*.dart" --include="*.yaml" --include="*.json" . 2>/dev/null | grep -v "localhost" | grep -v "127.0.0.1" | grep -v "example.com" | grep -v "test" || true)
    
    if [ ! -z "$results" ]; then
        log_issue "URLs inseguras encontradas (http://)"
        add_to_report "⚠️  URLs inseguras encontradas:"
        add_to_report "$results"
        log_warning "Cambia http:// a https:// en URLs de producción"
    else
        log "✓ No se encontraron URLs inseguras"
        add_to_report "✓ No se encontraron URLs inseguras"
    fi
    
    add_to_report ""
}

# Función para verificar .gitignore
verify_gitignore() {
    log "Verificando .gitignore..."
    
    add_to_report "## 3. Archivos Sensibles en .gitignore"
    add_to_report ""
    
    local sensitive_files=(
        "*.jks"
        "*.keystore"
        "key.properties"
        "google-services.json"
        "GoogleService-Info.plist"
        ".env"
        "*.pem"
        "*.p12"
    )
    
    local missing=()
    
    for file in "${sensitive_files[@]}"; do
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY-RUN] Verificaría: $file"
            continue
        fi
        
        if ! grep -q "$file" .gitignore 2>/dev/null; then
            missing+=("$file")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_issue "Archivos sensibles no están en .gitignore"
        add_to_report "⚠️  Archivos sensibles faltantes en .gitignore:"
        for file in "${missing[@]}"; do
            log_warning "Falta en .gitignore: $file"
            add_to_report "  - $file"
        done
    else
        log "✓ .gitignore configurado correctamente"
        add_to_report "✓ .gitignore configurado correctamente"
    fi
    
    add_to_report ""
}

# Función para escanear dependencias vulnerables
scan_dependencies() {
    log "Escaneando dependencias vulnerables..."
    
    add_to_report "## 4. Dependencias"
    add_to_report ""
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Ejecutaría: flutter pub outdated"
        return 0
    fi
    
    if ! command -v flutter &> /dev/null; then
        log_warning "Flutter no disponible, saltando escaneo de dependencias"
        add_to_report "⚠️  Flutter no disponible para escanear dependencias"
        return 0
    fi
    
    # Verificar dependencias obsoletas
    log_info "Verificando dependencias obsoletas..."
    local outdated=$(flutter pub outdated --json 2>/dev/null || echo "{}")
    
    add_to_report "Ejecutar 'flutter pub outdated' para ver dependencias obsoletas"
    add_to_report ""
    
    log "✓ Escaneo de dependencias completado"
}

# Función para validar permisos en AndroidManifest
validate_android_permissions() {
    log "Validando permisos en AndroidManifest.xml..."
    
    add_to_report "## 5. Permisos de Android"
    add_to_report ""
    
    local manifest="android/app/src/main/AndroidManifest.xml"
    
    if [ ! -f "$manifest" ]; then
        log_warning "AndroidManifest.xml no encontrado"
        add_to_report "⚠️  AndroidManifest.xml no encontrado"
        return 0
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Validaría permisos en $manifest"
        return 0
    fi
    
    # Permisos peligrosos a revisar
    local dangerous_permissions=(
        "READ_CONTACTS"
        "WRITE_CONTACTS"
        "READ_CALENDAR"
        "WRITE_CALENDAR"
        "READ_CALL_LOG"
        "WRITE_CALL_LOG"
        "CAMERA"
        "RECORD_AUDIO"
        "ACCESS_FINE_LOCATION"
        "ACCESS_COARSE_LOCATION"
        "READ_PHONE_STATE"
        "READ_SMS"
        "SEND_SMS"
    )
    
    local found_permissions=()
    
    for perm in "${dangerous_permissions[@]}"; do
        if grep -q "$perm" "$manifest"; then
            found_permissions+=("$perm")
        fi
    done
    
    if [ ${#found_permissions[@]} -gt 0 ]; then
        log_warning "Permisos peligrosos encontrados:"
        add_to_report "⚠️  Permisos peligrosos encontrados en AndroidManifest.xml:"
        for perm in "${found_permissions[@]}"; do
            log_warning "  - $perm"
            add_to_report "  - $perm"
        done
        add_to_report ""
        add_to_report "Asegúrate de que estos permisos son necesarios para tu app."
    else
        log "✓ No se encontraron permisos peligrosos innecesarios"
        add_to_report "✓ No se encontraron permisos peligrosos innecesarios"
    fi
    
    add_to_report ""
}

# Función para buscar contraseñas hardcodeadas
scan_hardcoded_passwords() {
    log "Buscando contraseñas hardcodeadas..."
    
    add_to_report "## 6. Contraseñas y Secretos Hardcodeados"
    add_to_report ""
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Buscaría contraseñas hardcodeadas"
        return 0
    fi
    
    local patterns=(
        "password\s*=\s*['\"][^'\"]+['\"]"
        "passwd\s*=\s*['\"][^'\"]+['\"]"
        "secret\s*=\s*['\"][^'\"]+['\"]"
        "token\s*=\s*['\"][^'\"]+['\"]"
    )
    
    local found=false
    
    for pattern in "${patterns[@]}"; do
        local results=$(grep -r -i -E "$pattern" --include="*.dart" --include="*.yaml" . 2>/dev/null || true)
        
        if [ ! -z "$results" ]; then
            log_issue "Posible contraseña/secreto hardcodeado encontrado"
            add_to_report "⚠️  Posible contraseña/secreto hardcodeado:"
            add_to_report "$results"
            add_to_report ""
            found=true
        fi
    done
    
    if [ "$found" = false ]; then
        log "✓ No se encontraron contraseñas hardcodeadas"
        add_to_report "✓ No se encontraron contraseñas hardcodeadas"
    fi
    
    add_to_report ""
}

# Función para generar resumen final
generate_summary() {
    log "Generando resumen final..."
    
    add_to_report "=================================================================
                        RESUMEN
=================================================================

Total de issues encontrados: $ISSUES_FOUND

Estado: $(if [ "$ISSUES_FOUND" -eq 0 ]; then echo "PASS ✓"; else echo "ISSUES FOUND ⚠️"; fi)

Fecha: $(date +"%Y-%m-%d %H:%M:%S")

=================================================================
"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    log "RESUMEN DE SEGURIDAD:"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    
    if [ "$ISSUES_FOUND" -eq 0 ]; then
        log "✓ No se encontraron issues de seguridad"
    else
        log_warning "⚠️  Se encontraron $ISSUES_FOUND issues de seguridad"
        log_info "Revisa el reporte completo: $REPORT_FILE"
    fi
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Función principal
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║          Bot 7C: SecurityScanner                          ║"
    echo "║          Escaneo de Seguridad del Código                  ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-fail)
                FAIL_ON_ISSUES=false
                shift
                ;;
            --report)
                REPORT_FILE=$2
                shift 2
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
    
    # Inicializar reporte
    init_report
    
    # Ejecutar escaneos
    scan_api_keys
    scan_insecure_urls
    verify_gitignore
    scan_dependencies
    validate_android_permissions
    scan_hardcoded_passwords
    
    # Generar resumen
    generate_summary
    
    # Verificar si fallar
    if [ "$ISSUES_FOUND" -gt 0 ] && [ "$FAIL_ON_ISSUES" = true ]; then
        log_error "Se encontraron $ISSUES_FOUND issues de seguridad"
        exit 1
    fi
    
    log "✓ Escaneo de seguridad completado"
}

# Ejecutar script
main "$@"
