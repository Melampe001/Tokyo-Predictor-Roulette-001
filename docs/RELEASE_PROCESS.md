# 🚀 Proceso de Release - Tokyo Roulette Predictor

Este documento describe el proceso completo para crear y publicar un release de producción.

## 📋 Tabla de Contenidos

1. [Pre-requisitos](#pre-requisitos)
2. [Proceso Manual](#proceso-manual)
3. [Proceso Automático con CI/CD](#proceso-automático-con-cicd)
4. [Verificación de Release](#verificación-de-release)
5. [Troubleshooting](#troubleshooting)

---

## Pre-requisitos

### 1. Keystore Configurado

Antes de hacer un release, necesitas tener un keystore configurado:

```bash
# Generar keystore (solo la primera vez)
./scripts/keystore_manager.sh --generate

# Crear key.properties
./scripts/keystore_manager.sh --create-properties

# Verificar configuración
./scripts/keystore_manager.sh --check-gradle
```

**⚠️ IMPORTANTE**: Guarda el keystore y las contraseñas en un lugar seguro. Si los pierdes, no podrás actualizar tu app en Play Store.

### 2. Tests Pasando

Asegúrate de que todos los tests pasan:

```bash
flutter test
```

### 3. Código Limpio

```bash
# Analizar código
flutter analyze

# Verificar formato
dart format --set-exit-if-changed .
```

---

## Proceso Manual

### Paso 1: Incrementar Versión

Decide el tipo de incremento según los cambios:

- **Major** (1.0.0 → 2.0.0): Cambios incompatibles con versiones anteriores
- **Minor** (1.0.0 → 1.1.0): Nuevas funcionalidades (backward compatible)
- **Patch** (1.0.0 → 1.0.1): Bug fixes

```bash
# Incrementar versión
./scripts/version_manager.sh patch
# o
./scripts/version_manager.sh minor
# o
./scripts/version_manager.sh major
```

Esto actualizará:
- `pubspec.yaml` (versión y build number)
- `CHANGELOG.md` (nueva entrada)

### Paso 2: Revisar Cambios

```bash
# Ver versión actual
./scripts/version_manager.sh current

# Revisar CHANGELOG.md
# Edita CHANGELOG.md para agregar detalles específicos de esta versión
```

### Paso 3: Commit de Versión

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to X.Y.Z"
git push origin main
```

### Paso 4: Crear Tag

```bash
# Opción A: Usar el script
./scripts/version_manager.sh patch --tag

# Opción B: Manual
git tag -a v1.0.1 -m "Release version 1.0.1"
git push origin v1.0.1
```

### Paso 5: Build de Release

```bash
# Build APK y AAB
./scripts/release_builder.sh --all

# Verificar signing
./scripts/release_builder.sh --verify
```

Los archivos generados estarán en:
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/checksums.txt`

### Paso 6: Verificar APK

Instala el APK en un dispositivo físico o emulador:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

Verifica que la app funciona correctamente.

### Paso 7: Crear GitHub Release

1. Ve a: https://github.com/[tu-usuario]/Tokyo-Predictor-Roulette-001/releases/new
2. Selecciona el tag (ej: v1.0.1)
3. Agrega título: "v1.0.1 - Descripción breve"
4. Copia el contenido de CHANGELOG.md para esta versión
5. Adjunta los archivos:
   - `app-release.apk`
   - `app-release.aab`
   - `checksums.txt`
6. Click en "Publish release"

---

## Proceso Automático con CI/CD

El proceso automático se activa cuando haces push de un tag:

### Paso 1: Preparar Release

```bash
# Incrementar versión y crear tag
./scripts/version_manager.sh minor --tag

# Commit cambios
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to 1.1.0"
git push origin main
```

### Paso 2: Push del Tag

```bash
# Push del tag (esto dispara el workflow de release)
git push origin v1.1.0
```

### Paso 3: Monitorear Workflow

1. Ve a: https://github.com/[tu-usuario]/Tokyo-Predictor-Roulette-001/actions
2. Busca el workflow "Release - Automated Release Build"
3. Monitorea el progreso

El workflow automáticamente:
- ✅ Build APK release firmado
- ✅ Build AAB release firmado
- ✅ Genera checksums SHA-256
- ✅ Crea GitHub Release
- ✅ Sube archivos como assets

### Paso 4: Verificar Release

El release estará disponible en:
https://github.com/[tu-usuario]/Tokyo-Predictor-Roulette-001/releases/latest

---

## Verificación de Release

### Verificar Integridad (Checksum)

```bash
# Descargar APK y checksum del release
# Luego verificar:
sha256sum -c app-release.apk.sha256
```

Debe mostrar: `app-release.apk: OK`

### Verificar Signing

```bash
# Con jarsigner
jarsigner -verify -verbose -certs app-release.apk

# Con apksigner (Android SDK)
apksigner verify --verbose app-release.apk
```

### Verificar en Dispositivo

1. Descarga el APK del release
2. Instala en dispositivo Android: `adb install app-release.apk`
3. Abre la app
4. Verifica versión en "Acerca de" o configuración
5. Prueba funcionalidades principales

---

## Troubleshooting

### Error: "Keystore not found"

```bash
# Generar keystore
./scripts/keystore_manager.sh --generate

# Crear key.properties
./scripts/keystore_manager.sh --create-properties
```

### Error: "APK not signed"

Verifica que:
1. Existe `android/key.properties`
2. El keystore existe en la ubicación especificada
3. Las contraseñas son correctas

### Error: "Version conflict"

Si la versión ya existe en Play Store:

```bash
# Incrementar solo el build number
# Edita pubspec.yaml manualmente
# version: 1.0.0+2  (incrementa el +2)
```

### Workflow de Release Falla

Verifica que los secretos de GitHub estén configurados:
- Settings → Secrets and variables → Actions
- Ver [CI_CD_SETUP.md](./CI_CD_SETUP.md) para detalles

### AAB Rechazado por Play Store

El AAB debe estar firmado con el keystore correcto:

```bash
# Verificar signing del AAB
jarsigner -verify -verbose -certs app-release.aab
```

---

## Checklist de Release

Usa este checklist antes de cada release:

- [ ] Tests pasan (`flutter test`)
- [ ] Análisis de código sin errores (`flutter analyze`)
- [ ] Código formateado (`dart format .`)
- [ ] CHANGELOG.md actualizado
- [ ] Versión incrementada en pubspec.yaml
- [ ] Keystore configurado correctamente
- [ ] Build APK exitoso y firmado
- [ ] Build AAB exitoso y firmado
- [ ] APK verificado en dispositivo físico
- [ ] Tag creado y pusheado
- [ ] GitHub Release creado
- [ ] Assets subidos (APK, AAB, checksums)
- [ ] Release notes completas

---

## Comandos Rápidos

```bash
# Workflow completo de release
./scripts/version_manager.sh minor --tag
git add pubspec.yaml CHANGELOG.md
git commit -m "Bump version to X.Y.Z"
git push origin main
git push origin vX.Y.Z

# Build y verificar
./scripts/release_builder.sh --all
./scripts/release_builder.sh --verify

# Ver instrucciones de GitHub Secrets
./scripts/keystore_manager.sh --github-secrets
```

---

## Referencias

- [Flutter Build Documentation](https://docs.flutter.dev/deployment/android)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Semantic Versioning](https://semver.org/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)

---

**Última actualización**: 2025-12-15  
**Versión del documento**: 1.0
