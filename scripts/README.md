# Scripts Directory

Este directorio contiene scripts y herramientas automatizadas para el proyecto.

## 📋 Contenido

### Scripts de Automatización

#### `health_agent.py` ⭐
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

#### `automate_all.py`
Script maestro para automatizar tareas comunes del proyecto.

#### `master_orchestrator.py`
Orquestador de bots y scripts del proyecto.

#### `generate_critical_bots.py`
Generador de bots críticos para el proyecto.

### Bots de Build

#### `bot_apk_builder.py`
Bot para construir APKs de la aplicación.

**Uso:**
```bash
python scripts/bot_apk_builder.py
```

#### `bot_gradle_builder.py`
Bot para builds de Gradle.

#### `bot_release_builder.py`
Bot para crear builds de release.

#### `bot_keystore_manager.py`
Gestión automatizada de keystores para firma de APKs.

#### `bot_test_runner.py`
Bot para ejecutar tests automatizados.

### Scripts Shell

#### `build_all.sh`
Construye todos los componentes del proyecto.

```bash
bash scripts/build_all.sh
```

#### `check_health.sh`
Verifica la salud del proyecto rápidamente.

```bash
bash scripts/check_health.sh
```

#### `clean_all.sh`
Limpia archivos de build y temporales.

```bash
bash scripts/clean_all.sh
```

#### `dev_run.sh`
Ejecuta la aplicación en modo desarrollo.

```bash
bash scripts/dev_run.sh
```

#### `pre_commit.sh`
Hook de pre-commit para validaciones antes de commit.

```bash
bash scripts/pre_commit.sh
```

#### `run_tests.sh`
Ejecuta la suite de tests.

```bash
bash scripts/run_tests.sh
```

## 🚀 Agregar Nuevos Scripts

Si necesitas agregar nuevos scripts de automatización:

1. Crea el script en este directorio
2. Para scripts Bash: Hazlo ejecutable con `chmod +x script-name.sh`
3. Para scripts Python: Incluye shebang `#!/usr/bin/env python3` si deseas ejecutarlos directamente
4. Documenta su uso en este README
5. Considera agregar un workflow de GitHub Actions si debe ejecutarse automáticamente

## 📝 Convenciones

- Scripts en **Python**: Usar extensión `.py`
- Scripts en **Bash**: Usar extensión `.sh`
- Todos los scripts deben tener un shebang apropiado
- Incluir documentación en comentarios al inicio del archivo
- Usar nombres descriptivos en minúsculas con guiones: `mi-script.sh`

## ⚠️ Permisos de Ejecución

Scripts Bash requieren permisos de ejecución:

```bash
chmod +x scripts/*.sh
```

Scripts Python generalmente se ejecutan con `python3 scripts/script.py` y no requieren `chmod +x`.

## 🔗 Recursos

- [Health Agent Documentation](../docs/HEALTH_AGENT.md)
- [Contributing Guide](../CONTRIBUTING.md)
- [GitHub Actions Workflows](../.github/workflows/)

---

**Última actualización**: Diciembre 2025
