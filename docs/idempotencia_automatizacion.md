# Idempotencia y Automatización

Este documento describe las prácticas, patrones y ejemplos para garantizar la **idempotencia** y **automatización** en todos los componentes del proyecto Tokyo Predictor Roulette.

## Tabla de Contenidos

1. [Conceptos Fundamentales](#conceptos-fundamentales)
2. [Makefile: Targets Idempotentes](#makefile-targets-idempotentes)
3. [Scripts de Configuración](#scripts-de-configuración)
4. [GitHub Actions Workflows](#github-actions-workflows)
5. [Generación de Código](#generación-de-código)
6. [Pruebas de Idempotencia](#pruebas-de-idempotencia)
7. [Mejores Prácticas](#mejores-prácticas)

---

## Conceptos Fundamentales

### ¿Qué es la Idempotencia?

**Idempotencia** significa que ejecutar una operación múltiples veces produce el mismo resultado que ejecutarla una sola vez. Es crucial para:
- **Confiabilidad**: Los scripts pueden reiniciarse sin efectos secundarios
- **CI/CD**: Los pipelines pueden reejecutarse de forma segura
- **Debugging**: Facilita la reproducción de problemas
- **Mantenibilidad**: Código más predecible y fácil de entender

### Principios Clave

1. **Verificar antes de actuar**: Comprobar si una operación es necesaria antes de ejecutarla
2. **Operaciones atómicas**: Usar operaciones que sean inherentemente idempotentes
3. **Manejo de errores robusto**: Diseñar para fallos parciales
4. **Estado claro**: Mantener un estado del sistema verificable

### Ejemplos de Operaciones Idempotentes

✅ **Idempotentes:**
```bash
# Crear directorio solo si no existe
mkdir -p /path/to/dir

# Configurar variable de entorno
export VAR=value

# Aplicar configuración con flag de idempotencia
kubectl apply -f config.yaml
```

❌ **No Idempotentes:**
```bash
# Añadir a archivo sin verificar
echo "line" >> file.txt

# Incrementar contador
counter=$((counter + 1))

# Crear sin verificar existencia
mkdir /path/to/dir  # Falla si existe
```

---

## Makefile: Targets Idempotentes

### Estructura del Makefile

Nuestro `Makefile` incluye targets documentados con:
- **Descripción**: Qué hace el target
- **Idempotencia**: Si es idempotente (✓/✗)
- **Automatización**: Si puede ejecutarse sin intervención manual (✓/✗)

### Ejemplos de Targets

```makefile
# ============================================
# Target: install-deps
# Descripción: Instala todas las dependencias del proyecto
# Idempotente: ✓ (Flutter/Dart verifican automáticamente)
# Automatizado: ✓ (No requiere input manual)
# ============================================
.PHONY: install-deps
install-deps:
	@echo "Instalando dependencias de Flutter..."
	flutter pub get
	@echo "Dependencias instaladas correctamente."

# ============================================
# Target: clean
# Descripción: Limpia archivos generados y caché
# Idempotente: ✓ (Limpiar varias veces = mismo estado)
# Automatizado: ✓
# ============================================
.PHONY: clean
clean:
	@echo "Limpiando archivos generados..."
	flutter clean
	rm -rf build/
	@echo "Limpieza completada."

# ============================================
# Target: test
# Descripción: Ejecuta todas las pruebas del proyecto
# Idempotente: ✓ (Las pruebas no modifican estado)
# Automatizado: ✓
# ============================================
.PHONY: test
test:
	@echo "Ejecutando pruebas de Flutter..."
	flutter test
	@echo "Ejecutando pruebas de idempotencia..."
	@if [ -d testing ]; then cd testing && go test ./...; fi

# ============================================
# Target: setup-env
# Descripción: Configura el entorno de desarrollo
# Idempotente: ✓ (Verifica antes de crear/modificar)
# Automatizado: ✓
# ============================================
.PHONY: setup-env
setup-env:
	@echo "Configurando entorno de desarrollo..."
	@bash scripts/config/setup_env.sh
	@echo "Entorno configurado."
```

### Patrón de Target Idempotente

```makefile
# Patrón recomendado para targets idempotentes
.PHONY: target-name
target-name:
	@# 1. Verificar estado actual
	@if [ ! -f .target-done ]; then \
		# 2. Ejecutar operación solo si necesario
		echo "Ejecutando operación..."; \
		# ... comandos ...; \
		# 3. Marcar como completado
		touch .target-done; \
	else \
		echo "Operación ya completada, saltando..."; \
	fi
```

---

## Scripts de Configuración

### Script Bash Idempotente

Los scripts en `scripts/config/` siguen estas prácticas:

```bash
#!/usr/bin/env bash
# scripts/config/setup_env.sh
# Script idempotente para configurar el entorno de desarrollo

set -euo pipefail  # Salir en error, variables no definidas, fallos en pipes

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

# Verificar e instalar Flutter (idempotente)
setup_flutter() {
    if command -v flutter &> /dev/null; then
        log_skip "Flutter ya está instalado: $(flutter --version | head -n1)"
    else
        log_info "Instalando Flutter..."
        # Comandos de instalación aquí
    fi
}

# Crear directorios necesarios (idempotente con -p)
create_directories() {
    log_info "Creando estructura de directorios..."
    mkdir -p assets/images
    mkdir -p scripts/config/fixtures
    mkdir -p testing
    mkdir -p docs
    log_info "Directorios creados."
}

# Configurar archivos de configuración (idempotente)
setup_config_files() {
    local config_file=".env.local"
    
    if [ -f "$config_file" ]; then
        log_skip "Archivo de configuración $config_file ya existe."
    else
        log_info "Creando $config_file..."
        cat > "$config_file" << 'EOF'
# Configuración local del entorno
FLUTTER_ENV=development
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
EOF
        log_info "$config_file creado."
    fi
}

# Configurar Git hooks (idempotente)
setup_git_hooks() {
    local hook_file=".git/hooks/pre-commit"
    
    if [ -f "$hook_file" ]; then
        log_skip "Git hook pre-commit ya existe."
    else
        log_info "Configurando Git hooks..."
        mkdir -p .git/hooks
        cat > "$hook_file" << 'EOF'
#!/bin/sh
# Pre-commit hook: ejecutar linter
flutter format --set-exit-if-changed .
EOF
        chmod +x "$hook_file"
        log_info "Git hooks configurados."
    fi
}

# Función principal
main() {
    log_info "Iniciando configuración del entorno..."
    
    setup_flutter
    create_directories
    setup_config_files
    setup_git_hooks
    
    log_info "✓ Configuración del entorno completada."
}

# Ejecutar solo si se llama directamente (no al sourcing)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### Script de Fixture Idempotente

```bash
#!/usr/bin/env bash
# scripts/config/fixtures/setup_test_data.sh
# Configura datos de prueba de forma idempotente

set -euo pipefail

FIXTURE_DIR="test/fixtures"
MARKER_FILE="${FIXTURE_DIR}/.initialized"

# Crear directorio de fixtures
mkdir -p "$FIXTURE_DIR"

# Verificar si ya se inicializó
if [ -f "$MARKER_FILE" ]; then
    echo "[SKIP] Fixtures ya inicializados."
    exit 0
fi

echo "[INFO] Inicializando fixtures de prueba..."

# Crear archivo de datos de prueba
cat > "${FIXTURE_DIR}/test_spins.json" << 'EOF'
{
  "spins": [12, 35, 3, 26, 0, 32, 15, 19, 4, 21],
  "description": "Datos de prueba para simulaciones de ruleta"
}
EOF

# Crear archivo de configuración de prueba
cat > "${FIXTURE_DIR}/test_config.json" << 'EOF'
{
  "base_bet": 1.0,
  "max_bet": 100.0,
  "wheel_type": "european"
}
EOF

# Marcar como inicializado
touch "$MARKER_FILE"

echo "[INFO] ✓ Fixtures inicializados correctamente."
```

---

## GitHub Actions Workflows

### Workflow Idempotente para CI/CD

```yaml
# .github/workflows/ci-idempotent.yml
name: CI/CD Idempotente

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

# Variables de entorno reutilizables
env:
  FLUTTER_VERSION: '3.16.0'
  GO_VERSION: '1.21'

jobs:
  # ============================================
  # Job: setup
  # Idempotente: ✓ (Cache de dependencias)
  # Automatizado: ✓
  # ============================================
  setup:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout código
        uses: actions/checkout@v4
      
      # Caché idempotente de dependencias Flutter
      - name: Cache Flutter dependencies
        uses: actions/cache@v3
        with:
          path: |
            ~/.pub-cache
            ${{ github.workspace }}/.dart_tool
          key: flutter-${{ runner.os }}-${{ hashFiles('**/pubspec.yaml') }}
          restore-keys: |
            flutter-${{ runner.os }}-
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true  # Caché automática idempotente
      
      - name: Instalar dependencias (idempotente)
        run: flutter pub get

  # ============================================
  # Job: test
  # Idempotente: ✓ (Tests no modifican estado)
  # Automatizado: ✓
  # ============================================
  test:
    needs: setup
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true
      
      - name: Ejecutar tests Flutter
        run: flutter test
      
      - name: Setup Go (para tests de idempotencia)
        uses: actions/setup-go@v4
        with:
          go-version: ${{ env.GO_VERSION }}
          cache: true  # Caché idempotente de módulos Go
      
      - name: Ejecutar tests de idempotencia
        run: |
          if [ -d testing ]; then
            cd testing
            go test -v ./...
          fi

  # ============================================
  # Job: build
  # Idempotente: ✓ (Build limpio cada vez)
  # Automatizado: ✓
  # ============================================
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          cache: true
      
      # Limpieza idempotente antes de build
      - name: Clean build artifacts
        run: flutter clean
      
      - name: Build APK
        run: flutter build apk --release
      
      # Upload idempotente con nombre versionado
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: apk-${{ github.sha }}
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 30
```

### Verificación de Idempotencia en Workflows

```yaml
# .github/workflows/test-idempotency.yml
name: Test Idempotency

on:
  pull_request:
  workflow_dispatch:  # Permitir ejecución manual

jobs:
  test-idempotency:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run setup script (primera vez)
        run: bash scripts/config/setup_env.sh
      
      - name: Capture state después de primera ejecución
        run: |
          find . -type f -newer /tmp > /tmp/state1.txt || true
      
      - name: Run setup script (segunda vez)
        run: bash scripts/config/setup_env.sh
      
      - name: Capture state después de segunda ejecución
        run: |
          find . -type f -newer /tmp/state1.txt > /tmp/state2.txt || true
      
      - name: Verificar idempotencia
        run: |
          if [ -s /tmp/state2.txt ]; then
            echo "❌ FALLO: El script modificó archivos en la segunda ejecución"
            cat /tmp/state2.txt
            exit 1
          else
            echo "✓ ÉXITO: El script es idempotente"
          fi
```

---

## Generación de Código

### Generación Idempotente con build_runner

```bash
# Script para generar código de forma idempotente
#!/usr/bin/env bash
# scripts/generate_code.sh

set -euo pipefail

echo "[INFO] Generando código..."

# Limpiar generaciones previas (idempotente)
flutter packages pub run build_runner clean

# Generar código (idempotente - sobrescribe archivos)
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "[INFO] ✓ Código generado correctamente."
```

### Makefile para Generación

```makefile
# ============================================
# Target: generate
# Descripción: Genera código fuente automáticamente
# Idempotente: ✓ (Limpia y regenera completamente)
# Automatizado: ✓
# ============================================
.PHONY: generate
generate:
	@echo "Generando código..."
	@bash scripts/generate_code.sh
	@echo "Código generado."
```

---

## Pruebas de Idempotencia

### Estructura de Tests

Los tests de idempotencia verifican que:
1. Ejecutar una operación múltiples veces produce el mismo resultado
2. No hay efectos secundarios no deseados
3. El estado del sistema es predecible

### Ejemplo en Go (testing/idempotence_test.go)

Consultar el archivo `testing/idempotence_test.go` para ejemplos completos.

### Ejemplo en Dart

```dart
// test/idempotence_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokyo_roulette_predicciones/roulette_logic.dart';

void main() {
  group('Idempotencia de MartingaleAdvisor', () {
    test('reset() es idempotente', () {
      final advisor = MartingaleAdvisor();
      
      // Modificar estado
      advisor.getNextBet(false); // Duplicar apuesta
      advisor.getNextBet(false); // Duplicar de nuevo
      
      // Primera ejecución de reset
      advisor.reset();
      final bet1 = advisor.currentBet;
      
      // Segunda ejecución de reset
      advisor.reset();
      final bet2 = advisor.currentBet;
      
      // Deben ser idénticos
      expect(bet1, equals(bet2));
      expect(bet1, equals(advisor.baseBet));
    });
    
    test('getNextBet con misma secuencia produce mismo resultado', () {
      final advisor1 = MartingaleAdvisor();
      final advisor2 = MartingaleAdvisor();
      
      final sequence = [false, false, true, false];
      
      final bets1 = sequence.map((win) => advisor1.getNextBet(win)).toList();
      final bets2 = sequence.map((win) => advisor2.getNextBet(win)).toList();
      
      expect(bets1, equals(bets2));
    });
  });
  
  group('Idempotencia de RouletteLogic', () {
    test('predictNext con misma historia produce mismo resultado', () {
      final logic = RouletteLogic();
      final history = [12, 35, 3, 26, 12, 35];
      
      final prediction1 = logic.predictNext(history);
      final prediction2 = logic.predictNext(history);
      
      expect(prediction1, equals(prediction2));
    });
  });
}
```

---

## Mejores Prácticas

### 1. Diseño de Scripts

✅ **Hacer:**
- Usar `set -euo pipefail` en scripts Bash
- Verificar condiciones antes de actuar
- Usar flags idempotentes (`mkdir -p`, `cp -n`, etc.)
- Logear acciones realizadas y saltadas
- Usar archivos marcadores (.initialized, .done)

❌ **Evitar:**
- Modificar archivos sin verificar
- Usar operaciones destructivas sin confirmación
- Asumir estado del sistema
- Comandos que fallan si se ejecutan dos veces

### 2. Makefile Targets

✅ **Hacer:**
- Usar `.PHONY` para targets que no generan archivos
- Documentar cada target con comentarios
- Indicar claramente idempotencia y automatización
- Usar dependencias entre targets cuando corresponda
- Hacer targets atómicos y reutilizables

❌ **Evitar:**
- Targets que dependen de estado oculto
- Operaciones no repetibles
- Targets sin documentación

### 3. GitHub Actions

✅ **Hacer:**
- Usar caché para dependencias (`actions/cache`)
- Nombrar artifacts con versión/SHA
- Limpiar estado antes de builds importantes
- Documentar cada job con comentarios
- Usar `workflow_dispatch` para testing manual

❌ **Evitar:**
- Modificar estado compartido
- Asumir estado previo del runner
- Artifacts con nombres fijos (sobreescritura)

### 4. Testing

✅ **Hacer:**
- Crear tests específicos para idempotencia
- Verificar que múltiples ejecuciones = mismo resultado
- Testear con diferentes estados iniciales
- Documentar casos de prueba

❌ **Evitar:**
- Tests que dependen del orden de ejecución
- Tests que modifican estado global
- Asumir estado de fixtures

### 5. Configuración

✅ **Hacer:**
- Usar variables de entorno
- Proporcionar valores por defecto
- Validar configuración al inicio
- Separar configuración de código

❌ **Evitar:**
- Hardcodear valores
- Configuración implícita
- Estado mutable global

---

## Checklist de Verificación

Antes de considerar un componente "idempotente y automatizado", verificar:

- [ ] Se puede ejecutar múltiples veces sin error
- [ ] Produce el mismo resultado en cada ejecución
- [ ] No requiere intervención manual
- [ ] Maneja errores graciosamente
- [ ] Está documentado (qué hace, cómo es idempotente)
- [ ] Tiene tests que verifican idempotencia
- [ ] Usa operaciones atómicas cuando es posible
- [ ] Verifica estado antes de actuar
- [ ] Loggea acciones claramente

---

## Referencias y Recursos

- [Idempotence in APIs](https://restfulapi.net/idempotent-rest-api/)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [GitHub Actions Best Practices](https://docs.github.com/en/actions/learn-github-actions/best-practices-for-workflows)
- [Bash Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

---

**Última actualización**: 2025-11-23  
**Mantenido por**: Equipo Tokyo Predictor Roulette
