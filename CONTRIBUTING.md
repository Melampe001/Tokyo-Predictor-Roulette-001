# Guía de Contribución

¡Gracias por tu interés en contribuir a Tokyo Roulette Predicciones! Este documento te guiará a través del proceso de contribución.

## Código de Conducta

Al participar en este proyecto, te comprometes a mantener un ambiente respetuoso y acogedor para todos. Se espera:

- Usar lenguaje inclusivo y respetuoso
- Respetar diferentes puntos de vista y experiencias
- Aceptar críticas constructivas con gracia
- Enfocarse en lo mejor para la comunidad
- Mostrar empatía hacia otros miembros

## ¿Cómo Puedo Contribuir?

### Reportar Bugs

Si encuentras un bug, por favor abre un issue con:

1. **Título claro y descriptivo**
2. **Pasos para reproducir**
   ```
   1. Abre la app
   2. Ve a configuración
   3. Activa Martingale
   4. Gira la ruleta 5 veces
   5. Observa el error...
   ```
3. **Comportamiento esperado**: Qué debería suceder
4. **Comportamiento actual**: Qué sucede realmente
5. **Capturas de pantalla** (si aplica)
6. **Información del sistema**:
   - Dispositivo: (ej: Samsung Galaxy S21)
   - OS: (ej: Android 13)
   - Versión de la app: (ej: 1.0.0)

### Sugerir Mejoras

Las sugerencias son bienvenidas. Abre un issue con:

1. **Descripción detallada** de la mejora
2. **Motivación**: Por qué es útil esta mejora
3. **Alternativas consideradas**: Otras formas de lograr lo mismo
4. **Mockups o diseños** (si aplica)

### Pull Requests

#### Antes de Empezar

1. **Busca issues existentes** relacionados
2. **Comenta en el issue** que planeas trabajar en él
3. **Espera confirmación** de un maintainer
4. **Fork el repositorio**

#### Proceso de Desarrollo

1. **Crea una rama** desde `main`:
   ```bash
   git checkout -b feature/nombre-descriptivo
   # o
   git checkout -b fix/descripcion-del-bug
   ```

2. **Configura tu entorno**:
   ```bash
   flutter pub get
   flutter pub run build_runner build  # Si usas generadores de código
   ```

3. **Realiza tus cambios**:
   - Sigue las convenciones de código del proyecto
   - Escribe código limpio y legible
   - Comenta código complejo o no obvio

4. **Escribe tests**:
   ```bash
   # Tests unitarios
   flutter test test/roulette_logic_test.dart
   
   # Tests de widgets
   flutter test test/widget_test.dart
   ```

5. **Ejecuta el linter**:
   ```bash
   flutter analyze
   ```

6. **Formatea el código**:
   ```bash
   dart format lib/ test/
   ```

7. **Commit tus cambios**:
   ```bash
   git add .
   git commit -m "feat: añade función X"
   ```
   
   Sigue [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` Nueva característica
   - `fix:` Corrección de bug
   - `docs:` Cambios en documentación
   - `style:` Formateo, puntos y coma faltantes, etc.
   - `refactor:` Refactorización de código
   - `test:` Añadir o corregir tests
   - `chore:` Actualizar dependencias, configuración, etc.

8. **Push tu rama**:
   ```bash
   git push origin feature/nombre-descriptivo
   ```

9. **Abre un Pull Request** en GitHub

#### Checklist del Pull Request

Tu PR debe incluir:

- [ ] **Título descriptivo** siguiendo Conventional Commits
- [ ] **Descripción completa**:
  - ¿Qué cambia este PR?
  - ¿Por qué es necesario?
  - ¿Cómo se probó?
- [ ] **Tests añadidos/actualizados**
- [ ] **Documentación actualizada** (si aplica)
- [ ] **Screenshots** (para cambios de UI)
- [ ] **Sin conflictos** con `main`
- [ ] **CI pasando** (build, tests, lint)

#### Revisión de Código

Los maintainers revisarán tu PR y pueden:

- **Aprobar**: Tu código será mergeado
- **Solicitar cambios**: Responde a los comentarios y actualiza el PR
- **Cerrar**: Si el PR no se alinea con los objetivos del proyecto

#### Después del Merge

1. **Elimina tu rama**:
   ```bash
   git branch -d feature/nombre-descriptivo
   git push origin --delete feature/nombre-descriptivo
   ```

2. **Actualiza tu fork**:
   ```bash
   git checkout main
   git pull upstream main
   git push origin main
   ```

## Convenciones de Código

### Dart/Flutter

#### Nomenclatura

```dart
// Clases: PascalCase
class RouletteLogic {}

// Métodos y variables: camelCase
int generateSpin() {}
double currentBet = 10.0;

// Constantes: camelCase
const double minBet = 1.0;

// Privados: _prefix
void _updateBalance() {}

// Archivos: snake_case
// roulette_logic.dart
// martingale_advisor.dart
```

#### Formato

```dart
// Comillas simples para strings
final String name = 'Tokyo Roulette';

// Trailing commas en listas de parámetros
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Hello'),
      Text('World'),
    ], // <-- trailing comma
  );
}

