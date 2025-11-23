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
