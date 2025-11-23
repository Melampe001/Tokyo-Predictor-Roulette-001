# Scripts de Configuración

Este directorio contiene scripts idempotentes para configurar el entorno de desarrollo y gestionar fixtures de prueba.

## Estructura

```
scripts/
├── README.md                           # Este archivo
└── config/
    ├── setup_env.sh                    # Configuración del entorno de desarrollo
    └── fixtures/
        └── setup_test_data.sh          # Configuración de datos de prueba
```

## Scripts Disponibles

### 1. `config/setup_env.sh`

**Descripción**: Configura el entorno de desarrollo completo de forma idempotente.

**Características:**
- ✓ **Idempotente**: Puede ejecutarse múltiples veces sin errores
- ✓ **Automatizado**: No requiere intervención manual
- ✓ **Seguro**: Verifica antes de crear/modificar archivos

**Operaciones que realiza:**
1. Verifica instalación de Flutter
2. Crea estructura de directorios necesaria
3. Configura archivo `.env.local` (solo si no existe)
4. Configura `.gitignore` (solo si no existe)
5. Instala Git hooks (pre-commit y pre-push)
6. Crea documentación de scripts
7. Crea archivo de configuración de ejemplo
8. Instala dependencias de Flutter

**Uso:**
```bash
# Desde la raíz del proyecto
bash scripts/config/setup_env.sh

# O usando Make
make setup-env
```

**Output de ejemplo:**
```
═══════════════════════════════════════════════════════
  Configuración del Entorno de Desarrollo
═══════════════════════════════════════════════════════
[INFO] Este script configurará tu entorno de forma idempotente.

═══════════════════════════════════════════════════════
  Verificando Flutter
═══════════════════════════════════════════════════════
[SKIP] Flutter ya está instalado: Flutter 3.16.0

═══════════════════════════════════════════════════════
  Creando Estructura de Directorios
═══════════════════════════════════════════════════════
[SKIP] Directorio ya existe: assets/images
[INFO] Creando directorio: scripts/config/fixtures
[INFO] ✓ Estructura de directorios verificada.

...

═══════════════════════════════════════════════════════
  Configuración Completada
═══════════════════════════════════════════════════════
[INFO] ✓ Entorno de desarrollo configurado correctamente.
```

**Archivos creados (primera ejecución):**
- `.env.local` - Configuración local del entorno
- `.gitignore` - Reglas de ignorar archivos (si no existe)
- `.git/hooks/pre-commit` - Hook de formateo automático
- `.git/hooks/pre-push` - Hook de ejecución de tests
- `scripts/README.md` - Documentación de scripts
- `config.example.json` - Configuración de ejemplo

**Ejecuciones subsiguientes:**
```
[SKIP] Flutter ya está instalado: Flutter 3.16.0
[SKIP] Directorio ya existe: assets/images
[SKIP] .gitignore ya existe.
[SKIP] Archivo .env.local ya existe.
[SKIP] Git hook pre-commit ya existe.
...
```

---

### 2. `config/fixtures/setup_test_data.sh`

**Descripción**: Configura datos de prueba y fixtures de forma idempotente.

**Características:**
- ✓ **Idempotente**: Usa archivo marcador `.initialized`
- ✓ **Automatizado**: Totalmente automatizado
- ✓ **Consistente**: Genera los mismos datos cada vez

**Operaciones que realiza:**
1. Crea directorio `test/fixtures/`
2. Genera archivos JSON con datos de prueba:
   - `test_spins.json` - Datos de giros de ruleta
   - `test_config.json` - Configuración de prueba
   - `test_users.json` - Usuarios de prueba
   - `test_martingale_sequences.json` - Secuencias de prueba Martingale
3. Crea documentación de fixtures
4. Marca como inicializado (`.initialized`)

**Uso:**
```bash
# Desde la raíz del proyecto
bash scripts/config/fixtures/setup_test_data.sh

# O usando Make
make setup-fixtures
```

**Output de ejemplo (primera ejecución):**
```
[INFO] Verificando directorio de fixtures...
[INFO] Inicializando fixtures de prueba...
[INFO] Creando test_spins.json...
[INFO] Creando test_config.json...
[INFO] Creando test_users.json...
[INFO] Creando test_martingale_sequences.json...
[INFO] Creando README.md en fixtures...
[INFO] Marcando fixtures como inicializados...
[INFO] ✓ Fixtures de prueba inicializados correctamente.

[INFO] Archivos creados:
[INFO]   - test/fixtures/test_spins.json
[INFO]   - test/fixtures/test_config.json
[INFO]   - test/fixtures/test_users.json
[INFO]   - test/fixtures/test_martingale_sequences.json
[INFO]   - test/fixtures/README.md

[INFO] Marcador de inicialización: test/fixtures/.initialized
```

**Output de ejemplo (ejecución subsiguiente):**
```
[INFO] Verificando directorio de fixtures...
[SKIP] Fixtures ya inicializados previamente.
[INFO] Para reinicializar, elimina: test/fixtures/.initialized
```

