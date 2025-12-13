# Workflows de CI/CD

Este directorio contiene los workflows de GitHub Actions para el proyecto Tokyo Roulette Predicciones.

## Workflows Activos

### 1. Build APK (`build-apk.yml`)

**Propósito:** Compila automáticamente la APK de Android en modo release.

**Cuándo se ejecuta:**
- En cada push a `main` o `master`
- En cada pull request hacia `main` o `master`

**Pasos principales:**
1. Configura JDK 11 (requerido para Android)
2. Configura Flutter SDK (canal stable)
3. Descarga dependencias con `flutter pub get`
4. Analiza código con `flutter analyze` (no bloquea el build)
5. Compila APK con `flutter build apk --release`
6. Sube la APK como artefacto (disponible 30 días)

**Artefactos generados:**
- `app-release-apk` - APK compilada lista para distribución

---

### 2. Lint y Format (`lint-and-format.yml`)

**Propósito:** Verifica calidad y formato del código Dart/Flutter.

**Cuándo se ejecuta:**
- En cada push a `main` o `master`
- En cada pull request hacia `main` o `master`

**Jobs:**
1. **lint:** Ejecuta `flutter analyze --no-fatal-infos`
2. **format:** Verifica formato con `dart format --set-exit-if-changed`

**Cómo solucionar errores:**
```bash
# Para corregir formato
dart format .

# Para ver problemas de análisis
flutter analyze
```

---

### 3. Tests (`test.yml`)

**Propósito:** Ejecuta pruebas unitarias y de widgets.

**Cuándo se ejecuta:**
- En cada push a `main` o `master`
- En cada pull request hacia `main` o `master`

**Pasos:**
1. Configura Flutter SDK
2. Descarga dependencias
3. Ejecuta `flutter test --coverage`
4. Genera reporte de cobertura

**Cómo ejecutar localmente:**
```bash
flutter test
flutter test --coverage
```

---

## Workflows Inactivos

### azure-webapps-node.yml

⚠️ **Este workflow NO es relevante para este proyecto.**

Este archivo es una plantilla para desplegar aplicaciones Node.js en Azure. El proyecto actual es una aplicación Flutter móvil, no usa Node.js ni Azure.

**Recomendación:** Considerar eliminar este archivo o deshabilitarlo para evitar confusión.

---

## Cómo Añadir Nuevos Workflows

### Dependabot (Recomendado)

Para habilitar escaneo automático de dependencias:

1. Crea el archivo `.github/dependabot.yml`:
```yaml
version: 2
updates:
  - package-ecosystem: "pub"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
```

2. Dependabot creará PRs automáticos para actualizar dependencias.

### Security Scanning

Para escaneo de seguridad con CodeQL:

1. Ve a Settings → Security → Code security and analysis
2. Habilita "Dependabot alerts" y "Dependabot security updates"
3. (Opcional) Habilita "Code scanning" con CodeQL

### Performance Testing

Para añadir benchmarks de rendimiento, crea un nuevo workflow que:
1. Compile la APK en release y debug
2. Compare tamaños
3. Ejecute benchmarks con `flutter drive` si hay tests de integración

---

## Estado de los Workflows

| Workflow | Estado | Propósito |
|----------|--------|-----------|
| build-apk.yml | ✅ Activo | Compilación de APK |
| lint-and-format.yml | ✅ Activo | Calidad de código |
| test.yml | ✅ Activo | Pruebas unitarias |
| azure-webapps-node.yml | ⚠️ No aplicable | Node.js (no usado) |

---

## Solución de Problemas

### El build falla por problemas de keystore

El workflow de build usa una APK sin firmar. Para habilitar firma automática:

1. Genera un keystore
2. Añade secrets en GitHub: `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`
3. Modifica `build-apk.yml` para usar el keystore de los secrets

### Los tests fallan localmente pero pasan en CI

Verifica que estás usando la misma versión de Flutter:
```bash
flutter --version
flutter channel stable
flutter upgrade
```

### El formato falla

Ejecuta localmente antes de hacer commit:
```bash
dart format .
git add .
git commit -m "Format code"
```

---

## Referencias

- [GitHub Actions para Flutter](https://docs.flutter.dev/deployment/cd#github-actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/testing/build-modes)
- [Dart Analysis Options](https://dart.dev/tools/analysis)
