#!/usr/bin/env bash
# scripts/config/setup_env.sh
# Script idempotente para configurar el entorno de desarrollo
# Este script puede ejecutarse múltiples veces sin causar problemas

set -euo pipefail  # Salir en error, variables no definidas, fallos en pipes

# Colores para output legible
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
}

# ============================================
# Verificar Flutter (idempotente)
# ============================================
verify_flutter() {
    log_section "Verificando Flutter"
    
    if command -v flutter &> /dev/null; then
        local version=$(flutter --version | head -n1)
        log_skip "Flutter ya está instalado: $version"
        return 0
    else
        log_warn "Flutter no está instalado."
        log_info "Por favor, instala Flutter desde: https://flutter.dev/docs/get-started/install"
        return 1
    fi
}

# ============================================
# Crear directorios necesarios (idempotente con -p)
# ============================================
create_directories() {
    log_section "Creando Estructura de Directorios"
    
    local directories=(
        "assets/images"
        "scripts/config/fixtures"
        "testing"
        "docs"
        "test/fixtures"
        ".git/hooks"
    )
    
    for dir in "${directories[@]}"; do
        if [ -d "$dir" ]; then
            log_skip "Directorio ya existe: $dir"
        else
            log_info "Creando directorio: $dir"
            mkdir -p "$dir"
        fi
    done
    
    log_info "✓ Estructura de directorios verificada."
}

# ============================================
# Configurar archivo .env.local (idempotente)
# ============================================
setup_env_file() {
    log_section "Configurando Archivo de Entorno"
    
    local env_file=".env.local"
    
    if [ -f "$env_file" ]; then
        log_skip "Archivo $env_file ya existe."
    else
        log_info "Creando $env_file..."
        cat > "$env_file" << 'EOF'
# Configuración local del entorno de desarrollo
# Este archivo NO debe commitearse a Git

# Entorno
FLUTTER_ENV=development

# Stripe (Reemplaza con tus claves de test)
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxxxxxxxxxx
STRIPE_SECRET_KEY=sk_test_xxxxxxxxxxxxx

# Firebase (Configuración gestionada por flutterfire)
# Las claves Firebase están en firebase_options.dart

# Configuración de la aplicación
APP_DEBUG=true
EOF
        log_info "✓ Archivo $env_file creado."
    fi
    
    # Asegurar que .env.local esté en .gitignore
    if [ -f ".gitignore" ]; then
        if ! grep -q ".env.local" .gitignore; then
            log_info "Añadiendo .env.local a .gitignore..."
            echo "" >> .gitignore
            echo "# Local environment configuration" >> .gitignore
            echo ".env.local" >> .gitignore
        else
            log_skip ".env.local ya está en .gitignore"
        fi
    fi
}

# ============================================
# Configurar .gitignore (idempotente)
# ============================================
setup_gitignore() {
    log_section "Configurando .gitignore"
    
    if [ ! -f ".gitignore" ]; then
        log_info "Creando .gitignore..."
        cat > .gitignore << 'EOF'
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Environment files
.env.local
.env.*.local

# Testing
/coverage/
*.test

# Temporary files
/tmp/
*.tmp
*.bak
*.swp
*~

# Scripts markers
.initialized
.done
EOF
        log_info "✓ .gitignore creado."
    else
        log_skip ".gitignore ya existe."
    fi
}

# ============================================
# Configurar Git hooks (idempotente)
# ============================================
setup_git_hooks() {
    log_section "Configurando Git Hooks"
    
    # Pre-commit hook para formateo automático
    local hook_file=".git/hooks/pre-commit"
    
    if [ -f "$hook_file" ]; then
        log_skip "Git hook pre-commit ya existe."
    else
        log_info "Configurando Git hook pre-commit..."
        mkdir -p .git/hooks
        cat > "$hook_file" << 'EOF'
#!/bin/sh
# Pre-commit hook: Formatear código Dart antes de commit

echo "Ejecutando pre-commit hook: Formateo de código Dart..."

# Formatear código modificado
flutter format .

# Añadir archivos formateados al commit
git add -u

echo "✓ Código formateado."
exit 0
EOF
        chmod +x "$hook_file"
        log_info "✓ Git hook pre-commit configurado."
    fi
    
    # Pre-push hook para ejecutar tests
    local pre_push_hook=".git/hooks/pre-push"
    
    if [ -f "$pre_push_hook" ]; then
        log_skip "Git hook pre-push ya existe."
    else
        log_info "Configurando Git hook pre-push..."
        cat > "$pre_push_hook" << 'EOF'
#!/bin/sh
# Pre-push hook: Ejecutar tests antes de push

echo "Ejecutando pre-push hook: Tests..."

# Ejecutar tests de Flutter
if ! flutter test; then
    echo "❌ Tests fallaron. Push cancelado."
    exit 1
fi

echo "✓ Tests pasaron correctamente."
exit 0
EOF
        chmod +x "$pre_push_hook"
        log_info "✓ Git hook pre-push configurado."
    fi
}

