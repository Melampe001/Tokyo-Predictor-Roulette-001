# 🏥 Health Agent - Quick Reference

## One-Line Commands

```bash
# Quick health check (dry-run)
python scripts/health_agent.py --dry-run --full-scan

# Full audit with reports
python scripts/health_agent.py --full-scan

# Check only security
python scripts/health_agent.py --check security

# Check security + dependencies
python scripts/health_agent.py --check security,dependencies

# Generate JSON report
python scripts/health_agent.py --full-scan --json
```

## Understanding the Score

| Score | Level | Action |
|-------|-------|--------|
| 85-100 🟢 | Excelente | Mantenimiento regular |
| 70-84 🟡 | Bueno | Atender advertencias |
| 50-69 🟠 | Regular | Planificar mejoras |
| <50 🔴 | Crítico | Acción inmediata |

## Check Categories

- `file_structure` - Archivos críticos y estructura
- `dependencies` - Dependencias y versiones
- `git_health` - Estado de Git y branches
- `ci_cd` - Workflows y CI/CD
- `security` - Seguridad y archivos sensibles
- `documentation` - Documentación del proyecto

## Common Issues & Fixes

### Issue: "Falta archivo crítico"
```bash
# Verificar que existan los archivos necesarios
ls -la pubspec.yaml lib/main.dart
```

### Issue: "Archivos con cambios sin committear"
```bash
git status
git add .
git commit -m "chore: commit pending changes"
```

### Issue: "Dependencias deprecadas"
```bash
flutter pub outdated
flutter pub upgrade
```

### Issue: ".gitignore no incluye patrones"
```bash
# Agregar al .gitignore:
*.env
*.key
key.properties
```

## GitHub Actions Integration

El workflow se ejecuta:
- ⏰ **Automáticamente**: Cada domingo a medianoche
- 🔄 **En PRs**: Al abrir o actualizar
- 🖱️ **Manual**: Desde Actions > Project Health Check > Run workflow

## Reports Location

- **Markdown**: `reports/project-health-report-YYYY-MM-DD.md`
- **JSON**: `reports/health-report-YYYY-MM-DD.json`
- **Artifacts**: GitHub Actions > Artifacts (90 días de retención)

## Configuration

Edita `.project-health.yml` para:
- Habilitar/deshabilitar checks
- Ajustar umbrales
- Configurar tipo de proyecto
- Definir archivos críticos

## Need Help?

📖 **Full Documentation**: [docs/HEALTH_AGENT.md](HEALTH_AGENT.md)  
🐛 **Report Issues**: [GitHub Issues](../../issues)  
📝 **Main README**: [README.md](../README.md)