// Evitar líneas muy largas (máximo 80-100 caracteres)
// Usar saltos de línea apropiados
final message = 'Este es un mensaje muy largo que debe '
    'dividirse en múltiples líneas para mejor legibilidad';

// const donde sea posible
const Text('Static text');

// final para valores que no cambiarán
final rouletteLogic = RouletteLogic();
```

#### Comentarios

```dart
/// Genera un número aleatorio de la ruleta usando RNG seguro.
///
/// Retorna un entero entre 0 y 36, inclusive, representando
/// los números de una ruleta europea estándar.
///
/// Ejemplo:
/// ```dart
/// final logic = RouletteLogic();
/// final number = logic.generateSpin(); // puede ser 0-36
/// ```
int generateSpin() {
  return wheel[rng.nextInt(wheel.length)];
}

// TODO: Implementar persistencia con SharedPreferences
// FIXME: Corregir desbordamiento en cálculo de balance
// NOTE: Este algoritmo es O(n^2), considerar optimizar
```

### Estructura de Archivos

```
lib/
├── main.dart                 # Punto de entrada
├── screens/                  # Pantallas completas
│   ├── login_screen.dart
│   └── main_screen.dart
├── widgets/                  # Widgets reutilizables
│   ├── roulette_wheel.dart
│   └── bet_display.dart
├── logic/                    # Lógica de negocio
│   ├── roulette_logic.dart
│   └── martingale_advisor.dart
├── models/                   # Modelos de datos
│   └── game_state.dart
├── services/                 # Servicios externos
│   ├── firebase_service.dart
│   └── storage_service.dart
└── utils/                    # Utilidades
    ├── constants.dart
    └── helpers.dart
```

### Tests

```dart
// Nombrar tests descriptivamente
test('generateSpin devuelve un número válido entre 0 y 36', () {
  // Arrange (Preparar)
  final roulette = RouletteLogic();
  
  // Act (Actuar)
  final result = roulette.generateSpin();
  
  // Assert (Verificar)
  expect(result, greaterThanOrEqualTo(0));
  expect(result, lessThanOrEqualTo(36));
});

