# 🏥 Project Structure Health Agent

## Descripción

El **Project Structure Health Agent** es un sistema automatizado de auditoría y control de estructura de proyectos que funciona como un ingeniero de calidad, verificando la integridad, consistencia y salud general del proyecto de software.

## 🎯 Características

### Sistema de Auditoría Automatizada

El agente realiza verificaciones completas en las siguientes áreas:

#### A. Estructura de Archivos ✅
- Verifica la existencia de archivos críticos según el tipo de proyecto
- Detecta archivos huérfanos o duplicados
- Verifica permisos de archivos ejecutables
- Valida estructura de directorios según convenciones

#### B. Dependencias y Configuración ✅
- Analiza `pubspec.yaml` y detecta dependencias
- Identifica dependencias deprecadas
- Verifica consistencia entre archivos de configuración

#### C. Git y Control de Versiones ✅
- Analiza el estado del repositorio
- Verifica branches activos
- Revisa la calidad de commits recientes
- Detecta cambios sin committear

#### D. CI/CD y Workflows ✅
- Audita workflows de GitHub Actions
- Verifica versiones de actions
- Detecta secretos hardcodeados en workflows
- Valida configuración de permisos

#### E. Seguridad ✅
- Escanea archivos sensibles
- Verifica configuración de `.gitignore`
- Busca claves/tokens hardcodeados
- Detecta patrones de seguridad faltantes

#### F. Documentación ✅
- Verifica completitud de README.md
- Revisa documentación del proyecto
- Valida presencia de archivos importantes (LICENSE, CHANGELOG, etc.)
- Calcula cobertura de documentación

## 📊 Sistema de Puntuación

El agente calcula una puntuación de 0 a 100 basada en:

```
File Structure:     /20 puntos
Dependencies:       /15 puntos
Git Health:         /15 puntos
CI/CD:              /15 puntos
Security:           /15 puntos
Documentation:      /10 puntos
Test Coverage:      /10 puntos
-----------------------------------
TOTAL:              /100 puntos

🟢 Excelente: 85-100
🟡 Bueno:     70-84
🟠 Regular:   50-69
🔴 Crítico:   <50
```

## 🚀 Uso

### Instalación de Dependencias

```bash
pip install pyyaml requests gitpython
```

### Comandos Disponibles

#### Dry-Run (sin modificar nada)
```bash
python scripts/health_agent.py --dry-run
```

#### Scan Completo con Reporte
```bash
python scripts/health_agent.py --full-scan
```

#### Especificar Directorio de Salida
```bash
python scripts/health_agent.py --full-scan --output reports/
```

#### Generar Reporte JSON
```bash
python scripts/health_agent.py --full-scan --json
```

#### Ejecutar Solo Categorías Específicas
```bash
python scripts/health_agent.py --check dependencies,security
```

#### Usar Configuración Personalizada
```bash
python scripts/health_agent.py --full-scan --config custom-config.yml
```

### Ejemplos de Uso

1. **Auditoría rápida sin modificaciones:**
```bash
python scripts/health_agent.py --dry-run --full-scan
```

2. **Auditoría completa con reportes:**
```bash
python scripts/health_agent.py --full-scan --output reports/ --json
```

3. **Solo verificar seguridad y dependencias:**
```bash
python scripts/health_agent.py --check security,dependencies
```

## ⚙️ Configuración

El agente utiliza el archivo `.project-health.yml` para configuración:

```yaml
agent:
  name: "Project Structure Health Agent"
  version: "1.0.0"
  
checks:
  enabled:
    - file_structure
    - dependencies
    - git_health
    - ci_cd
    - security
    - documentation
  
thresholds:
  max_open_prs: 10
  max_pr_age_days: 30
  max_stale_branches: 5
  min_test_coverage: 70
  max_outdated_dependencies: 5
  
project_type: "flutter"  # auto-detect si está en blanco

critical_files:
  flutter:
    - pubspec.yaml
    - lib/main.dart
    - android/app/src/main/AndroidManifest.xml
```

### Personalización de Configuración

Puedes personalizar los siguientes aspectos:

- **Checks habilitados**: Activa/desactiva categorías específicas
- **Umbrales**: Define límites para advertencias
- **Tipo de proyecto**: flutter, nodejs, python, go
- **Archivos críticos**: Lista de archivos esenciales por tipo de proyecto
- **Patrones a ignorar**: Directorios y archivos a excluir del análisis

## 🤖 Automatización con GitHub Actions

