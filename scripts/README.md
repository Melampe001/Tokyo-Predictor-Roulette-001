# Scripts Directory

Este directorio contiene scripts y herramientas automatizadas para el proyecto.

## 📋 Contenido

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

## 🚀 Agregar Nuevos Scripts

Si necesitas agregar nuevos scripts de automatización:

1. Crea el script en este directorio
2. Hazlo ejecutable: `chmod +x script-name.sh`
3. Documenta su uso en este README
4. Considera agregar un workflow de GitHub Actions si debe ejecutarse automáticamente

## 📝 Convenciones

- Scripts en **Python**: Usar extensión `.py`
- Scripts en **Bash**: Usar extensión `.sh`
- Todos los scripts deben tener un shebang apropiado
- Incluir documentación en comentarios al inicio del archivo
- Usar nombres descriptivos en minúsculas con guiones: `mi-script.sh`
