#!/bin/bash
# Bot 5C: VersionManager
# Script para gestionar versiones automáticamente
# Autor: AGENTE 5 - Release Master
# Fecha: 2025-12-15

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Constantes
VERSION_REGEX='^[0-9]+\.[0-9]+\.[0-9]+\+[0-9]+$'

# Variables globales
DRY_RUN=false
INCREMENT_TYPE=""
PUBSPEC_FILE="pubspec.yaml"
CHANGELOG_FILE="CHANGELOG.md"
CREATE_TAG=false
SHOW_CURRENT=false

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
${GREEN}Bot 5C: VersionManager${NC} - Gestión automática de versiones

${BLUE}USO:${NC}
    $0 [TIPO] [OPCIONES]

${BLUE}TIPOS DE INCREMENTO:${NC}
    major       Incrementar versión mayor (1.0.0 -> 2.0.0)
    minor       Incrementar versión menor (1.0.0 -> 1.1.0)
    patch       Incrementar versión parche (1.0.0 -> 1.0.1)
    current     Mostrar versión actual

${BLUE}OPCIONES:${NC}
    --tag       Crear git tag automáticamente
    --dry-run   Simular sin ejecutar
    --help      Mostrar esta ayuda

${BLUE}EJEMPLOS:${NC}
    # Incrementar version patch (1.0.0 -> 1.0.1)
    $0 patch

    # Incrementar version minor (1.0.0 -> 1.1.0)
    $0 minor

    # Incrementar version major (1.0.0 -> 2.0.0)
    $0 major

    # Incrementar y crear tag
    $0 minor --tag

    # Ver versión actual
    $0 current

    # Modo dry-run
    $0 patch --dry-run

${BLUE}FUNCIONALIDADES:${NC}
    ✓ Lee versión actual de pubspec.yaml
    ✓ Incrementa versión según tipo (major/minor/patch)
    ✓ Actualiza version code para Android automáticamente
    ✓ Crea git tag con formato v*.*.* (opcional)
    ✓ Genera entrada en CHANGELOG (si existe)
    ✓ Valida formato de versión (semver)

${BLUE}FORMATO DE VERSIÓN:${NC}
    pubspec.yaml: version: X.Y.Z+BUILD
    - X = Major version (cambios incompatibles)
    - Y = Minor version (nuevas funcionalidades)
    - Z = Patch version (bug fixes)
    - BUILD = Version code (incrementa siempre)

EOF
}

# Función para validar formato de versión
validate_version_format() {
    local version=$1
    if [[ ! $version =~ $VERSION_REGEX ]]; then
        log_error "Formato de versión inválido: $version"
        log_error "Formato esperado: X.Y.Z+BUILD (ej: 1.0.0+1)"
        exit 1
    fi
}

# Función para leer versión actual
read_current_version() {
    if [ ! -f "$PUBSPEC_FILE" ]; then
        log_error "No se encontró $PUBSPEC_FILE"
        exit 1
    fi
    
    local version_line=$(grep "^version:" "$PUBSPEC_FILE" | head -1)
    local version=$(echo "$version_line" | sed 's/version: //' | tr -d ' ')
    
    if [ -z "$version" ]; then
        log_error "No se pudo leer la versión de $PUBSPEC_FILE"
        exit 1
    fi
    
    echo "$version"
}

# Función para separar versión y build
parse_version() {
    local full_version=$1
    local version_part=$(echo "$full_version" | cut -d'+' -f1)
    local build_part=$(echo "$full_version" | cut -d'+' -f2)
    
    echo "$version_part $build_part"
}

# Función para incrementar versión
increment_version() {
    local current_version=$1
    local increment_type=$2
    
    # Parsear versión actual
    local parsed=($(parse_version "$current_version"))
    local version_part=${parsed[0]}
    local build_part=${parsed[1]}
    
    # Separar major.minor.patch
    IFS='.' read -ra VERSION_PARTS <<< "$version_part"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    # Incrementar según tipo
    case $increment_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            log_error "Tipo de incremento inválido: $increment_type"
            exit 1
            ;;
    esac
    
    # Incrementar build number
    local new_build=$((build_part + 1))
    
    # Crear nueva versión
    local new_version="$major.$minor.$patch+$new_build"
    
    echo "$new_version"
}

# Función para actualizar pubspec.yaml
update_pubspec() {
    local old_version=$1
    local new_version=$2
    
    log "Actualizando $PUBSPEC_FILE..."
    log_info "Versión anterior: $old_version"
    log_info "Versión nueva: $new_version"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Actualizaría $PUBSPEC_FILE"
        return 0
    fi
    
    # Crear backup
    cp "$PUBSPEC_FILE" "${PUBSPEC_FILE}.backup"
    
    # Actualizar versión
    sed -i "s/^version: .*/version: $new_version/" "$PUBSPEC_FILE"
    
    # Verificar cambio
    local updated_version=$(read_current_version)
    if [ "$updated_version" = "$new_version" ]; then
        log "✓ $PUBSPEC_FILE actualizado correctamente"
        rm "${PUBSPEC_FILE}.backup"
    else
        log_error "Error al actualizar $PUBSPEC_FILE"
        mv "${PUBSPEC_FILE}.backup" "$PUBSPEC_FILE"
        exit 1
    fi
}

