# Scripts Directory

Este directorio contiene scripts y herramientas automatizadas para el proyecto.

## 📋 Scripts de Calidad de Código (Nuevos)

### `dev-setup.sh`
Script de configuración completa del entorno de desarrollo.

**Uso:**
```bash
bash scripts/dev-setup.sh
```

**Qué hace:**
- Verifica instalación de Flutter y Dart
- Instala dependencias del proyecto
- Configura Git hooks automáticamente
- Valida estructura del proyecto
- Provee próximos pasos

---

### `install-hooks.sh`
Instala Git hooks desde `.githooks/` a `.git/hooks/`.

**Uso:**
```bash
bash scripts/install-hooks.sh
# O usando Makefile:
make setup
```

---

### `validate-code-style.dart`
Valida convenciones de código y estilo.

**Uso:**
```bash
dart run scripts/validate-code-style.dart
```

**Verifica:**
- Convenciones de nomenclatura (PascalCase, camelCase)
- Documentación de APIs públicas
- Comentarios TODO/FIXME
- Cobertura de tests

---

### `security-scan.sh`
Escanea el código en busca de vulnerabilidades de seguridad.

**Uso:**
```bash
bash scripts/security-scan.sh
# O usando Makefile:
make check-security
```

**Detecta:**
- API keys hardcodeadas
- Secretos en código
- Uso inseguro de Random()
- Archivos sensibles en git

---

### `check-coverage.sh`
Valida que la cobertura de tests cumpla los requisitos mínimos.

**Uso:**
```bash
flutter test --coverage
bash scripts/check-coverage.sh
# O usando Makefile:
make test
```

**Requisitos:**
- Cobertura general: ≥ 80%
- Lógica core: ≥ 90%

---

## 📋 Scripts Existentes

### `health_agent.py`

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

### Otros Scripts
- `pre_commit.sh` - Script pre-commit original
- `run_tests.sh` - Ejecutor de tests
- `build_all.sh` - Automatización de builds
- `clean_all.sh` - Limpieza de artefactos
- Varios scripts bot (`bot_*.py`) - Automatización Python

---

## 🔧 Integración con Makefile

Todos los scripts están integrados con el Makefile del proyecto:

```bash
make help              # Ver todos los comandos
make setup             # Configurar entorno (dev-setup.sh)
make check             # Ejecutar todas las verificaciones
make check-security    # Escaneo de seguridad
make test              # Tests con verificación de cobertura
make format            # Formatear código
make lint              # Análisis estático
```

Ver `make help` para la lista completa de comandos.

---

## 🚀 Agregar Nuevos Scripts

Si necesitas agregar nuevos scripts de automatización:

1. Crea el script en este directorio
2. Hazlo ejecutable: `chmod +x script-name.sh`
3. Documenta su uso en este README
4. Agrégalo al Makefile si es apropiado
5. Considera agregar un workflow de GitHub Actions si debe ejecutarse automáticamente

---

## 📝 Convenciones

- Scripts en **Python**: Usar extensión `.py`
- Scripts en **Bash**: Usar extensión `.sh`
- Scripts en **Dart**: Usar extensión `.dart`
- Todos los scripts deben tener un shebang apropiado
- Incluir documentación en comentarios al inicio del archivo
- Usar nombres descriptivos en minúsculas con guiones: `mi-script.sh`
- Proveer mensajes de error claros y accionables
- Manejar errores graciosamente
- Soportar múltiples plataformas (Linux, macOS, Windows/Git Bash)

---

## 📖 Documentación Adicional

- **Makefile:** Ver el Makefile en la raíz del proyecto
- **Git Hooks:** Ver directorio `.githooks/`
- **CI/CD:** Ver `.github/workflows/quality-checks.yml`
- **Guía de Contribución:** Ver `CONTRIBUTING.md`

---

## ❓ Solución de Problemas

### Error "Permission denied"
```bash
chmod +x scripts/nombre-script.sh
```

### "Flutter not found" en CI
Los scripts manejan graciosamente la ausencia de Flutter.

### Scripts no funcionan en Windows
Usa Git Bash en Windows para ejecutar scripts shell.

---

**Última actualización:** 2024  
**Para más información:** Ver `make help` o `CONTRIBUTING.md`