# ============================================
# Crear archivo README para scripts (idempotente)
# ============================================
create_scripts_readme() {
    log_section "Documentando Scripts"
    
    local readme_file="scripts/README.md"
    
    if [ -f "$readme_file" ]; then
        log_skip "$readme_file ya existe."
    else
        log_info "Creando $readme_file..."
        cat > "$readme_file" << 'EOF'
# Scripts de Configuración

Este directorio contiene scripts idempotentes para configurar el entorno de desarrollo.

## Scripts Disponibles

### `config/setup_env.sh`
Configura el entorno de desarrollo completo.

- **Idempotente**: ✓ Sí
- **Automatizado**: ✓ Sí
- **Uso**: `bash scripts/config/setup_env.sh`

### `config/fixtures/setup_test_data.sh`
Configura datos de prueba y fixtures.

- **Idempotente**: ✓ Sí
- **Automatizado**: ✓ Sí
- **Uso**: `bash scripts/config/fixtures/setup_test_data.sh`

## Principios

Todos los scripts en este directorio siguen estos principios:

1. **Idempotencia**: Pueden ejecutarse múltiples veces sin efectos secundarios
2. **Verificación**: Comprueban el estado antes de actuar
3. **Logging claro**: Indican qué hacen y qué saltan
4. **Manejo de errores**: Usan `set -euo pipefail` y manejan fallos graciosamente
5. **Sin interacción**: No requieren input manual (completamente automatizados)

## Convenciones

- Archivos marcadores (`.initialized`, `.done`) indican operaciones completadas
- Logs con colores: `[INFO]` (verde), `[SKIP]` (amarillo), `[ERROR]` (rojo)
- Uso de `mkdir -p`, `cp -n`, y otros comandos idempotentes
EOF
        log_info "✓ $readme_file creado."
    fi
}

# ============================================
# Verificar dependencias de Flutter (idempotente)
# ============================================
verify_flutter_dependencies() {
    log_section "Verificando Dependencias de Flutter"
    
    if [ -f "pubspec.yaml" ]; then
        log_info "Ejecutando flutter pub get..."
        flutter pub get
        log_info "✓ Dependencias verificadas."
    else
        log_warn "pubspec.yaml no encontrado."
    fi
}

# ============================================
# Crear archivo de configuración de ejemplo (idempotente)
# ============================================
create_example_config() {
    log_section "Creando Configuración de Ejemplo"
    
    local example_file="config.example.json"
    
    if [ -f "$example_file" ]; then
        log_skip "$example_file ya existe."
    else
        log_info "Creando $example_file..."
        cat > "$example_file" << 'EOF'
{
  "project": "tokyo_roulette_predicciones",
  "version": "1.0.0",
  "environment": {
    "development": {
      "debug": true,
      "verbose_logging": true
    },
    "production": {
      "debug": false,
      "verbose_logging": false
    }
  },
  "features": {
    "stripe_payments": true,
    "firebase_integration": true,
    "in_app_purchases": true
  }
}
EOF
        log_info "✓ $example_file creado."
    fi
}

# ============================================
# Función principal
# ============================================
main() {
    log_section "Configuración del Entorno de Desarrollo"
    log_info "Este script configurará tu entorno de forma idempotente."
    
    # Ejecutar todas las configuraciones
    verify_flutter || log_warn "Continúa sin Flutter, algunas operaciones pueden fallar."
    create_directories
    setup_gitignore
    setup_env_file
    setup_git_hooks
    create_scripts_readme
    create_example_config
    
    # Verificar dependencias si Flutter está disponible
    if command -v flutter &> /dev/null; then
        verify_flutter_dependencies
    fi
    
    log_section "Configuración Completada"
    log_info "✓ Entorno de desarrollo configurado correctamente."
    log_info ""
    log_info "Próximos pasos:"
    log_info "  1. Editar .env.local con tus claves API"
    log_info "  2. Ejecutar: make test"
    log_info "  3. Ejecutar: flutter run"
    echo ""
}

# Ejecutar solo si se llama directamente (no al hacer source)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
