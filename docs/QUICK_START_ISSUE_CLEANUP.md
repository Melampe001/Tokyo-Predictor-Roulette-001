# 🧹 Guía Rápida: Sistema de Limpieza de Issues Duplicados

## 📚 Resumen Ejecutivo

Este documento proporciona una guía rápida para usar el sistema automatizado de limpieza de issues duplicados de Copilot setup.

---

## 🚀 Uso Rápido

### Opción 1: Ejecución Manual de Scripts

#### Paso 1: Cerrar Issues Duplicados

```bash
# Ver qué se haría (dry-run)
./scripts/close_duplicate_issues.sh --dry-run

# Ejecutar el cierre real
./scripts/close_duplicate_issues.sh
```

**Requisito**: GitHub CLI (`gh`) instalado y autenticado

```bash
# Instalar gh (si no está instalado)
# macOS: brew install gh
# Linux: sudo apt install gh
# Windows: choco install gh

# Autenticar
gh auth login
```

#### Paso 2: Crear Issue Maestro

```bash
# Ver preview del issue
./scripts/create_master_copilot_issue.sh --dry-run

# Crear el issue
./scripts/create_master_copilot_issue.sh
```

### Opción 2: Workflow Automático

El workflow `.github/workflows/auto-close-duplicates.yml` se ejecuta automáticamente:

- ✅ Cuando se abre un nuevo issue
- ✅ Cuando se agrega un label a un issue
- ✅ Semanalmente (domingo a medianoche UTC)

**Ejecución manual del workflow:**

1. Ve a: `Actions` → `Auto-close Duplicate Issues`
2. Click en `Run workflow`
3. Selecciona la rama y click `Run workflow`

---

## 📋 Issues que se Consolidarán

### Tokyo-Predictor-Roulette-001
- Issue #85: "Set up Copilot instructions" (4 días)
- Issue #93: "Set up Copilot instructions" (2 días)

### bug-free-octo-winner-Tokyo-IA2
- Issue #1: Copilot setup (22 días)
- Issue #11: Copilot setup (1 día)

### skills-introduction-to-github
- Issue #9: Copilot instructions (29 días)

### Tokyoapps
- Issue #7: Configure Copilot (46 días)

**Total**: 6 issues duplicados a cerrar

---

## 🎯 Resultado Esperado

Después de ejecutar el sistema:

1. ✅ 6 issues cerrados automáticamente
2. ✅ Cada issue cerrado tendrá un comentario explicativo
3. ✅ Labels "duplicate" y "auto-closed" agregados
4. ✅ Issue maestro creado con tracking completo
5. ✅ Referencias cruzadas entre issues

---

## 📖 Documentación Completa

Para más detalles, consulta:

- **Setup Completo**: [`docs/COPILOT_SETUP.md`](../docs/COPILOT_SETUP.md)
- **Estándares**: [`docs/ORGANIZATION_STANDARDS.md`](../docs/ORGANIZATION_STANDARDS.md)
- **Scripts**: [`scripts/README.md`](../scripts/README.md)
- **Configuración Actual**: [`.github/copilot-instructions.md`](../.github/copilot-instructions.md)

---

## 🔧 Troubleshooting

### Error: "gh: command not found"

**Solución**: Instalar GitHub CLI

```bash
# macOS
brew install gh

# Ubuntu/Debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Fedora/RHEL
sudo dnf install gh
```

### Error: "authentication required"

**Solución**: Autenticar con GitHub

```bash
gh auth login
# Sigue las instrucciones en pantalla
```

### Error: "Issue already closed"

**Esperado**: El script detectará esto y continuará con los siguientes issues. No es un error crítico.

### Workflow no se ejecuta automáticamente

**Verificar**:
1. El workflow está en la rama correcta (main/master)
2. Los permisos del workflow están configurados correctamente
3. El repositorio tiene Actions habilitadas

---

## 🤖 Características del Sistema

### Scripts

| Script | Función | Dry-Run |
|--------|---------|---------|
| `close_duplicate_issues.sh` | Cierra issues duplicados | ✅ Sí |
| `create_master_copilot_issue.sh` | Crea issue maestro | ✅ Sí |

### Workflow

| Característica | Estado |
|----------------|--------|
| Detección automática de duplicados | ✅ |
| Cierre automático | ✅ |
| Comentarios explicativos | ✅ |
| Labels automáticos | ✅ |
| Mantener issue más reciente | ✅ |
| Ejecución programada (semanal) | ✅ |
| Ejecución manual | ✅ |

---

## 📊 Métricas de Éxito

Después de la implementación completa:

- ✅ 0 issues duplicados abiertos relacionados con Copilot setup
- ✅ 1 issue maestro con tracking consolidado
- ✅ Documentación completa en `docs/`
- ✅ Sistema automático funcionando semanalmente

---

## 🆘 Soporte

Si encuentras problemas:

1. **Revisa los logs**: Los scripts proporcionan output detallado
2. **Usa dry-run**: Prueba con `--dry-run` primero
3. **Revisa la documentación**: [`docs/COPILOT_SETUP.md`](../docs/COPILOT_SETUP.md)
4. **Abre un issue**: Si el problema persiste, abre un issue en GitHub

**Maintainer**: @Melampe001

---

_Última actualización: Diciembre 2024_
