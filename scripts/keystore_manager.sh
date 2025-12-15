#!/bin/bash
# Bot 5B: KeystoreManager
# Script para gestionar keystores de forma segura
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
DRY_RUN=false
GENERATE_KEYSTORE=false
VALIDATE_KEYSTORE=false
CREATE_KEY_PROPERTIES=false
BACKUP_KEYSTORE=false
CHECK_GRADLE=false
SHOW_GITHUB_INSTRUCTIONS=false
KEYSTORE_PATH="$HOME/upload-keystore.jks"
KEY_ALIAS="upload"

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
${GREEN}Bot 5B: KeystoreManager${NC} - Gestión segura de keystores

${BLUE}USO:${NC}
    $0 [OPCIONES]

${BLUE}OPCIONES:${NC}
    --generate          Generar nuevo keystore con parámetros seguros
    --validate          Validar keystore existente
    --create-properties Crear android/key.properties automáticamente
    --backup            Crear backup del keystore
    --check-gradle      Verificar configuración de signing en gradle
    --github-secrets    Mostrar instrucciones para GitHub Secrets
    --dry-run           Simular sin ejecutar
    --help              Mostrar esta ayuda

${BLUE}EJEMPLOS:${NC}
    # Generar nuevo keystore
    $0 --generate

    # Validar keystore existente
    $0 --validate

    # Crear key.properties
    $0 --create-properties

    # Backup del keystore
    $0 --backup

    # Verificar configuración de gradle
    $0 --check-gradle

    # Ver instrucciones para GitHub Secrets
    $0 --github-secrets

${BLUE}KEYSTORE PREDETERMINADO:${NC}
    Path: $KEYSTORE_PATH
    Alias: $KEY_ALIAS
    Algoritmo: RSA 2048 bits
    Validez: 10000 días (~27 años)

${BLUE}ARCHIVOS GENERADOS:${NC}
    - ~/upload-keystore.jks (keystore)
    - android/key.properties (configuración)
    - ~/keystore-backup-YYYYMMDD.jks (backup)

${BLUE}SEGURIDAD:${NC}
    ⚠️  NUNCA commitees el keystore o key.properties al repositorio
    ⚠️  Guarda el keystore en un lugar seguro
    ⚠️  Usa GitHub Secrets para CI/CD

EOF
}

# Función para validar dependencias
check_dependencies() {
    log "Validando dependencias..."
    
    if ! command -v keytool &> /dev/null; then
        log_error "keytool no encontrado. Instala Java JDK"
        exit 1
    fi
    
    log "✓ Dependencias instaladas"
}

# Función para generar keystore
generate_keystore() {
    log "Generando nuevo keystore..."
    
    if [ -f "$KEYSTORE_PATH" ]; then
        log_warning "Ya existe un keystore en $KEYSTORE_PATH"
        read -p "¿Deseas sobrescribirlo? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Operación cancelada"
            exit 0
        fi
        rm "$KEYSTORE_PATH"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Generaría keystore en $KEYSTORE_PATH"
        return 0
    fi
    
    log_info "Generando keystore. Se te pedirá información..."
    log_warning "IMPORTANTE: Guarda las contraseñas en un lugar seguro"
    
    keytool -genkey -v -keystore "$KEYSTORE_PATH" \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias "$KEY_ALIAS"
    
    if [ -f "$KEYSTORE_PATH" ]; then
        log "✓ Keystore generado exitosamente: $KEYSTORE_PATH"
        log_warning "⚠️  GUARDA EL KEYSTORE Y LAS CONTRASEÑAS EN UN LUGAR SEGURO"
        log_warning "⚠️  Si pierdes el keystore, no podrás actualizar tu app en Play Store"
    else
        log_error "No se pudo generar el keystore"
        exit 1
    fi
}

# Función para validar keystore
validate_keystore() {
    log "Validando keystore..."
    
    if [ ! -f "$KEYSTORE_PATH" ]; then
        log_error "Keystore no encontrado en $KEYSTORE_PATH"
        log_error "Ejecuta: $0 --generate"
        exit 1
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Validaría keystore en $KEYSTORE_PATH"
        return 0
    fi
    
    log_info "Listando información del keystore..."
    keytool -list -v -keystore "$KEYSTORE_PATH"
    
    log "✓ Keystore válido"
}

# Función para crear key.properties
create_key_properties() {
    log "Creando android/key.properties..."
    
    local key_properties="android/key.properties"
    
    if [ ! -f "$KEYSTORE_PATH" ]; then
        log_error "Primero debes generar un keystore"
        log_error "Ejecuta: $0 --generate"
        exit 1
    fi
    
    if [ -f "$key_properties" ]; then
        log_warning "Ya existe $key_properties"
        read -p "¿Deseas sobrescribirlo? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Operación cancelada"
            exit 0
        fi
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Crearía $key_properties"
        return 0
    fi
    
    # Pedir contraseñas
    echo ""
    read -sp "Ingresa la contraseña del keystore: " store_password
    echo ""
    read -sp "Ingresa la contraseña de la key (Enter si es la misma): " key_password
    echo ""
    
    if [ -z "$key_password" ]; then
        key_password="$store_password"
    fi
    
    # Crear archivo key.properties
    cat > "$key_properties" << EOF
storePassword=$store_password
keyPassword=$key_password
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_PATH
EOF
    
    # Asegurar que no se commitee
    if ! grep -q "key.properties" .gitignore 2>/dev/null; then
        echo "android/key.properties" >> .gitignore
        log_info "Agregado key.properties a .gitignore"
    fi
    
    log "✓ Archivo $key_properties creado"
    log_warning "⚠️  NO COMMITEES ESTE ARCHIVO AL REPOSITORIO"
    log_info "Contenido (censurado):"
    echo ""
    echo "storePassword=***"
    echo "keyPassword=***"
    echo "keyAlias=$KEY_ALIAS"
    echo "storeFile=$KEYSTORE_PATH"
    echo ""
}

