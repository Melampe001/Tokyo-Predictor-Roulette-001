#!/usr/bin/env bash
# scripts/config/fixtures/setup_test_data.sh
# Configura datos de prueba de forma idempotente
# Puede ejecutarse múltiples veces sin causar errores

set -euo pipefail

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

# Directorio de fixtures
FIXTURE_DIR="test/fixtures"
MARKER_FILE="${FIXTURE_DIR}/.initialized"

# ============================================
# Crear directorio de fixtures (idempotente)
# ============================================
log_info "Verificando directorio de fixtures..."
mkdir -p "$FIXTURE_DIR"

# ============================================
# Verificar si ya se inicializó (idempotencia)
# ============================================
if [ -f "$MARKER_FILE" ]; then
    log_skip "Fixtures ya inicializados previamente."
    log_info "Para reinicializar, elimina: $MARKER_FILE"
    exit 0
fi

log_info "Inicializando fixtures de prueba..."

# ============================================
# Crear datos de prueba de giros de ruleta
# ============================================
log_info "Creando test_spins.json..."
cat > "${FIXTURE_DIR}/test_spins.json" << 'EOF'
{
  "description": "Datos de prueba para simulaciones de ruleta",
  "wheel_type": "european",
  "total_numbers": 37,
  "spins": [
    12, 35, 3, 26, 0, 32, 15, 19, 4, 21,
    2, 25, 17, 34, 6, 27, 13, 36, 11, 30,
    8, 23, 10, 5, 24, 16, 33, 1, 20, 14,
    31, 9, 22, 18, 29, 7, 28, 12, 35, 3
  ],
  "metadata": {
    "generated_by": "setup_test_data.sh",
    "date": "2025-11-23",
    "purpose": "Testing idempotent roulette logic"
  }
}
EOF

# ============================================
# Crear configuración de prueba
# ============================================
log_info "Creando test_config.json..."
cat > "${FIXTURE_DIR}/test_config.json" << 'EOF'
{
  "description": "Configuración de prueba para la aplicación",
  "betting": {
    "base_bet": 1.0,
    "min_bet": 0.5,
    "max_bet": 100.0,
    "currency": "USD"
  },
  "martingale": {
    "enabled": true,
    "max_multiplier": 64,
    "reset_on_win": true
  },
  "roulette": {
    "wheel_type": "european",
    "animation_duration_ms": 3000,
    "auto_spin": false
  },
  "limits": {
    "max_history": 100,
    "free_spins": 10,
    "premium_spins": -1
  }
}
EOF

# ============================================
# Crear datos de usuario de prueba
# ============================================
log_info "Creando test_users.json..."
cat > "${FIXTURE_DIR}/test_users.json" << 'EOF'
{
  "description": "Usuarios de prueba para testing",
  "users": [
    {
      "id": "user_001",
      "email": "test.free@example.com",
      "subscription": "free",
      "credits": 10,
      "created_at": "2025-01-01T00:00:00Z"
    },
    {
      "id": "user_002",
      "email": "test.premium@example.com",
      "subscription": "premium",
      "credits": -1,
      "created_at": "2025-01-01T00:00:00Z"
    },
    {
      "id": "user_003",
      "email": "test.expired@example.com",
      "subscription": "expired",
      "credits": 0,
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
EOF

# ============================================
# Crear datos de estrategias Martingale
# ============================================
log_info "Creando test_martingale_sequences.json..."
cat > "${FIXTURE_DIR}/test_martingale_sequences.json" << 'EOF'
{
  "description": "Secuencias de prueba para estrategia Martingale",
  "sequences": [
    {
      "name": "winning_streak",
      "base_bet": 1.0,
      "outcomes": [true, true, true, true],
      "expected_bets": [1.0, 1.0, 1.0, 1.0],
      "expected_final_bet": 1.0
    },
    {
      "name": "losing_streak",
      "base_bet": 1.0,
      "outcomes": [false, false, false, false],
      "expected_bets": [1.0, 2.0, 4.0, 8.0],
      "expected_final_bet": 16.0
    },
    {
      "name": "alternating",
      "base_bet": 1.0,
      "outcomes": [false, true, false, true],
      "expected_bets": [1.0, 2.0, 1.0, 2.0],
      "expected_final_bet": 1.0
    },
    {
      "name": "recovery",
      "base_bet": 2.0,
      "outcomes": [false, false, false, true],
      "expected_bets": [2.0, 4.0, 8.0, 16.0],
      "expected_final_bet": 2.0
    }
  ]
}
EOF

# ============================================
# Crear README para fixtures
# ============================================
log_info "Creando README.md en fixtures..."
cat > "${FIXTURE_DIR}/README.md" << 'EOF'
# Test Fixtures

Este directorio contiene datos de prueba idempotentes para el proyecto.

## Archivos

### `test_spins.json`
Secuencias de giros de ruleta para testing.
- 40 giros de prueba predefinidos
- Ruleta europea (0-36)
- Usado en tests de predicción y estadísticas

### `test_config.json`
Configuración de prueba de la aplicación.
- Parámetros de apuestas
- Configuración Martingale
- Límites de usuario

### `test_users.json`
Perfiles de usuario de prueba.
- Usuario gratuito (10 créditos)
- Usuario premium (ilimitado)
- Usuario expirado (0 créditos)

### `test_martingale_sequences.json`
Secuencias de prueba para validar la lógica Martingale.
- Rachas ganadoras
- Rachas perdedoras
- Patrones alternados
- Recuperación de pérdidas

## Uso

```dart
import 'dart:convert';
import 'dart:io';

// Cargar fixture
final file = File('test/fixtures/test_spins.json');
final data = jsonDecode(file.readAsStringSync());
final spins = List<int>.from(data['spins']);
```

## Reinicialización

Para reinicializar los fixtures:
```bash
rm test/fixtures/.initialized
bash scripts/config/fixtures/setup_test_data.sh
```

## Idempotencia

Este script es **idempotente**:
- Primera ejecución: Crea todos los archivos
- Ejecuciones subsiguientes: Salta (archivos ya existen)
- El archivo `.initialized` marca la inicialización completada
EOF

# ============================================
# Marcar como inicializado
# ============================================
log_info "Marcando fixtures como inicializados..."
cat > "$MARKER_FILE" << EOF
# Fixtures initialized on: $(date)
# To reinitialize, delete this file and run setup_test_data.sh again
initialized_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
script_version=1.0.0
EOF

log_info "✓ Fixtures de prueba inicializados correctamente."
log_info ""
log_info "Archivos creados:"
log_info "  - ${FIXTURE_DIR}/test_spins.json"
log_info "  - ${FIXTURE_DIR}/test_config.json"
log_info "  - ${FIXTURE_DIR}/test_users.json"
log_info "  - ${FIXTURE_DIR}/test_martingale_sequences.json"
log_info "  - ${FIXTURE_DIR}/README.md"
log_info ""
log_info "Marcador de inicialización: ${MARKER_FILE}"
echo ""
