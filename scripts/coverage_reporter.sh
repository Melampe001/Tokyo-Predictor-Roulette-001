#!/bin/bash
# Bot 7B: CoverageReporter
# Script para generar y reportar cobertura de tests
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
COVERAGE_THRESHOLD=80
HTML_REPORT=false
FAIL_BELOW_THRESHOLD=true
COVERAGE_DIR="coverage"

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
${GREEN}Bot 7B: CoverageReporter${NC} - Generación y reporte de cobertura de tests

${BLUE}USO:${NC}
    $0 [OPCIONES]

${BLUE}OPCIONES:${NC}
    --html              Generar reporte HTML
    --threshold NUM     Umbral de cobertura (default: 80%)
    --no-fail           No fallar si cobertura < umbral
    --dry-run           Simular sin ejecutar
    --help              Mostrar esta ayuda

${BLUE}EJEMPLOS:${NC}
    # Ejecutar tests con coverage
    $0

    # Generar reporte HTML
    $0 --html

    # Usar umbral de 90%
    $0 --threshold 90

    # No fallar si cobertura < umbral
    $0 --no-fail

    # Modo dry-run
    $0 --dry-run

${BLUE}FUNCIONALIDADES:${NC}
    ✓ Ejecuta tests con coverage (flutter test --coverage)
    ✓ Genera reporte HTML (genhtml)
    ✓ Calcula porcentaje de cobertura
    ✓ Falla si cobertura < umbral (configurable)
    ✓ Genera badge de cobertura
    ✓ Reporte detallado por archivo

${BLUE}ARCHIVOS GENERADOS:${NC}
    - coverage/lcov.info          (datos de cobertura)
    - coverage/html/index.html    (reporte HTML)
    - coverage/coverage-badge.svg (badge)
    - coverage/summary.txt        (resumen)

${BLUE}REQUISITOS:${NC}
    - Flutter instalado
    - lcov (para genhtml): apt-get install lcov

EOF
}

# Función para validar dependencias
check_dependencies() {
    log "Validando dependencias..."
    
    local missing_deps=()
    
    if ! command -v flutter &> /dev/null; then
        missing_deps+=("flutter")
    fi
    
    if [ "$HTML_REPORT" = true ] && ! command -v genhtml &> /dev/null; then
        log_warning "genhtml no encontrado. Instala lcov: apt-get install lcov"
        log_warning "Continuando sin generar reporte HTML..."
        HTML_REPORT=false
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Dependencias faltantes: ${missing_deps[*]}"
        exit 1
    fi
    
    log "✓ Dependencias instaladas"
}

# Función para ejecutar tests con coverage
run_tests_with_coverage() {
    log "Ejecutando tests con coverage..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Ejecutaría: flutter test --coverage"
        return 0
    fi
    
    # Limpiar coverage anterior
    rm -rf "$COVERAGE_DIR"
    
    # Ejecutar tests
    flutter test --coverage
    
    if [ ! -f "$COVERAGE_DIR/lcov.info" ]; then
        log_error "No se generó archivo de coverage"
        exit 1
    fi
    
    log "✓ Tests ejecutados con coverage"
}

# Función para calcular porcentaje de cobertura
calculate_coverage_percentage() {
    log "Calculando porcentaje de cobertura..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Calcularía porcentaje de cobertura"
        echo "85.5"  # Valor de ejemplo para dry-run
        return 0
    fi
    
    if [ ! -f "$COVERAGE_DIR/lcov.info" ]; then
        log_error "No se encontró archivo de coverage"
        exit 1
    fi
    
    # Usar lcov para obtener resumen
    if command -v lcov &> /dev/null; then
        local summary=$(lcov --summary "$COVERAGE_DIR/lcov.info" 2>&1)
        
        # Extraer porcentaje de líneas
        local percentage=$(echo "$summary" | grep "lines" | grep -oP '\d+\.\d+(?=%)')
        
        if [ -z "$percentage" ]; then
            log_error "No se pudo calcular el porcentaje de cobertura"
            exit 1
        fi
        
        echo "$percentage"
    else
        # Calcular manualmente si lcov no está disponible
        local total_lines=$(grep -c "^DA:" "$COVERAGE_DIR/lcov.info" || echo 0)
        local covered_lines=$(grep "^DA:" "$COVERAGE_DIR/lcov.info" | grep -c ",0$" || echo 0)
        local covered=$((total_lines - covered_lines))
        
        if [ "$total_lines" -eq 0 ]; then
            echo "0"
        else
            echo "scale=2; ($covered * 100) / $total_lines" | bc
        fi
    fi
}

# Función para generar reporte HTML
generate_html_report() {
    log "Generando reporte HTML..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Generaría reporte HTML"
        return 0
    fi
    
    if ! command -v genhtml &> /dev/null; then
        log_warning "genhtml no disponible, saltando generación de HTML"
        return 0
    fi
    
    genhtml "$COVERAGE_DIR/lcov.info" -o "$COVERAGE_DIR/html" --quiet
    
    if [ -f "$COVERAGE_DIR/html/index.html" ]; then
        log "✓ Reporte HTML generado: $COVERAGE_DIR/html/index.html"
        log_info "Abre el reporte: file://$(pwd)/$COVERAGE_DIR/html/index.html"
    else
        log_error "No se pudo generar el reporte HTML"
        exit 1
    fi
}

