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
