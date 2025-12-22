# Scripts Directory

Este directorio contiene scripts y herramientas automatizadas para el proyecto.

## 📋 Contenido

### AGENTE 5: Release Master 🚀

Scripts para builds de producción y gestión de releases.

#### `release_builder.sh` (Bot 5A)

Build de APKs/AABs de release con signing automático.

**Uso básico:**
```bash
# Build APK release
./scripts/release_builder.sh --apk

# Build AAB release
./scripts/release_builder.sh --aab

# Build ambos
./scripts/release_builder.sh --all

# Verificar signing
./scripts/release_builder.sh --verify

# Modo dry-run
./scripts/release_builder.sh --apk --dry-run
```

**Documentación completa:** Ver [docs/RELEASE_PROCESS.md](../docs/RELEASE_PROCESS.md)

#### `keystore_manager.sh` (Bot 5B)

Gestión segura de keystores para signing.

**Uso básico:**
```bash
# Generar nuevo keystore
./scripts/keystore_manager.sh --generate

# Validar keystore existente
./scripts/keystore_manager.sh --validate

# Crear key.properties
./scripts/keystore_manager.sh --create-properties

# Backup del keystore
./scripts/keystore_manager.sh --backup

# Ver instrucciones para GitHub Secrets
./scripts/keystore_manager.sh --github-secrets
```

#### `version_manager.sh` (Bot 5C)

Gestión automática de versiones.

**Uso básico:**
```bash
# Ver versión actual
./scripts/version_manager.sh current

# Incrementar versión patch (1.0.0 -> 1.0.1)
./scripts/version_manager.sh patch

# Incrementar versión minor (1.0.0 -> 1.1.0)
./scripts/version_manager.sh minor

# Incrementar versión major (1.0.0 -> 2.0.0)
./scripts/version_manager.sh major

# Incrementar y crear tag
./scripts/version_manager.sh minor --tag
```

### AGENTE 7: CI/CD Master ⚙️

Scripts para automatización de CI/CD.

#### `coverage_reporter.sh` (Bot 7B)

Generación y reporte de cobertura de tests.

**Uso básico:**
```bash
# Ejecutar tests con coverage
./scripts/coverage_reporter.sh

# Generar reporte HTML
./scripts/coverage_reporter.sh --html

# Usar umbral de 90%
./scripts/coverage_reporter.sh --threshold 90

# No fallar si cobertura < umbral
./scripts/coverage_reporter.sh --no-fail
```

#### `security_scanner.sh` (Bot 7C)

Escaneo de seguridad del código.

**Uso básico:**
```bash
# Escaneo completo
./scripts/security_scanner.sh

# No fallar en issues
./scripts/security_scanner.sh --no-fail

# Reporte personalizado
./scripts/security_scanner.sh --report my-report.txt
```

**Documentación completa:** Ver [docs/CI_CD_SETUP.md](../docs/CI_CD_SETUP.md)

### Otros Scripts

#### `health_agent.py`

Sistema automatizado de auditoría de salud del proyecto.

**Uso básico:**
```bash
# Auditoría completa
python scripts/health_agent.py --full-scan

# Modo dry-run (sin modificar)
python scripts/health_agent.py --dry-run

# Solo categorías específicas
python scripts/health_agent.py --check security,dependencies
```

**Documentación completa:** Ver [docs/HEALTH_AGENT.md](../docs/HEALTH_AGENT.md)

## 🔧 Workflows Automatizados

Los siguientes workflows de GitHub Actions utilizan estos scripts:

- **CI** (`.github/workflows/ci.yml`): Lint, tests, build debug, seguridad
- **Release** (`.github/workflows/release.yml`): Build release automático con signing
- **PR Checks** (`.github/workflows/pr-checks.yml`): Validaciones de Pull Requests

Ver [docs/CI_CD_SETUP.md](../docs/CI_CD_SETUP.md) para configuración completa.

## 🚀 Caso de Uso: Release Completo

Workflow completo para hacer un release:

```bash
# 1. Incrementar versión
./scripts/version_manager.sh minor

# 2. Editar CHANGELOG.md con detalles específicos
# (opcional, el script crea una entrada base)

# 3. Commit cambios
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to 1.1.0"
git push origin main

# 4. Crear y push tag (dispara release automático)
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin v1.1.0

# El workflow de GitHub Actions automáticamente:
# - Build APK/AAB release firmado
# - Crea GitHub Release
# - Sube archivos como assets
```

## 📝 Convenciones

- Scripts en **Python**: Usar extensión `.py`
- Scripts en **Bash**: Usar extensión `.sh`
- Todos los scripts deben tener un shebang apropiado
- Incluir modo `--help` para documentación
- Incluir modo `--dry-run` para simulación
- Usar colores en output (verde=éxito, rojo=error, amarillo=advertencia)
- Incluir documentación en comentarios al inicio del archivo
- Usar nombres descriptivos en minúsculas con guiones: `mi-script.sh`

## 🆘 Ayuda

Todos los scripts incluyen ayuda integrada:

```bash
./scripts/release_builder.sh --help
./scripts/keystore_manager.sh --help
./scripts/version_manager.sh --help
./scripts/coverage_reporter.sh --help
./scripts/security_scanner.sh --help
```