# Función para generar entrada en CHANGELOG
update_changelog() {
    local version=$1
    local date=$(date +"%Y-%m-%d")
    
    if [ ! -f "$CHANGELOG_FILE" ]; then
        log_warning "No se encontró $CHANGELOG_FILE, creando uno nuevo..."
        cat > "$CHANGELOG_FILE" << EOF
# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

EOF
    fi
    
    log "Actualizando $CHANGELOG_FILE..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Agregaría entrada en $CHANGELOG_FILE"
        return 0
    fi
    
    # Crear entrada temporal
    local temp_file=$(mktemp)
    
    # Obtener el contenido después del encabezado
    local header_lines=3
    head -n $header_lines "$CHANGELOG_FILE" > "$temp_file"
    
    # Agregar nueva entrada
    cat >> "$temp_file" << EOF

## [${version}] - ${date}

### Added
- Nueva versión ${version}

### Changed
- Actualización de versión

### Fixed
- Correcciones menores

EOF
    
    # Agregar el resto del changelog
    tail -n +$((header_lines + 1)) "$CHANGELOG_FILE" >> "$temp_file"
    
    # Reemplazar archivo original
    mv "$temp_file" "$CHANGELOG_FILE"
    
    log "✓ $CHANGELOG_FILE actualizado"
    log_warning "⚠️  Edita $CHANGELOG_FILE para agregar detalles específicos de esta versión"
}

# Función para crear git tag
create_git_tag() {
    local version=$1
    local tag_name="v$version"
    
    # Extraer solo la versión sin el build number para el tag
    local version_part=$(echo "$version" | cut -d'+' -f1)
    tag_name="v$version_part"
    
    log "Creando git tag: $tag_name..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Crearía git tag $tag_name"
        return 0
    fi
    
    # Verificar si el tag ya existe
    if git rev-parse "$tag_name" >/dev/null 2>&1; then
        log_error "El tag $tag_name ya existe"
        exit 1
    fi
    
    # Crear tag anotado
    git tag -a "$tag_name" -m "Release version $version_part"
    
    log "✓ Tag $tag_name creado"
    log_info "Para subir el tag: git push origin $tag_name"
}

# Función para mostrar versión actual
show_current_version() {
    local version=$(read_current_version)
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          Versión Actual                                   ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Parsear versión
    local parsed=($(parse_version "$version"))
    local version_part=${parsed[0]}
    local build_part=${parsed[1]}
    
    IFS='.' read -ra VERSION_PARTS <<< "$version_part"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    log_info "Versión completa: $version"
    log_info "Versión: $version_part"
    log_info "  - Major: $major"
    log_info "  - Minor: $minor"
    log_info "  - Patch: $patch"
    log_info "Build number: $build_part"
    echo ""
    
    # Mostrar siguientes versiones posibles
    echo -e "${BLUE}Siguientes versiones posibles:${NC}"
    local next_major=$(increment_version "$version" "major")
    local next_minor=$(increment_version "$version" "minor")
    local next_patch=$(increment_version "$version" "patch")
    
    log_info "  major: $next_major"
    log_info "  minor: $next_minor"
    log_info "  patch: $next_patch"
    echo ""
}

# Función principal
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║          Bot 5C: VersionManager                           ║"
    echo "║          Gestión Automática de Versiones                  ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Si no hay argumentos, mostrar ayuda
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    # Parsear primer argumento (tipo de incremento)
    case $1 in
        major|minor|patch)
            INCREMENT_TYPE=$1
            shift
            ;;
        current)
            SHOW_CURRENT=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            log_error "Tipo de incremento inválido: $1"
            show_help
            exit 1
            ;;
    esac
    
    # Parsear opciones adicionales
    while [[ $# -gt 0 ]]; do
        case $1 in
            --tag)
                CREATE_TAG=true
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
    
    # Mostrar versión actual si se solicitó
    if [ "$SHOW_CURRENT" = true ]; then
        show_current_version
        exit 0
    fi
    
    # Leer versión actual
    local current_version=$(read_current_version)
    validate_version_format "$current_version"
    
    log_info "Versión actual: $current_version"
    
    # Calcular nueva versión
    local new_version=$(increment_version "$current_version" "$INCREMENT_TYPE")
    log_info "Nueva versión: $new_version"
    
    # Actualizar pubspec.yaml
    update_pubspec "$current_version" "$new_version"
    
    # Actualizar CHANGELOG
    update_changelog "$new_version"
    
    # Crear git tag si se solicitó
    if [ "$CREATE_TAG" = true ]; then
        create_git_tag "$new_version"
    fi
    
    log "✓ Versión actualizada exitosamente"
    
    # Mostrar resumen
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    log "RESUMEN:"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    log_info "Tipo de incremento: $INCREMENT_TYPE"
    log_info "Versión anterior: $current_version"
    log_info "Versión nueva: $new_version"
    
    if [ "$CREATE_TAG" = true ]; then
        local version_part=$(echo "$new_version" | cut -d'+' -f1)
        log_info "Git tag: v$version_part"
    fi
    
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    
    if [ "$DRY_RUN" = false ]; then
        echo ""
        log "Siguientes pasos:"
        log_info "1. Revisa los cambios en $PUBSPEC_FILE y $CHANGELOG_FILE"
        log_info "2. Commit los cambios: git add . && git commit -m 'Bump version to $new_version'"
        
        if [ "$CREATE_TAG" = true ]; then
            local version_part=$(echo "$new_version" | cut -d'+' -f1)
            log_info "3. Push los cambios y el tag: git push && git push origin v$version_part"
        else
            log_info "3. Push los cambios: git push"
        fi
        
        echo ""
    fi
}

# Ejecutar script
main "$@"
