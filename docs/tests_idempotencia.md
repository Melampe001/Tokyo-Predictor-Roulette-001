# Pruebas de Idempotencia

Este documento describe las pruebas implementadas para verificar la idempotencia y automatización del proyecto Tokyo Predictor Roulette.

## Contenido

1. [Introducción](#introducción)
2. [Estructura de Tests](#estructura-de-tests)
3. [Tests en Go](#tests-en-go)
4. [Tests en Dart/Flutter](#tests-en-dartflutter)
5. [Ejecutar Tests](#ejecutar-tests)
6. [Interpretar Resultados](#interpretar-resultados)
7. [Añadir Nuevos Tests](#añadir-nuevos-tests)

---

## Introducción

### ¿Por qué probar la idempotencia?

Las pruebas de idempotencia verifican que:
- Las operaciones pueden ejecutarse múltiples veces sin errores
- El resultado es consistente entre ejecuciones
- No hay efectos secundarios no deseados
- Los scripts y configuraciones son robustos

### Tipos de Pruebas

1. **Tests de Scripts**: Verifican que los scripts Bash sean idempotentes
2. **Tests de Funciones**: Verifican que las funciones de código sean idempotentes
3. **Tests de Configuración**: Verifican que la configuración sea repetible
4. **Tests de Makefile**: Verifican que los targets sean idempotentes

---

## Estructura de Tests

```
testing/
├── idempotence_test.go      # Tests de idempotencia en Go
├── go.mod                    # Módulo Go
└── README.md                 # Este archivo

test/
├── widget_test.dart          # Tests de widgets Flutter
├── idempotence_test.dart     # Tests de idempotencia en Dart
└── fixtures/                 # Datos de prueba
    ├── test_spins.json
    ├── test_config.json
    └── test_users.json
```

---

## Tests en Go

### Ubicación
`testing/idempotence_test.go`

### Tests Implementados

#### 1. TestScriptIdempotence
Verifica que los scripts de configuración sean idempotentes.

**¿Qué prueba?**
- Ejecuta cada script 3 veces consecutivas
- Verifica que ninguna ejecución falle
- Confirma que las ejecuciones subsiguientes no causan errores

**Scripts probados:**
- `scripts/config/setup_env.sh`
- `scripts/config/fixtures/setup_test_data.sh`

**Ejemplo de uso:**
```bash
cd testing
go test -v -run TestScriptIdempotence
```

**Output esperado:**
```
=== RUN   TestScriptIdempotence
=== RUN   TestScriptIdempotence/setup_env.sh
    idempotence_test.go:35: Probando idempotencia de: Script de configuración del entorno
    idempotence_test.go:38: Ejecutando script (primera vez)...
    idempotence_test.go:45: Primera ejecución completada exitosamente
    idempotence_test.go:48: Ejecutando script (segunda vez)...
    idempotence_test.go:55: Segunda ejecución completada exitosamente
    idempotence_test.go:71: ✓ Script setup_env.sh es idempotente
--- PASS: TestScriptIdempotence (2.34s)
```

#### 2. TestDirectoryCreation
Verifica que `os.MkdirAll` es idempotente (creación de directorios).

**¿Qué prueba?**
- Crea un directorio
- Intenta crearlo de nuevo
- Verifica que no hay error

**Ejemplo:**
```go
// Primera creación
err1 := os.MkdirAll(testDir, 0755)

// Segunda creación (idempotente)
err2 := os.MkdirAll(testDir, 0755)

// Ambas deben tener éxito
```

#### 3. TestFileCreation
Verifica patrones idempotentes de creación de archivos.

**¿Qué prueba?**
- Crea un archivo solo si no existe
- Ejecuta la operación múltiples veces
- Verifica que el contenido no cambia

**Patrón idempotente:**
```go
createFileIdempotent := func(path, data string) error {
    // Solo crear si no existe
    if _, err := os.Stat(path); os.IsNotExist(err) {
        return os.WriteFile(path, []byte(data), 0644)
    }
    return nil
}
```

#### 4. TestConfigurationIdempotence
Verifica que aplicar la misma configuración múltiples veces es idempotente.

**¿Qué prueba?**
- Aplica configuración con un valor
- Reaplica con el mismo valor
- Verifica que el estado no cambia en reaplicaciones

**Ejemplo:**
```go
applyConfig := func(c *Config, newValue string) {
    // Solo aplicar si es diferente
    if c.Value != newValue {
        c.Value = newValue
        c.Count++
    }
}

applyConfig(config, "configured")  // Aplicar
applyConfig(config, "configured")  // Idempotente: no cambia
applyConfig(config, "configured")  // Idempotente: no cambia
```

#### 5. TestMakefileTargetsIdempotence
Verifica que los targets del Makefile declarados como idempotentes lo sean.

**¿Qué prueba?**
- Ejecuta targets como `clean`, `format`, `lint`, `help`
- Los ejecuta dos veces
- Verifica que no hay errores

**Targets probados:**
- `clean` - Limpiar artifacts
- `format` - Formatear código
- `lint` - Análisis estático
- `help` - Mostrar ayuda
- `doctor` - Verificar instalación

#### 6. TestIdempotenceDocumentation
Verifica que existe la documentación de idempotencia.

**¿Qué prueba?**
- Verifica que `docs/idempotencia_automatizacion.md` existe
- Comprueba que contiene secciones clave
- Valida la completitud de la documentación

**Secciones requeridas:**
- Idempotencia
- Automatización
- Makefile
- Scripts
- GitHub Actions
- Pruebas

#### 7. BenchmarkIdempotentOperation
Mide el rendimiento de operaciones idempotentes.

**¿Qué mide?**
- Tiempo de creación de directorios (idempotente)
- Tiempo de creación de archivos (idempotente)

**Ejecutar benchmarks:**
```bash
cd testing
go test -bench=. -benchmem
```

**Output esperado:**
```
BenchmarkIdempotentOperation/DirectoryCreation-8    1000000    1234 ns/op
BenchmarkIdempotentOperation/FileCreation-8          500000    2345 ns/op
```

---

## Tests en Dart/Flutter

### Ubicación
`test/idempotence_test.dart`

### Tests Implementados

#### 1. Test de MartingaleAdvisor.reset()

**¿Qué prueba?**
```dart
test('reset() es idempotente', () {
  final advisor = MartingaleAdvisor();
  
  // Modificar estado
  advisor.getNextBet(false);  // Duplicar apuesta
  advisor.getNextBet(false);  // Duplicar de nuevo
  
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
```

**Verifica:**
- `reset()` siempre retorna al estado base
- Múltiples llamadas a `reset()` producen el mismo resultado

#### 2. Test de getNextBet con misma secuencia

**¿Qué prueba?**
```dart
test('getNextBet con misma secuencia produce mismo resultado', () {
  final advisor1 = MartingaleAdvisor();
  final advisor2 = MartingaleAdvisor();
  
  final sequence = [false, false, true, false];
  
  final bets1 = sequence.map((win) => advisor1.getNextBet(win)).toList();
  final bets2 = sequence.map((win) => advisor2.getNextBet(win)).toList();
  
  expect(bets1, equals(bets2));
});
```

**Verifica:**
- La misma secuencia de resultados produce las mismas apuestas
- El algoritmo es determinístico

#### 3. Test de RouletteLogic.predictNext()

**¿Qué prueba?**
```dart
test('predictNext con misma historia produce mismo resultado', () {
  final logic = RouletteLogic();
  final history = [12, 35, 3, 26, 12, 35];
  
  final prediction1 = logic.predictNext(history);
  final prediction2 = logic.predictNext(history);
  
  expect(prediction1, equals(prediction2));
});
```

**Verifica:**
- La predicción es determinística para el mismo historial
- No hay estado oculto que afecte resultados

### Ejecutar Tests Flutter

```bash
# Todos los tests
flutter test

# Solo tests de idempotencia
flutter test test/idempotence_test.dart

# Con verbose output
flutter test --verbose

# Con cobertura
flutter test --coverage
```

---

## Ejecutar Tests

### Todos los Tests (Make)

```bash
# Ejecutar todos los tests (Flutter + Go)
make test

# Solo linting y tests
make ci

# Con cobertura
make test-coverage
```

### Solo Tests Go

```bash
cd testing

# Ejecutar todos los tests
go test -v ./...

# Test específico
go test -v -run TestScriptIdempotence

# Con timeout (scripts pueden tardar)
go test -v -timeout 5m ./...

# Benchmarks
go test -bench=. -benchmem
```

### Solo Tests Flutter

```bash
# Todos los tests
flutter test

# Test específico
flutter test test/idempotence_test.dart

# Con cobertura
flutter test --coverage

# Test de integración
flutter test integration_test/
```

### Verificación de Idempotencia de Makefile

```bash
# Usar el target específico
make verify-idempotence

# O manualmente
make clean && make clean  # Debe funcionar sin error
make format && make format  # Debe funcionar sin error
```

---

## Interpretar Resultados

### Tests Exitosos

#### Go Tests
```
=== RUN   TestScriptIdempotence
=== RUN   TestScriptIdempotence/setup_env.sh
    idempotence_test.go:71: ✓ Script setup_env.sh es idempotente
--- PASS: TestScriptIdempotence (2.34s)
PASS
ok      github.com/Melampe001/Tokyo-Predictor-Roulette-001/testing    2.450s
```

**Interpretación:**
- ✅ `PASS` = Test exitoso
- ✅ `✓` = Operación idempotente verificada
- ⏱️ Tiempo razonable (< 5s por test)

#### Flutter Tests
```
00:03 +1: Idempotencia de MartingaleAdvisor reset() es idempotente
00:04 +2: Idempotencia de MartingaleAdvisor getNextBet con misma secuencia produce mismo resultado
00:05 +3: All tests passed!
```

**Interpretación:**
- ✅ `+N` = N tests pasados
- ✅ `All tests passed!` = Suite completa exitosa

### Tests Fallidos

#### Ejemplo de Fallo
```
--- FAIL: TestScriptIdempotence/setup_env.sh (1.23s)
    idempotence_test.go:42: Segunda ejecución falló: exit status 1
    idempotence_test.go:43: Output segunda ejecución:
    Error: File already exists and differs
FAIL
```

**Causas comunes:**
1. Script no es idempotente (crea archivos sin verificar)
2. Script asume estado limpio
3. Script no maneja archivos existentes

**Solución:**
- Revisar script
- Añadir verificación antes de crear/modificar
- Usar operaciones idempotentes (`mkdir -p`, etc.)

---

## Añadir Nuevos Tests

### Añadir Test Go

1. Abrir `testing/idempotence_test.go`
2. Añadir nueva función de test:

```go
func TestMyNewIdempotentOperation(t *testing.T) {
	// Ejecutar operación primera vez
	result1 := myIdempotentFunction()
	
	// Ejecutar operación segunda vez
	result2 := myIdempotentFunction()
	
	// Verificar que resultados son iguales
	if result1 != result2 {
		t.Errorf("Operación no es idempotente: %v != %v", result1, result2)
	}
	
	t.Log("✓ myIdempotentFunction es idempotente")
}
```

3. Ejecutar:
```bash
cd testing && go test -v -run TestMyNewIdempotentOperation
```

### Añadir Test Dart

1. Editar `test/idempotence_test.dart`
2. Añadir test en grupo apropiado:

```dart
test('mi nueva operación es idempotente', () {
  final resultado1 = miOperacionIdempotente();
  final resultado2 = miOperacionIdempotente();
  
  expect(resultado1, equals(resultado2));
});
```

3. Ejecutar:
```bash
flutter test test/idempotence_test.dart
```

### Mejores Prácticas para Tests de Idempotencia

✅ **Hacer:**
- Ejecutar operación al menos 2-3 veces
- Verificar que el resultado es consistente
- Verificar que no hay errores en ejecuciones subsiguientes
- Usar datos de prueba conocidos (fixtures)
- Limpiar estado después del test (`t.TempDir()` en Go)

❌ **Evitar:**
- Asumir estado inicial específico
- Modificar estado global
- Tests que dependen del orden de ejecución
- Hardcodear paths absolutos

---

## Checklist de Nuevos Tests

Antes de añadir un test de idempotencia, verificar:

- [ ] El test ejecuta la operación al menos 2 veces
- [ ] El test verifica que los resultados son idénticos
- [ ] El test no depende de estado previo
- [ ] El test limpia su propio estado (usa directorios temporales)
- [ ] El test está documentado (comentarios descriptivos)
- [ ] El test puede ejecutarse solo (`go test -run TestName`)
- [ ] El test puede ejecutarse múltiples veces sin fallar

---

## Recursos

- [Testing en Go](https://golang.org/pkg/testing/)
- [Flutter Testing](https://flutter.dev/docs/testing)
- [Idempotence Wikipedia](https://en.wikipedia.org/wiki/Idempotence)
- [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)

---

## Métricas de Cobertura

### Objetivo
- **Cobertura de scripts**: 100% (todos los scripts probados)
- **Cobertura de código Dart**: >80%
- **Cobertura de targets Makefile idempotentes**: 100%

### Verificar Cobertura

```bash
# Flutter
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Go (requiere herramientas adicionales)
cd testing
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

---

**Última actualización**: 2025-11-23  
**Mantenido por**: Equipo Tokyo Predictor Roulette