El workflow `.github/workflows/project-health-check.yml` ejecuta auditorías automáticas:

### Ejecución Programada
- **Semanal**: Domingos a medianoche UTC
- **Manual**: Desde la pestaña Actions
- **En PRs**: Automáticamente en cada pull request

### Características del Workflow

1. **Auditoría completa** del proyecto
2. **Generación de reportes** en Markdown y JSON
3. **Comentarios automáticos** en PRs con resumen
4. **Artifacts guardados** por 90 días
5. **Validación de score** con warnings/errors

### Permisos Necesarios

El workflow requiere:
- `contents: read` - Lectura del código
- `issues: write` - Crear issues (futuro)
- `pull-requests: write` - Comentar en PRs

## 📋 Formato del Reporte

El agente genera dos tipos de reportes:

### 1. Reporte Markdown (`project-health-report-YYYY-MM-DD.md`)

Incluye:
- Score general de salud
- Problemas críticos (🔴)
- Advertencias (🟡)
- Checks pasados (🟢)
- Recomendaciones priorizadas
- Métricas detalladas
- Desglose de puntuación

### 2. Reporte JSON (`health-report-YYYY-MM-DD.json`)

Formato estructurado para integración con herramientas:
```json
{
  "score": 92,
  "timestamp": "2025-12-14T02:14:09",
  "issues": {
    "critical": [],
    "warnings": [],
    "passed": []
  },
  "metrics": {}
}
```

## 🎓 Interpretación de Resultados

### Score Excelente (85-100) 🟢
- Proyecto en excelente estado
- Estructura sólida y bien mantenida
- Pocas o ninguna advertencia
- **Acción**: Mantenimiento regular

### Score Bueno (70-84) 🟡
- Proyecto en buen estado
- Algunas mejoras recomendadas
- Advertencias menores
- **Acción**: Atender advertencias gradualmente

### Score Regular (50-69) 🟠
- Proyecto necesita atención
- Varios problemas por resolver
- Posibles riesgos de mantenibilidad
- **Acción**: Planificar refactoring

### Score Crítico (<50) 🔴
- Proyecto en estado crítico
- Problemas graves detectados
- Alto riesgo técnico
- **Acción**: Intervención inmediata necesaria

## 🔧 Integración y Extensión

### Integrar con CI/CD Local

```bash
# En tu pipeline local
./scripts/health_agent.py --full-scan --json
if [ $? -ne 0 ]; then
  echo "Health check failed"
  exit 1
fi
```

### Integrar con Pre-commit Hooks

```bash
# .git/hooks/pre-commit
#!/bin/bash
python scripts/health_agent.py --check security --dry-run
```

### Crear Dashboard Personalizado

El reporte JSON puede ser usado para crear dashboards:
```python
import json
with open('reports/health-report-*.json') as f:
    data = json.load(f)
    print(f"Score: {data['score']}")
```

## 📈 Métricas Rastreadas

El agente rastrea y reporta:

- **Dependencias**: Total, producción, desarrollo
- **Branches**: Locales, remotos
- **Commits**: Recientes
- **Workflows**: Cantidad configurados
- **Documentación**: Porcentaje de cobertura
- **Seguridad**: Issues encontrados

## 🛡️ Mejores Prácticas

### Frecuencia Recomendada

- **Diario**: Durante desarrollo activo
- **Semanal**: En mantenimiento
- **En cada PR**: Verificación automática
- **Antes de releases**: Auditoría completa

### Priorización de Issues

1. **Críticos** (🔴): Resolver inmediatamente
2. **Advertencias** (🟡): Planificar en sprint
3. **Mejoras**: Considerar en backlog

## 🔮 Características Futuras

### Fase 2 (Planificado)
- [ ] Auto-corrección de problemas comunes
- [ ] Creación automática de issues
- [ ] Dashboard HTML interactivo
- [ ] Análisis de tendencias históricas

### Fase 3 (Planificado)
- [ ] Integración con Slack/Discord
- [ ] Detección de código duplicado
- [ ] Análisis de complejidad ciclomática
- [ ] Sugerencias de refactoring

## 📞 Soporte

Para problemas o sugerencias:

1. Revisa la [documentación](../README.md)
2. Verifica los [logs del workflow](../../actions)
3. Abre un [issue](../../issues) con etiqueta `project-health`

## 📄 Licencia

Este agente es parte del proyecto y está bajo la misma licencia MIT.

---

**Versión**: 1.0.0  
**Última Actualización**: Diciembre 2024  
**Mantenedor**: Project Team
