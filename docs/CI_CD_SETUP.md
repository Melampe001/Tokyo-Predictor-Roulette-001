# ⚙️ Configuración de CI/CD - Tokyo Roulette Predictor

Este documento describe cómo configurar y usar el sistema de CI/CD con GitHub Actions.

## 📋 Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Workflows Disponibles](#workflows-disponibles)
3. [Configuración de Secretos](#configuración-de-secretos)
4. [Uso de Workflows](#uso-de-workflows)
5. [Troubleshooting](#troubleshooting)

---

## Visión General

El proyecto incluye tres workflows principales de GitHub Actions:

1. **CI (Continuous Integration)** - `.github/workflows/ci.yml`
   - Se ejecuta en cada push y PR
   - Lint, tests, build debug, seguridad
   
2. **Release** - `.github/workflows/release.yml`
   - Se ejecuta al crear tags v*.*.*
   - Build release firmado, crear GitHub Release
   
3. **PR Checks** - `.github/workflows/pr-checks.yml`
   - Se ejecuta en Pull Requests
   - Validaciones específicas de PR con comentarios automáticos

---

## Workflows Disponibles

### 1. CI - Continuous Integration

**Trigger**: Push y Pull Request a main/master/develop

**Jobs**:
- ✅ **Lint**: Análisis de código y formato
- ✅ **Test**: Tests unitarios con coverage
- ✅ **Build Debug**: Compilar APK debug
- ✅ **Security**: Escaneo de seguridad
- ✅ **Summary**: Resumen de resultados

**Artifacts generados**:
- Coverage report (30 días)
- Debug APK (90 días)
- Security report (30 días)

**Ejemplo de ejecución**:
```bash
git add .
git commit -m "feat: nueva funcionalidad"
git push origin main
# El workflow CI se ejecutará automáticamente
```

### 2. Release - Automated Release

**Trigger**: Push de tags con formato v*.*.*

**Jobs**:
- 🚀 **Release**: Build APK/AAB firmado y crear GitHub Release

**Artifacts generados**:
- APK release firmado
- AAB release firmado
- Checksums SHA-256

**Ejemplo de ejecución**:
```bash
# Crear tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
# El workflow Release se ejecutará automáticamente
```

### 3. PR Checks - Pull Request Validation

**Trigger**: Abrir, actualizar o reabrir Pull Request

**Jobs**:
- 📝 **Format Check**: Verificar formato de código
- 🧪 **Coverage Check**: Verificar cobertura de tests (≥80%)
- 🔒 **Security Check**: Escaneo de seguridad
- 🔑 **Secrets Check**: Detectar secretos hardcodeados
- 📊 **Summary**: Comentar resumen en PR

**Comentarios automáticos en PR**:
- Estado de formato
- Porcentaje de cobertura
- Issues de seguridad
- Detección de secretos
- Resumen general

---

## Configuración de Secretos

Para que el workflow de **Release** pueda firmar APKs/AABs, necesitas configurar secretos en GitHub.

### Paso 1: Generar Keystore (si no tienes uno)

```bash
./scripts/keystore_manager.sh --generate
```

Guarda las contraseñas que ingreses.

### Paso 2: Codificar Keystore en Base64

```bash
base64 ~/upload-keystore.jks > keystore.base64.txt
```

### Paso 3: Agregar Secretos en GitHub

1. Ve a tu repositorio en GitHub
2. Click en **Settings** → **Secrets and variables** → **Actions**
3. Click en **New repository secret**
4. Agrega los siguientes secretos:

| Nombre | Valor | Descripción |
|--------|-------|-------------|
| `KEYSTORE_BASE64` | Contenido de `keystore.base64.txt` | Keystore codificado en base64 |
| `KEYSTORE_PASSWORD` | Tu contraseña del keystore | Password del keystore |
| `KEY_ALIAS` | `upload` (o tu alias) | Alias de la key |
| `KEY_PASSWORD` | Tu contraseña de la key | Password de la key |

**⚠️ IMPORTANTE**: 
- Nunca commitees el keystore o las contraseñas al repositorio
- Los secretos solo son accesibles en workflows
- No se muestran en logs

### Paso 4: Ver Instrucciones Completas

```bash
./scripts/keystore_manager.sh --github-secrets
```

### Verificar Configuración

Una vez configurados los secretos, el próximo release automático los usará:

```bash
# Crear un tag de prueba
git tag -a v0.0.1-test -m "Test release"
git push origin v0.0.1-test

# Monitorear en: https://github.com/[tu-usuario]/[repo]/actions
```

---

## Uso de Workflows

### Ejecutar CI Localmente (Simulado)

Aunque los workflows se ejecutan en GitHub, puedes simular las verificaciones localmente:

```bash
# Lint y análisis
flutter analyze

# Tests con coverage
flutter test --coverage

# Security scan
./scripts/security_scanner.sh

# Coverage report
./scripts/coverage_reporter.sh --html
```

### Monitorear Workflows

1. Ve a: https://github.com/[tu-usuario]/Tokyo-Predictor-Roulette-001/actions
2. Selecciona el workflow que quieres ver
3. Click en una ejecución específica
4. Revisa los logs de cada job

### Descargar Artifacts

Los artifacts están disponibles en la página del workflow:

1. Ve a la ejecución del workflow
2. Scroll hasta "Artifacts"
3. Click en el artifact para descargar

**Artifacts disponibles**:
- `coverage-report`: Reporte de cobertura
- `app-debug-apk`: APK debug
- `security-report`: Reporte de seguridad

---

## Configuración Avanzada

### Agregar Notificaciones

Puedes agregar notificaciones de Slack/Discord/Email al final de los workflows.

Ejemplo para Slack:

```yaml
- name: Notificar a Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Ejecutar en Múltiples Versiones de Flutter

Modifica el workflow para usar matrix:

```yaml
strategy:
  matrix:
    flutter-version: ['3.16.0', '3.19.0', 'stable']

steps:
  - uses: subosito/flutter-action@v2
    with:
      flutter-version: ${{ matrix.flutter-version }}
```

### Cache de Dependencias

Los workflows ya incluyen cache, pero puedes ajustar:

```yaml
- name: Configurar Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'
    cache: true
    cache-key: 'flutter-:os:-:channel:-:version:-:arch:-:hash:'
```

---

## Troubleshooting

### Workflow Falla: "Flutter command not found"

Verifica que el workflow usa `subosito/flutter-action@v2`:

```yaml
- name: Configurar Flutter
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'
```

### Workflow Falla: "Keystore not found"

Verifica que los secretos estén configurados correctamente:

1. Settings → Secrets and variables → Actions
2. Verifica que existen: `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`

### Workflow Falla: "Tests failed"

Si los tests fallan en CI pero pasan localmente:

```bash
# Limpiar y ejecutar tests
flutter clean
flutter pub get
flutter test
```

Si aún fallan, revisa los logs del workflow para ver el error específico.

### Workflow Tarda Mucho

Optimizaciones:

1. **Cache de pub**: Ya está activado con `cache: true`
2. **Paralelizar jobs**: Los jobs independientes ya corren en paralelo
3. **Reducir retención de artifacts**: Ajusta `retention-days`

### PR Checks No Comentan en PR

Verifica permisos del workflow:

```yaml
permissions:
  contents: read
  pull-requests: write  # Necesario para comentar
```

### Release No Se Crea Automáticamente

Verifica:
1. El tag sigue el formato `v*.*.*` (ej: v1.0.0, no 1.0.0)
2. Hiciste push del tag: `git push origin v1.0.0`
3. El workflow tiene permisos: `contents: write`

---

## Scripts Disponibles

Además de los workflows, puedes usar estos scripts localmente:

### Bot 5A: ReleaseBuilder
```bash
# Build APK/AAB release
./scripts/release_builder.sh --all

# Solo verificar signing
./scripts/release_builder.sh --verify
```

### Bot 5B: KeystoreManager
```bash
# Generar keystore
./scripts/keystore_manager.sh --generate

# Validar keystore
./scripts/keystore_manager.sh --validate

# Crear key.properties
./scripts/keystore_manager.sh --create-properties
```

### Bot 5C: VersionManager
```bash
# Ver versión actual
./scripts/version_manager.sh current

# Incrementar versión
./scripts/version_manager.sh patch
./scripts/version_manager.sh minor
./scripts/version_manager.sh major
```

### Bot 7B: CoverageReporter
```bash
# Generar reporte de cobertura
./scripts/coverage_reporter.sh --html

# Con umbral personalizado
./scripts/coverage_reporter.sh --threshold 90
```

### Bot 7C: SecurityScanner
```bash
# Escaneo de seguridad
./scripts/security_scanner.sh

# Sin fallar en issues
./scripts/security_scanner.sh --no-fail
```

---

## Mejores Prácticas

### 1. Commits Frecuentes

Haz commits pequeños y frecuentes para detectar problemas temprano:

```bash
git add .
git commit -m "feat: implementar funcionalidad X"
git push origin feature/nueva-funcionalidad
```

### 2. Branch Protection

Configura branch protection en GitHub:

1. Settings → Branches → Branch protection rules
2. Proteger `main`:
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Require pull request reviews

### 3. Revisar Artifacts

Siempre descarga y prueba los artifacts antes de un release:

```bash
# Descargar APK del workflow
# Instalar en dispositivo
adb install app-debug.apk
# Verificar funcionalidad
```

### 4. Mantener Secretos Seguros

- 🔒 Rota el keystore solo en caso de compromiso
- 🔒 Nunca compartas las contraseñas
- 🔒 Mantén backup del keystore en lugar seguro

### 5. Monitorear Cobertura

Mantén la cobertura de tests ≥80%:

```bash
./scripts/coverage_reporter.sh --html
# Abre coverage/html/index.html
```

---

## Referencias

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Semantic Versioning](https://semver.org/)

---

## Estado de Workflows

| Workflow | Estado | Último Run |
|----------|--------|------------|
| CI | ![CI](https://github.com/[usuario]/Tokyo-Predictor-Roulette-001/workflows/CI/badge.svg) | - |
| Release | ![Release](https://github.com/[usuario]/Tokyo-Predictor-Roulette-001/workflows/Release/badge.svg) | - |
| PR Checks | ![PR Checks](https://github.com/[usuario]/Tokyo-Predictor-Roulette-001/workflows/PR%20Checks/badge.svg) | - |

---

**Última actualización**: 2025-12-15  
**Versión del documento**: 1.0