**Reinicialización:**
```bash
# Eliminar marcador y reinicializar
rm test/fixtures/.initialized
bash scripts/config/fixtures/setup_test_data.sh
```

---

## Principios de Idempotencia

Todos los scripts en este directorio siguen estos principios:

### 1. Verificar antes de actuar

```bash
# ✓ Correcto: Verificar antes de crear
if [ -f "$file" ]; then
    log_skip "Archivo ya existe: $file"
else
    log_info "Creando $file..."
    create_file "$file"
fi

# ✗ Incorrecto: Crear sin verificar
create_file "$file"  # Falla si ya existe
```

### 2. Usar operaciones idempotentes

```bash
# ✓ Correcto: mkdir -p (idempotente)
mkdir -p /path/to/dir

# ✗ Incorrecto: mkdir (falla si existe)
mkdir /path/to/dir
```

### 3. Manejo de errores robusto

```bash
# Usar strict mode en todos los scripts
set -euo pipefail
# -e: Salir en error
# -u: Error en variables no definidas
# -o pipefail: Error en cualquier comando de un pipe
```

### 4. Logging claro

```bash
# Usar colores y mensajes descriptivos
log_info()  # Verde: Operación realizada
log_skip()  # Amarillo: Operación saltada (ya hecha)
log_warn()  # Amarillo: Advertencia
log_error() # Rojo: Error
```

### 5. Archivos marcadores

```bash
# Usar archivos marcadores para operaciones costosas
MARKER_FILE=".initialized"

if [ -f "$MARKER_FILE" ]; then
    echo "Ya inicializado"
    exit 0
fi

# ... hacer operaciones ...

touch "$MARKER_FILE"
```

---

## Convenciones de Código

### Nombres de archivos
- Usar `snake_case` para nombres de scripts: `setup_env.sh`, `setup_test_data.sh`
- Extensión `.sh` para scripts Bash

### Estructura de script
```bash
#!/usr/bin/env bash
# Descripción del script
# Indicar si es idempotente y automatizado

set -euo pipefail  # Strict mode

# Constantes y configuración
CONST_VALUE="valor"

# Funciones de utilidad
function_name() {
    # Implementación
}

# Función principal
main() {
    # Lógica principal
}

# Ejecutar solo si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### Colores
```bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color
```

### Funciones de logging
```bash
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
```

---

## Testing de Scripts

### Tests Automatizados (Go)

Los scripts se prueban automáticamente en `testing/idempotence_test.go`:

```bash
# Ejecutar tests de idempotencia
cd testing
go test -v -run TestScriptIdempotence
```

### Tests Manuales

```bash
# Probar idempotencia manualmente
bash scripts/config/setup_env.sh
bash scripts/config/setup_env.sh  # Debe saltar operaciones

# Verificar con Make
make verify-idempotence
```

### CI/CD

Los scripts se prueban en cada PR mediante GitHub Actions (`.github/workflows/test-idempotency.yml`):

```yaml
- name: Verificar setup_env.sh (primera ejecución)
  run: bash scripts/config/setup_env.sh

- name: Verificar setup_env.sh (segunda ejecución)
  run: bash scripts/config/setup_env.sh
```

---

## Solución de Problemas

### Problema: Script falla en segunda ejecución

**Causa**: El script no es idempotente (crea archivos sin verificar)

**Solución**: Añadir verificación antes de crear:
```bash
if [ ! -f "$file" ]; then
    create_file "$file"
fi
```

### Problema: Permisos de ejecución

**Causa**: Scripts no tienen permisos de ejecución

**Solución**:
```bash
chmod +x scripts/config/setup_env.sh
chmod +x scripts/config/fixtures/setup_test_data.sh
```

### Problema: Git hooks no se ejecutan

**Causa**: Hooks no tienen permisos de ejecución

**Solución**:
```bash
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
```

### Problema: Necesito reinicializar fixtures

**Solución**:
```bash
rm test/fixtures/.initialized
make setup-fixtures
```

---

## Contribuir

Al añadir nuevos scripts:

1. **Seguir principios de idempotencia**
2. **Añadir documentación** en este README
3. **Añadir tests** en `testing/idempotence_test.go`
4. **Usar colores y logging** consistente
5. **Documentar en el Makefile** si corresponde

### Template de nuevo script

```bash
#!/usr/bin/env bash
# Descripción breve del script
# Idempotente: ✓ (o ✗)
# Automatizado: ✓ (o ✗)

set -euo pipefail

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

# Lógica del script
main() {
    log_info "Iniciando..."
    
    # Verificar y actuar
    if [ condición ]; then
        log_skip "Ya hecho"
    else
        log_info "Haciendo..."
        # Acción
    fi
    
    log_info "✓ Completado"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

---

## Referencias

- [Documentación de Idempotencia](../docs/idempotencia_automatizacion.md)
- [Tests de Idempotencia](../docs/tests_idempotencia.md)
- [Makefile](../Makefile)
- [Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

---

**Última actualización**: 2025-11-23  
**Mantenido por**: Equipo Tokyo Predictor Roulette