# Función para backup del keystore
backup_keystore() {
    log "Creando backup del keystore..."
    
    if [ ! -f "$KEYSTORE_PATH" ]; then
        log_error "Keystore no encontrado en $KEYSTORE_PATH"
        exit 1
    fi
    
    local backup_path="$HOME/keystore-backup-$(date +%Y%m%d).jks"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Crearía backup en $backup_path"
        return 0
    fi
    
    cp "$KEYSTORE_PATH" "$backup_path"
    
    if [ -f "$backup_path" ]; then
        log "✓ Backup creado: $backup_path"
        log_info "Guarda este backup en un lugar seguro (ej: USB, cloud encriptado)"
    else
        log_error "No se pudo crear el backup"
        exit 1
    fi
}

# Función para verificar configuración de gradle
check_gradle_config() {
    log "Verificando configuración de signing en gradle..."
    
    local build_gradle="android/app/build.gradle"
    
    if [ ! -f "$build_gradle" ]; then
        log_error "No se encontró $build_gradle"
        exit 1
    fi
    
    log_info "Verificando $build_gradle..."
    
    # Verificar que existe configuración de signing
    if grep -q "signingConfigs" "$build_gradle"; then
        log "✓ Sección signingConfigs encontrada"
    else
        log_error "No se encontró sección signingConfigs en $build_gradle"
        log_info "Agrega la configuración de signing manualmente"
        exit 1
    fi
    
    # Verificar configuración de release
    if grep -q "release {" "$build_gradle"; then
        log "✓ Build type release encontrado"
    else
        log_warning "No se encontró build type release"
    fi
    
    # Verificar que se lee key.properties
    if grep -q "key.properties" "$build_gradle"; then
        log "✓ Configuración para leer key.properties encontrada"
    else
        log_warning "No se encontró configuración para leer key.properties"
        log_info "Considera agregar código para leer key.properties en build.gradle"
    fi
    
    log "✓ Verificación de gradle completada"
}

# Función para mostrar instrucciones de GitHub Secrets
show_github_instructions() {
    cat << EOF

${GREEN}╔═══════════════════════════════════════════════════════════════════╗
║       Instrucciones para GitHub Secrets                           ║
╚═══════════════════════════════════════════════════════════════════╝${NC}

Para usar tu keystore en GitHub Actions, necesitas configurar estos secretos:

${BLUE}1. Codificar keystore en base64:${NC}
   ${YELLOW}base64 $KEYSTORE_PATH > keystore.base64.txt${NC}

${BLUE}2. Agregar secretos en GitHub:${NC}
   Ve a: Settings → Secrets and variables → Actions → New repository secret

   ${GREEN}Secretos necesarios:${NC}
   - ${YELLOW}KEYSTORE_BASE64${NC}: Contenido de keystore.base64.txt
   - ${YELLOW}KEYSTORE_PASSWORD${NC}: Contraseña del keystore
   - ${YELLOW}KEY_ALIAS${NC}: $KEY_ALIAS
   - ${YELLOW}KEY_PASSWORD${NC}: Contraseña de la key

${BLUE}3. Uso en workflow de GitHub Actions:${NC}

${YELLOW}steps:
  - name: Decode keystore
    run: |
      echo "\${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/keystore.jks
  
  - name: Create key.properties
    run: |
      cat > android/key.properties << EOF
      storePassword=\${{ secrets.KEYSTORE_PASSWORD }}
      keyPassword=\${{ secrets.KEY_PASSWORD }}
      keyAlias=\${{ secrets.KEY_ALIAS }}
      storeFile=keystore.jks
      EOF
  
  - name: Build release
    run: flutter build apk --release${NC}

${RED}⚠️  IMPORTANTE:${NC}
- Nunca commitees el keystore o key.properties al repositorio
- Guarda una copia de seguridad del keystore en un lugar seguro
- Si pierdes el keystore, no podrás actualizar tu app en Play Store

${GREEN}✓ Después de configurar estos secretos, tus workflows podrán hacer builds firmados${NC}

EOF
}

# Función principal
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║          Bot 5B: KeystoreManager                          ║"
    echo "║          Gestión Segura de Keystores                      ║"
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
            --generate)
                GENERATE_KEYSTORE=true
                shift
                ;;
            --validate)
                VALIDATE_KEYSTORE=true
                shift
                ;;
            --create-properties)
                CREATE_KEY_PROPERTIES=true
                shift
                ;;
            --backup)
                BACKUP_KEYSTORE=true
                shift
                ;;
            --check-gradle)
                CHECK_GRADLE=true
                shift
                ;;
            --github-secrets)
                SHOW_GITHUB_INSTRUCTIONS=true
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
    
    # Ejecutar acciones
    if [ "$GENERATE_KEYSTORE" = true ]; then
        generate_keystore
    fi
    
    if [ "$VALIDATE_KEYSTORE" = true ]; then
        validate_keystore
    fi
    
    if [ "$CREATE_KEY_PROPERTIES" = true ]; then
        create_key_properties
    fi
    
    if [ "$BACKUP_KEYSTORE" = true ]; then
        backup_keystore
    fi
    
    if [ "$CHECK_GRADLE" = true ]; then
        check_gradle_config
    fi
    
    if [ "$SHOW_GITHUB_INSTRUCTIONS" = true ]; then
        show_github_instructions
    fi
    
    log "✓ Proceso completado"
}

# Ejecutar script
main "$@"