// Agrupar tests relacionados
group('MartingaleAdvisor', () {
  late MartingaleAdvisor advisor;

  setUp(() {
    advisor = MartingaleAdvisor();
  });

  test('duplica la apuesta después de perder', () {
    // ...
  });

  test('vuelve a la apuesta base después de ganar', () {
    // ...
  });
});
```

## Arquitectura

### Principios

1. **Separation of Concerns**: Separa UI, lógica y datos
2. **Single Responsibility**: Cada clase tiene una responsabilidad clara
3. **DRY (Don't Repeat Yourself)**: Evita duplicación de código
4. **KISS (Keep It Simple, Stupid)**: Prefiere soluciones simples
5. **YAGNI (You Aren't Gonna Need It)**: No agregues funcionalidad prematuramente

### Patrones Recomendados

- **StatefulWidget + setState** para widgets simples
- **Provider/Riverpod** si necesitas gestión de estado compleja
- **Repository Pattern** para acceso a datos
- **Dependency Injection** para testabilidad

## Flujo de Git

### Ramas

- `main`: Código de producción estable
- `develop`: Rama de desarrollo (si se usa)
- `feature/*`: Nuevas características
- `fix/*`: Correcciones de bugs
- `hotfix/*`: Correcciones urgentes de producción
- `release/*`: Preparación de releases

### Commits

#### Buenos Commits

```bash
feat: añade visualización de historial con colores
fix: corrige cálculo de balance en Martingale
docs: actualiza README con instrucciones de instalación
test: añade tests para RouletteLogic.predictNext()
refactor: extrae lógica de colores a método separado
```

#### Commits a Evitar

```bash
# ❌ Demasiado vago
git commit -m "update"
git commit -m "fix"
git commit -m "changes"

# ❌ Demasiado largo para título
git commit -m "Añade nueva funcionalidad de historial que muestra..."

# ❌ Múltiples cambios no relacionados
git commit -m "fix login, add stats, update readme"
```

#### Commits Atómicos

Cada commit debe ser:
- **Autocontenido**: Funciona por sí mismo
- **Reversible**: Se puede revertir sin romper nada
- **Lógico**: Agrupa cambios relacionados

## Seguridad

### Prácticas Obligatorias

1. **Nunca commitear secrets**:
   ```dart
   // ❌ MALO
   const apiKey = 'sk_live_1234567890abcdef';
   
   // ✅ BUENO
   const apiKey = String.fromEnvironment('API_KEY');
   ```

2. **Validar inputs del usuario**:
   ```dart
   void updateBet(String input) {
     final bet = double.tryParse(input);
     if (bet == null || bet <= 0) {
       throw ArgumentError('Apuesta inválida');
     }
     // ...
   }
   ```

3. **Sanitizar datos antes de mostrar**:
   ```dart
   // Escapar HTML si se muestra en WebView
   final safe = HtmlEscape().convert(userInput);
   ```

4. **Usar RNG seguro**:
   ```dart
   // ✅ BUENO
   final rng = Random.secure();
   
   // ❌ MALO para juegos
   final rng = Random();
   ```

### Reportar Vulnerabilidades

Si encuentras una vulnerabilidad de seguridad:

1. **NO abras un issue público**
2. **Envía un email** a los maintainers
3. **Describe** el problema y el impacto
4. **Espera respuesta** antes de divulgar

## Recursos

### Documentación del Proyecto

- [README.md](../README.md) - Inicio rápido
- [USER_GUIDE.md](USER_GUIDE.md) - Guía de usuario
- [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitectura técnica
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Configuración de Firebase

### Flutter/Dart

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

### Git

- [Pro Git Book](https://git-scm.com/book/en/v2)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

## Preguntas Frecuentes

### ¿Cuánto tiempo tarda la revisión de un PR?

Típicamente 2-5 días hábiles. PRs urgentes se revisan más rápido.

### ¿Puedo trabajar en múltiples issues simultáneamente?

Es mejor enfocarse en uno a la vez para evitar conflictos.

### ¿Qué hago si mi PR tiene conflictos?

```bash
git checkout main
git pull upstream main
git checkout tu-rama
git rebase main
# Resuelve conflictos
git add .
git rebase --continue
git push --force-with-lease
```

### ¿Cómo ejecuto tests localmente?

```bash
# Todos los tests
flutter test

# Test específico
flutter test test/roulette_logic_test.dart

# Con cobertura
flutter test --coverage
```

### ¿Necesito firmar mis commits?

No es obligatorio, pero se recomienda:

```bash
git config --global user.signingkey TU_KEY_ID
git config --global commit.gpgsign true
```

## Reconocimientos

Los contribuidores son reconocidos en:

1. **README.md** - Sección de Contributors
2. **Commits** - Autoría en Git
3. **Releases** - Notas de versión

## Licencia

Al contribuir, aceptas que tus contribuciones se licenciarán bajo la misma licencia que el proyecto.

---

¡Gracias por contribuir a Tokyo Roulette Predicciones! 🎰✨
