# Copilot Setup Guide - Tokyo Predictor Roulette

## 📖 Tabla de Contenidos

- [Introducción](#introducción)
- [Configuración Actual](#configuración-actual)
- [Instrucciones de Uso](#instrucciones-de-uso)
- [Automatización](#automatización)
- [Gestión de Duplicados](#gestión-de-duplicados)
- [Referencias](#referencias)

---

## 🎯 Introducción

Este documento describe la configuración de GitHub Copilot para el proyecto Tokyo Predictor Roulette y toda la organización Melampe. La configuración está diseñada para maximizar la productividad y mantener la calidad del código.

### Objetivos

- ✅ Configuración unificada de Copilot en todos los repositorios
- ✅ Estándares de código consistentes
- ✅ Automatización de tareas repetitivas
- ✅ Documentación clara y accesible

---

## 📋 Configuración Actual

### Archivo Principal

La configuración de Copilot se encuentra en:

```
.github/copilot-instructions.md
```

Este archivo contiene:

- Guía de estilo de código para Flutter/Dart
- Convenciones de testing
- Patrones de seguridad
- Integración con Firebase y Stripe
- Mejores prácticas de async/await
- Gestión de dependencias

### Estructura del Proyecto

```
Tokyo-Predictor-Roulette-001/
├── .github/
│   ├── copilot-instructions.md  ← Configuración de Copilot
│   └── workflows/
│       └── auto-close-duplicates.yml  ← Workflow de limpieza
├── docs/
│   ├── COPILOT_SETUP.md  ← Este archivo
│   └── ORGANIZATION_STANDARDS.md  ← Estándares de organización
└── scripts/
    ├── close_duplicate_issues.sh  ← Script de limpieza
    └── create_master_copilot_issue.sh  ← Crear issue maestro
```

---

## 🛠️ Instrucciones de Uso

### Para Desarrolladores

1. **Revisión de Configuración**
   ```bash
   cat .github/copilot-instructions.md
   ```

2. **Verificar que Copilot usa las instrucciones**
   - GitHub Copilot carga automáticamente `.github/copilot-instructions.md`
   - Las instrucciones se aplican a sugerencias de código y chat

3. **Comandos Útiles**
   - `@workspace /explain` - Explica código usando el contexto del proyecto
   - `@workspace /fix` - Sugiere correcciones basadas en las convenciones
   - `@workspace /tests` - Genera tests siguiendo los estándares

### Para Maintainers

1. **Actualizar Configuración**
   ```bash
   # Editar el archivo
   vim .github/copilot-instructions.md
   
   # Verificar cambios
   git diff .github/copilot-instructions.md
   
   # Commit y push
   git add .github/copilot-instructions.md
   git commit -m "docs: actualizar instrucciones de Copilot"
   git push
   ```

2. **Propagar a Otros Repositorios**
   ```bash
   # Usar el agente de sincronización (si está disponible)
   # O copiar manualmente a otros repos de la organización
   ```

---

## 🤖 Automatización

### Sistema de Limpieza de Duplicados

El repositorio incluye automatización para detectar y cerrar issues duplicados de configuración de Copilot.

#### Workflow Automático

**Archivo**: `.github/workflows/auto-close-duplicates.yml`

**Triggers**:
- Cuando se abre un nuevo issue
- Cuando se agrega un label
- Semanalmente (domingos a medianoche UTC)
- Manualmente desde GitHub Actions

**Funcionalidad**:
1. Busca issues con patrones relacionados a "Copilot setup"
2. Identifica duplicados
3. Cierra los más antiguos, manteniendo el más reciente como "master issue"
4. Agrega comentarios explicativos y labels

#### Scripts Manuales

**1. Cerrar Duplicados Manualmente**

```bash
# Dry run (simulación)
./scripts/close_duplicate_issues.sh --dry-run

# Ejecución real
./scripts/close_duplicate_issues.sh
```

Este script cierra issues duplicados en:
- Tokyo-Predictor-Roulette-001 (#85, #93)
- bug-free-octo-winner-Tokyo-IA2 (#1, #11)
- skills-introduction-to-github (#9)
- Tokyoapps (#7)

**2. Crear Issue Maestro Consolidado**

```bash
# Dry run (ver contenido)
./scripts/create_master_copilot_issue.sh --dry-run

# Crear issue
./scripts/create_master_copilot_issue.sh
```

Este script crea un issue consolidado con:
- Estado de configuración en todos los repositorios
- Checklist de implementación
- Referencias a documentación
- Enlaces a issues cerrados

---

## 🧹 Gestión de Duplicados

### ¿Por qué se cierran automáticamente?

Los issues duplicados de Copilot setup se cierran automáticamente por:

1. **Evitar confusión**: Múltiples issues sobre lo mismo generan desorden
2. **Centralizar información**: Un solo issue maestro facilita el tracking
3. **Mejorar eficiencia**: Reduce trabajo duplicado
4. **Mantener organización**: Proyecto más limpio y mantenible

### Issues Consolidados

Los siguientes issues fueron cerrados y consolidados:

| Repositorio | Issue # | Título | Estado |
|-------------|---------|--------|--------|
| Tokyo-Predictor-Roulette-001 | #85 | Set up Copilot instructions | Cerrado (duplicado) |
| Tokyo-Predictor-Roulette-001 | #93 | Set up Copilot instructions | Cerrado (duplicado) |
| bug-free-octo-winner-Tokyo-IA2 | #1 | Copilot setup | Cerrado (duplicado) |
| bug-free-octo-winner-Tokyo-IA2 | #11 | Copilot setup | Cerrado (duplicado) |
| skills-introduction-to-github | #9 | Copilot instructions | Cerrado (duplicado) |
| Tokyoapps | #7 | Configure Copilot | Cerrado (duplicado) |

### Reabrir Issues

Si crees que un issue fue cerrado erróneamente:

1. Comenta en el issue explicando por qué debe reabrirse
2. Menciona a @Melampe001
3. Proporciona justificación clara

---

## 📚 Referencias

### Documentación Oficial

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Copilot Best Practices](https://gh.io/copilot-coding-agent-tips)
- [Flutter Documentation](https://docs.flutter.dev/)

### Documentación Interna

- [Architecture](ARCHITECTURE.md) - Arquitectura del proyecto
- [Health Agent](HEALTH_AGENT.md) - Sistema de salud del proyecto
- [Organization Standards](ORGANIZATION_STANDARDS.md) - Estándares organizacionales
- [Contributing Guide](../CONTRIBUTING.md) - Guía de contribución

### Archivos Relacionados

- `.github/copilot-instructions.md` - Instrucciones actuales de Copilot
- `.github/workflows/auto-close-duplicates.yml` - Workflow de automatización
- `scripts/close_duplicate_issues.sh` - Script de limpieza
- `scripts/create_master_copilot_issue.sh` - Script de creación de issue maestro

---

## 🔄 Historial de Cambios

### v1.0 - Diciembre 2024
- ✅ Configuración inicial de Copilot instructions
- ✅ Sistema automático de limpieza de duplicados
- ✅ Scripts de automatización
- ✅ Documentación completa

---

## 🆘 Soporte

Si tienes preguntas o problemas con la configuración de Copilot:

1. **Revisa esta documentación** primero
2. **Busca en issues existentes** por problemas similares
3. **Abre un nuevo issue** con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Screenshots si aplica

**Maintainer**: @Melampe001

---

_Última actualización: Diciembre 2024_
_Versión: 1.0_
