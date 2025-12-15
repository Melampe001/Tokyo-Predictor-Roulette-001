# Scripts de Automatización - Tokyo Roulette

Sistema de automatización avanzado para testing y builds del proyecto Tokyo Roulette.

## 📁 Contenido

### `test_runner.py`
**Sistema de testing paralelo de alta velocidad**

Ejecuta todos los tests de Flutter en paralelo, reduciendo el tiempo de ejecución hasta 4x.

**Características:**
- ✅ Descubrimiento automático de tests
- ✅ Ejecución paralela con ThreadPoolExecutor
- ✅ Reportes JSON detallados
- ✅ Timeout automático (120s por test)
- ✅ Manejo de errores robusto

**Uso:**
```bash
# Ejecutar con configuración por defecto (4 workers)
python3 scripts/automation/test_runner.py

# Ejecutar con 8 workers paralelos
python3 scripts/automation/test_runner.py --workers 8

# Desde otro directorio
python3 scripts/automation/test_runner.py --root /path/to/project
```

**Salida:**
- Reporte en consola con resumen
- Archivo `test_report.json` con resultados detallados
- Exit code 0 si todos los tests pasan, 1 si hay fallos

**Ejemplo de reporte JSON:**
```json
{
  "summary": {
    "total_tests": 2,
    "passed": 2,
    "failed": 0,
    "errors": 0,
    "total_duration": 8.45,
    "success_rate": 100.0
  },
  "results": [
    {
      "name": "roulette_logic_test.dart",
      "status": "passed",
      "duration": 4.12
    }
  ]
}
```

---

### `build_bot.py`
**Automatización completa del proceso de build APK**

Pipeline completo de build con verificaciones y métricas automáticas.

**Características:**
- ✅ Limpieza automática de builds anteriores
- ✅ Gestión de dependencias
- ✅ Build APK (release/debug)
- ✅ Verificación de APK generada
- ✅ Métricas de tamaño y tiempo

**Uso:**
```bash
# Build en modo release (por defecto)
python3 scripts/automation/build_bot.py

# Build en modo debug
python3 scripts/automation/build_bot.py --debug

# Desde otro directorio
python3 scripts/automation/build_bot.py --root /path/to/project
```

**Salida:**
- APK en `build/app/outputs/flutter-apk/`
- Métricas en consola (duración, tamaño)
- Exit code 0 si build es exitoso, 1 si falla

**Ejemplo de salida:**
```
📊 MÉTRICAS DE BUILD
============================================================
⏱️  Duración:  142.34s (2.4 minutos)
📦 APK:       build/app/outputs/flutter-apk/app-release.apk
💾 Tamaño:    18.5 MB
📅 Timestamp: 2024-12-14T10:30:00
============================================================
✅ BUILD COMPLETADO EXITOSAMENTE
```

---

## 🚀 Integración con CI/CD

### GitHub Actions

**Agregar a `.github/workflows/test.yml`:**
```yaml
- name: Run parallel tests
  run: python3 scripts/automation/test_runner.py --workers 8

- name: Upload test report
  uses: actions/upload-artifact@v3
  with:
    name: test-report
    path: test_report.json
```

**Agregar a `.github/workflows/build.yml`:**
```yaml
- name: Build APK
  run: python3 scripts/automation/build_bot.py

- name: Upload APK
  uses: actions/upload-artifact@v3
  with:
    name: app-release
    path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📊 Comparación de Rendimiento

### Testing Secuencial vs Paralelo

| Método | Tiempo | Velocidad |
|--------|--------|-----------|
| `flutter test` (secuencial) | ~60s | 1x |
| `test_runner.py --workers 4` | ~15s | 4x |
| `test_runner.py --workers 8` | ~10s | 6x |

### Build Manual vs Automatizado

| Método | Pasos | Tiempo |
|--------|-------|--------|
| Manual | 3 comandos | ~3 min |
| `build_bot.py` | 1 comando | ~2.5 min + métricas |

---

## ⚙️ Requisitos

- **Python**: 3.8 o superior
- **Flutter**: 3.0 o superior
- **Sistema Operativo**: Linux, macOS, Windows

**Dependencias Python**: Ninguna (solo stdlib)

---

## 🛠️ Solución de Problemas

### Test Runner

**Error: "Directorio de tests no encontrado"**
```bash
# Verificar que estás en la raíz del proyecto
cd /path/to/Tokyo-Predictor-Roulette-001
python3 scripts/automation/test_runner.py
```

**Error: "flutter: command not found"**
```bash
# Agregar Flutter al PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Build Bot

**Error: "Flutter clean failed"**
```bash
# Verificar permisos de escritura
chmod -R u+w build/
```

**Error: "APK no encontrada"**
- Verificar que el build completó exitosamente
- Revisar logs de errores en la salida

---

## 📝 Mejoras Futuras

- [ ] Soporte para iOS (build IPA)
- [ ] Integración con Codecov
- [ ] Notificaciones Slack/Discord
- [ ] Cache inteligente de dependencias
- [ ] Análisis de coverage automático
- [ ] Build incremental

---

## 📞 Contacto

Para problemas o sugerencias sobre estos scripts:
- Abrir issue en GitHub
- Revisar documentación principal en `/docs`

---

**Version**: 1.0.0  
**Última actualización**: Diciembre 2024  
**Mantenido por**: Tokyo Apps Team