# Función para generar badge de cobertura
generate_coverage_badge() {
    local percentage=$1
    log "Generando badge de cobertura..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Generaría badge de cobertura"
        return 0
    fi
    
    # Determinar color del badge
    local color="red"
    if (( $(echo "$percentage >= 80" | bc -l) )); then
        color="brightgreen"
    elif (( $(echo "$percentage >= 60" | bc -l) )); then
        color="yellow"
    elif (( $(echo "$percentage >= 40" | bc -l) )); then
        color="orange"
    fi
    
    # Generar SVG badge
    local badge_file="$COVERAGE_DIR/coverage-badge.svg"
    cat > "$badge_file" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="110" height="20">
  <linearGradient id="b" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <mask id="a">
    <rect width="110" height="20" rx="3" fill="#fff"/>
  </mask>
  <g mask="url(#a)">
    <path fill="#555" d="M0 0h63v20H0z"/>
    <path fill="#$color" d="M63 0h47v20H63z"/>
    <path fill="url(#b)" d="M0 0h110v20H0z"/>
  </g>
  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">
    <text x="31.5" y="15" fill="#010101" fill-opacity=".3">coverage</text>
    <text x="31.5" y="14">coverage</text>
    <text x="85.5" y="15" fill="#010101" fill-opacity=".3">${percentage}%</text>
    <text x="85.5" y="14">${percentage}%</text>
  </g>
</svg>
EOF
    
    log "✓ Badge generado: $badge_file"
}

# Función para generar resumen
generate_summary() {
    local percentage=$1
    log "Generando resumen..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Generaría resumen"
        return 0
    fi
    
    local summary_file="$COVERAGE_DIR/summary.txt"
    
    cat > "$summary_file" << EOF
=================================================================
                    REPORTE DE COBERTURA
=================================================================

Fecha: $(date +"%Y-%m-%d %H:%M:%S")
Porcentaje de cobertura: ${percentage}%
Umbral configurado: ${COVERAGE_THRESHOLD}%

Estado: $(if (( $(echo "$percentage >= $COVERAGE_THRESHOLD" | bc -l) )); then echo "PASS ✓"; else echo "FAIL ✗"; fi)

=================================================================

Archivos generados:
  - $COVERAGE_DIR/lcov.info          (datos de cobertura)
  - $COVERAGE_DIR/html/index.html    (reporte HTML)
  - $COVERAGE_DIR/coverage-badge.svg (badge)
  - $COVERAGE_DIR/summary.txt        (este archivo)

=================================================================
EOF
    
    cat "$summary_file"
    log "✓ Resumen guardado: $summary_file"
}

# Función para verificar umbral
check_threshold() {
    local percentage=$1
    
    log "Verificando umbral de cobertura..."
    log_info "Cobertura actual: ${percentage}%"
    log_info "Umbral requerido: ${COVERAGE_THRESHOLD}%"
    
    if (( $(echo "$percentage >= $COVERAGE_THRESHOLD" | bc -l) )); then
        log "✓ Cobertura PASS (${percentage}% >= ${COVERAGE_THRESHOLD}%)"
        return 0
    else
        log_error "Cobertura FAIL (${percentage}% < ${COVERAGE_THRESHOLD}%)"
        
        if [ "$FAIL_BELOW_THRESHOLD" = true ]; then
            log_error "La cobertura está por debajo del umbral"
            return 1
        else
            log_warning "Continuando a pesar de cobertura baja (--no-fail activado)"
            return 0
        fi
    fi
}

# Función principal
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║          Bot 7B: CoverageReporter                         ║"
    echo "║          Generación de Reporte de Cobertura               ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Si no hay argumentos, usar defaults
    if [ $# -eq 0 ]; then
        log_info "Usando configuración predeterminada"
    fi
    
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --html)
                HTML_REPORT=true
                shift
                ;;
            --threshold)
                COVERAGE_THRESHOLD=$2
                shift 2
                ;;
            --no-fail)
                FAIL_BELOW_THRESHOLD=false
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
    
    # Ejecutar tests con coverage
    run_tests_with_coverage
    
    # Calcular porcentaje de cobertura
    local percentage=$(calculate_coverage_percentage)
    
    # Generar reporte HTML si se solicitó
    if [ "$HTML_REPORT" = true ]; then
        generate_html_report
    fi
    
    # Generar badge
    generate_coverage_badge "$percentage"
    
    # Generar resumen
    generate_summary "$percentage"
    
    # Verificar umbral
    if ! check_threshold "$percentage"; then
        exit 1
    fi
    
    log "✓ Proceso completado exitosamente"
}

# Ejecutar script
main "$@"
