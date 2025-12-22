# Organization Standards - Melampe

## 📖 Tabla de Contenidos

- [Introducción](#introducción)
- [Estándares de Código](#estándares-de-código)
- [Testing y Calidad](#testing-y-calidad)
- [Git y Control de Versiones](#git-y-control-de-versiones)
- [Seguridad](#seguridad)
- [Documentación](#documentación)
- [Automatización](#automatización)

---

## 🎯 Introducción

Este documento define los estándares de desarrollo para todos los repositorios de la organización Melampe. El objetivo es mantener consistencia, calidad y mejores prácticas en todo el ecosistema de proyectos.

### Principios Fundamentales

1. **Consistencia**: Mismo estilo en todos los proyectos
2. **Calidad**: Tests y code review obligatorios
3. **Seguridad**: Prioridad en todas las decisiones
4. **Automatización**: Reducir trabajo manual repetitivo
5. **Documentación**: Código auto-documentado y docs claras

---

## 💻 Estándares de Código

### Flutter/Dart

#### Formato y Estilo

```dart
// ✅ BIEN: Usar const cuando sea posible
const Widget myWidget = Text('Hello');

// ✅ BIEN: Documentar funciones públicas
/// Genera un número aleatorio para la ruleta.
/// 
/// Retorna un [int] entre 0 y 36 inclusive.
int generateSpin() {
  return Random.secure().nextInt(37);
}

// ❌ MAL: No usar const
Widget myWidget = Text('Hello');

// ❌ MAL: Función sin documentación
int generateSpin() {
  return Random.secure().nextInt(37);
}
```

#### Comandos

```bash
# Antes de cada commit
dart format .

# Análisis de código
flutter analyze --no-fatal-infos

# Tests
flutter test

# Build
flutter build apk --release
```

#### Convenciones

- **Nombres de archivos**: `snake_case.dart`
- **Nombres de clases**: `PascalCase`
- **Nombres de variables**: `camelCase`
- **Constantes**: `camelCase` con `const` o `final`
- **Privado**: Prefijo `_` (ej: `_privateMethod`)

### Python

#### Formato y Estilo

```python
# ✅ BIEN: Type hints y docstrings
def calculate_bet(balance: float, multiplier: float) -> float:
    """
    Calcula la apuesta basada en el balance y multiplicador.
    
    Args:
        balance: Balance actual del jugador
        multiplier: Multiplicador de la estrategia Martingale
        
    Returns:
        La cantidad a apostar
        
    Raises:
        ValueError: Si balance o multiplier son negativos
    """
    if balance < 0 or multiplier < 0:
        raise ValueError("Balance y multiplier deben ser positivos")
    return balance * multiplier

# ❌ MAL: Sin type hints ni docstrings
def calculate_bet(balance, multiplier):
    return balance * multiplier
```

#### Comandos

```bash
# Formatear con Black
black .

# Linting
pylint **/*.py
flake8

# Type checking
mypy .

# Tests
pytest
pytest --cov=. --cov-report=html
```

#### Convenciones

- **PEP 8**: Seguir estrictamente
- **Líneas**: Máximo 88 caracteres (Black default)
- **Imports**: Organizados (stdlib, third-party, local)
- **Type hints**: Obligatorio en funciones públicas
- **Docstrings**: Estilo Google

### JavaScript/TypeScript

#### Formato y Estilo

```typescript
// ✅ BIEN: TypeScript con tipos explícitos
interface User {
  id: string;
  name: string;
  balance: number;
}

async function getUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  return await response.json();
}

// ❌ MAL: JavaScript sin tipos
async function getUser(id) {
  const response = await fetch(`/api/users/${id}`);
  return await response.json();
}
```

#### Comandos

```bash
# Linting
npm run lint
eslint . --ext .js,.ts,.tsx

# Formatear
npm run format
prettier --write .

# Tests
npm test
npm run test:coverage

# Build
npm run build
```

#### Convenciones

- **Preferir TypeScript** sobre JavaScript
- **async/await** sobre callbacks
- **ESLint**: Configuración estándar
- **Prettier**: Para formateo automático
- **Nombres de archivos**: `kebab-case.ts` o `PascalCase.tsx` (componentes)

---

## 🧪 Testing y Calidad

### Estándares de Testing

#### Cobertura Mínima

- **General**: 70% de cobertura de código
- **Funciones críticas**: 90%+ (pagos, RNG, lógica de negocio)
- **UI Components**: 60%+ (pruebas básicas)

#### Tipos de Tests

```dart
// Test unitario - Flutter/Dart
test('generateSpin returns valid number', () {
  final rng = RouletteLogic();
  final result = rng.generateSpin();
  
  expect(result, greaterThanOrEqualTo(0));
  expect(result, lessThanOrEqualTo(36));
});

// Test de widget
testWidgets('RouletteWheel displays correctly', (tester) async {
  await tester.pumpWidget(const RouletteWheel());
  expect(find.byType(RouletteWheel), findsOneWidget);
});
```

```python
# Test unitario - Python (pytest)
def test_calculate_bet():
    result = calculate_bet(100.0, 2.0)
    assert result == 200.0
    
def test_calculate_bet_negative_raises():
    with pytest.raises(ValueError):
        calculate_bet(-100.0, 2.0)
```

#### Comandos de Testing

```bash
# Flutter/Dart
flutter test
flutter test --coverage

# Python
pytest
pytest --cov=. --cov-report=html

# JavaScript/TypeScript
npm test
npm run test:coverage
```

### Code Quality Tools

#### Linters Configurados

- **Flutter**: `flutter_lints` (en `analysis_options.yaml`)
- **Python**: `pylint`, `flake8`, `mypy`
- **JavaScript/TypeScript**: `eslint`, `prettier`

#### Pre-commit Hooks

```bash
# Instalar pre-commit
pip install pre-commit

# Configurar hooks
pre-commit install

# Ejecutar manualmente
pre-commit run --all-files
```

### Health Agent

Todos los repositorios deben tener configurado el Health Agent:

```bash
# Ejecutar antes de PRs importantes
python scripts/health_agent.py --full-scan

# Ver reporte
cat reports/health_report_*.md
```

**Objetivo**: Health Score > 70/100

---

## 📝 Git y Control de Versiones

### Conventional Commits

Formato obligatorio para commits:

```
tipo(scope): mensaje corto

[cuerpo opcional]

[footer opcional]
```

#### Tipos de Commit

- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Cambios de formato (no afectan código)
- `refactor`: Refactorización de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento

#### Ejemplos

```bash
# Feature
git commit -m "feat(roulette): agregar predicción basada en Martingale"

# Fix
git commit -m "fix(payments): corregir cálculo de balance tras apuesta"

# Docs
git commit -m "docs(readme): actualizar instrucciones de instalación"

# Refactor
git commit -m "refactor(auth): simplificar lógica de autenticación Firebase"
```

### Branching Strategy

```
main
  ├── develop
  │   ├── feature/nueva-funcionalidad
  │   ├── fix/correccion-bug
  │   └── refactor/mejora-codigo
  └── hotfix/bug-critico
```

#### Reglas

1. **main**: Solo código estable y probado
2. **develop**: Integración de features
3. **feature/***: Nuevas funcionalidades
4. **fix/***: Correcciones de bugs
5. **hotfix/***: Fixes urgentes para producción

### Pull Requests

#### Checklist

- [ ] Tests pasan (`flutter test` / `pytest` / `npm test`)
- [ ] Linter sin errores (`flutter analyze` / `pylint` / `eslint`)
- [ ] Código formateado (`dart format` / `black` / `prettier`)
- [ ] Documentación actualizada
- [ ] Sin secretos en el código
- [ ] Health score no baja significativamente

#### Template

```markdown
## Descripción
[Descripción clara de los cambios]

## Tipo de cambio
- [ ] Bug fix
- [ ] Nueva funcionalidad
- [ ] Breaking change
- [ ] Documentación

## Testing
- [ ] Tests unitarios agregados/actualizados
- [ ] Tests manuales realizados

## Screenshots (si aplica)
[Agregar screenshots de cambios UI]

## Issues relacionados
Closes #123
```

---

## 🔒 Seguridad

### Reglas Críticas

#### 1. NUNCA Commitear Secretos

```dart
// ❌ MAL: API key hardcoded
const stripeKey = 'sk_live_1234567890abcdef';

// ✅ BIEN: Usar variables de entorno
const stripeKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
```

#### 2. Usar Random.secure() para RNG

```dart
// ❌ MAL: Random predecible
final rng = Random();

// ✅ BIEN: Random criptográficamente seguro
final rng = Random.secure();
```

#### 3. Validar Todas las Entradas

```dart
// ✅ BIEN: Validación de input
void updateBet(String input) {
  final bet = double.tryParse(input);
  if (bet == null || bet <= 0 || bet > maxBet) {
    throw ArgumentError('Invalid bet amount');
  }
  _currentBet = bet;
}
```

#### 4. Sanitizar Datos

```dart
// Para HTML
import 'package:html_escape/html_escape.dart';
final escaped = HtmlEscape().convert(userInput);
```

### Security Scanning

```bash
# Antes de cada release
./scripts/security_scanner.sh

# O manual
flutter pub audit
npm audit
pip-audit
```

### Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // ❌ MAL: Acceso sin restricciones
    match /{document=**} {
      allow read, write: if true;
    }
    
    // ✅ BIEN: Acceso controlado
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

---

## 📚 Documentación

### Documentación Obligatoria

#### README.md

Cada repositorio debe tener:

```markdown
# Nombre del Proyecto

## Descripción
[Descripción clara del proyecto]

## Instalación
[Pasos para instalar]

## Uso
[Ejemplos de uso]

## Testing
[Cómo ejecutar tests]

## Contribuir
[Link a CONTRIBUTING.md]

## Licencia
[Información de licencia]
```

#### CONTRIBUTING.md

Guía para contribuir:
- Cómo reportar bugs
- Cómo sugerir features
- Proceso de PR
- Estándares de código

#### Código Auto-documentado

```dart
// ✅ BIEN: Código claro que se explica solo
class BettingStrategy {
  final double minimumBet;
  final double maximumBet;
  
  double calculateNextBet(double currentBet, bool won) {
    if (won) {
      return minimumBet;
    }
    return min(currentBet * 2, maximumBet);
  }
}

// Comentarios solo cuando sea necesario
/// Implementa la estrategia de Martingale.
/// 
/// Esta estrategia dobla la apuesta después de cada pérdida
/// y vuelve a la apuesta mínima después de una victoria.
```

### Docs Directory

```
docs/
├── ARCHITECTURE.md        # Arquitectura del sistema
├── API.md                 # Documentación de API
├── USER_GUIDE.md          # Guía de usuario
├── COPILOT_SETUP.md       # Setup de Copilot
└── ORGANIZATION_STANDARDS.md  # Este archivo
```

---

## 🤖 Automatización

### Bots y Agentes

Todos los repositorios deben tener:

#### Health Agent

```bash
# Configurar
cp .project-health.yml.example .project-health.yml

# Ejecutar
python scripts/health_agent.py --full-scan
```

#### GitHub Actions

Workflows mínimos requeridos:

1. **CI** (`.github/workflows/ci.yml`):
   - Linting
   - Testing
   - Build

2. **Release** (`.github/workflows/release.yml`):
   - Build de producción
   - Security scan
   - Deploy

3. **Health Check** (`.github/workflows/project-health-check.yml`):
   - Ejecución semanal
   - Reporte de salud

### Scripts de Automatización

```bash
scripts/
├── health_agent.py          # Health check
├── security_scanner.sh      # Security scan
├── release_builder.sh       # Build releases
├── run_tests.sh            # Ejecutar tests
└── pre_commit.sh           # Pre-commit checks
```

### Pre-commit Hooks

Configurar en `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: format
        name: Format code
        entry: dart format .
        language: system
        pass_filenames: false
      
      - id: analyze
        name: Analyze code
        entry: flutter analyze
        language: system
        pass_filenames: false
```

---

## 🔄 Mantenimiento

### Actualización de Dependencias

```bash
# Flutter
flutter pub upgrade
flutter pub outdated

# Python
pip list --outdated
pip install --upgrade <package>

# JavaScript
npm outdated
npm update
```

### Revisión Semanal

Checklist semanal:

- [ ] Ejecutar Health Agent
- [ ] Revisar issues abiertos
- [ ] Actualizar dependencias outdated
- [ ] Revisar PRs pendientes
- [ ] Ejecutar security scan

---

## 📊 Métricas y KPIs

### Objetivos de Calidad

| Métrica | Objetivo | Crítico |
|---------|----------|---------|
| Health Score | > 70 | > 50 |
| Test Coverage | > 70% | > 50% |
| Build Success | > 95% | > 80% |
| PR Review Time | < 48h | < 72h |
| Security Vulnerabilities | 0 high/critical | < 3 |

---

## 🆘 Recursos

### Links Útiles

- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

### Contacto

**Organización**: Melampe  
**Maintainer**: @Melampe001  
**Issues**: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)

---

_Última actualización: Diciembre 2024_  
_Versión: 1.0_
