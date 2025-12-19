# Assets - assets/

Este directorio contiene todos los recursos estáticos de la aplicación Tokyo Roulette.

## 📁 Estructura

```
assets/
├── images/         # Imágenes, iconos y gráficos
└── screenshots/    # Capturas de pantalla para documentación
```

## 🖼️ Subdirectorios

### images/

**Propósito**: Imágenes e iconos usados en la aplicación

**Contenido esperado**:
- Logo de la aplicación
- Iconos personalizados
- Imágenes de fondo
- Gráficos UI

**Convenciones de nombres**:
```
logo.png              # Logo principal
icon_*.png            # Iconos (icon_spin.png, icon_settings.png)
background_*.png      # Fondos
illustration_*.png    # Ilustraciones
```

### screenshots/

**Propósito**: Capturas de pantalla para README y documentación

**Contenido actual**:
- Screenshot_20251024-232812.Grok.png
- Screenshot_20251024-232835.Grok.png
- Screenshot_20251024-232847.Grok.png
- Screenshot_20251024-233027.Chrome.png
- Screenshot_20251024-233038.Chrome.png
- Screenshot_20251024-233122.Grok.png

**Convenciones de nombres**:
```
Screenshot_YYYYMMDD-HHMMSS.Source.png
```

## 🎨 Formatos Soportados

### Imágenes

| Formato | Uso Recomendado | Notas |
|---------|-----------------|-------|
| PNG | Iconos, logos, transparencias | Sin compresión con pérdida |
| JPG/JPEG | Fotografías, fondos | Menor tamaño de archivo |
| WebP | Imágenes web modernas | Mejor compresión |
| SVG | Iconos vectoriales | Escalable sin pérdida |

### Otros Assets (Futuro)

| Tipo | Formato | Ubicación |
|------|---------|-----------|
| Fuentes | TTF, OTF | `assets/fonts/` |
| Audio | MP3, WAV | `assets/sounds/` |
| Video | MP4 | `assets/videos/` |
| JSON | JSON | `assets/data/` |

## 📏 Tamaños Recomendados

### Íconos de App

```
Android:
- hdpi: 72x72
- mdpi: 48x48
- xhdpi: 96x96
- xxhdpi: 144x144
- xxxhdpi: 192x192

iOS:
- @1x: 1024x1024 (App Store)
- @2x: 120x120
- @3x: 180x180
```

### Screenshots

```
Android:
- Teléfono: 1080x1920 o 1440x2560
- Tablet: 1600x2560 o 2048x2732

iOS:
- iPhone: 1242x2688 o 1284x2778
- iPad: 2048x2732
```

### Imágenes UI

```
Small: 100-300px
Medium: 300-600px
Large: 600-1200px
Full: 1200px+
```

## 🔧 Configuración en pubspec.yaml

Para que Flutter reconozca los assets, deben estar declarados en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/screenshots/
```

## 💾 Optimización de Assets

### Comprimir Imágenes

```bash
# Usando ImageMagick
convert input.png -quality 85 output.png

# Usando pngquant
pngquant --quality=65-80 image.png

# Usando TinyPNG (web)
# https://tinypng.com/
```

### Generar Diferentes Resoluciones

```bash
# Crear versiones @2x y @3x
convert original.png -resize 50% original@2x.png
convert original.png -resize 33% original@1x.png
```

### Convertir a WebP

```bash
# Instalar cwebp
sudo apt-get install webp

# Convertir PNG/JPG a WebP
cwebp -q 80 input.png -o output.webp
```

## 🎯 Buenas Prácticas

### ✅ Hacer

- **Optimizar tamaño**: Comprimir antes de agregar
- **Nombres descriptivos**: `icon_spin_button.png` no `img1.png`
- **Organizar en carpetas**: Por tipo o feature
- **Usar formatos apropiados**: PNG para transparencias, JPG para fotos
- **Proporcionar @2x/@3x**: Para diferentes densidades de pantalla
- **Documentar origen**: Si son de terceros, indicar licencia

### ❌ Evitar

- Assets sin optimizar (archivos muy grandes)
- Nombres genéricos o confusos
- Mezclar assets de diferentes features
- Usar solo PNG para todo
- Olvidar declarar en pubspec.yaml
- Assets sin uso (limpieza regular)

## 📱 Acceder a Assets en Código

### Cargar Imagen

```dart
// Desde assets
Image.asset('assets/images/logo.png')

// Con tamaño específico
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)

// Con manejo de errores
Image.asset(
  'assets/images/logo.png',
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
)
```

### Cargar Datos JSON

```dart
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/data/config.json');
}
```

## 🔍 Buscar Assets No Usados

```bash
# Buscar imágenes en assets/
find assets -type f -name "*.png"

# Buscar referencias en código
grep -r "assets/images/" lib/

# Comparar para encontrar no usados
```

## 📊 Límites de Tamaño

### Recomendaciones

- **Archivo individual**: < 500KB (ideal < 100KB)
- **Assets totales**: < 20MB para app móvil
- **Screenshots para docs**: < 1MB cada una

### Verificar Tamaño

```bash
# Tamaño de directorio assets/
du -sh assets/

# Listar archivos por tamaño
du -ah assets/ | sort -rh | head -20

# Archivos mayores a 500KB
find assets/ -type f -size +500k -exec ls -lh {} \;
```

## 🖼️ Screenshots para Documentación

### Mejores Prácticas

1. **Resolución Alta**: 1080p mínimo
2. **Contenido Claro**: UI legible
3. **Sin Datos Sensibles**: No mostrar info real
4. **Consistencia**: Mismo tema/modo
5. **Formato**: PNG para UI, JPG para fotos
6. **Nombres Descriptivos**: Indica qué muestra cada screenshot

### Capturar Screenshots

#### En Emulador/Simulador

```bash
# Android (adb)
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png

# iOS Simulator
xcrun simctl io booted screenshot screenshot.png

# Flutter DevTools
# Take screenshot desde DevTools Inspector
```

#### En Dispositivo Real

- Android: Vol Down + Power
- iOS: Side Button + Volume Up

## 📦 Assets en Release

### Android

Assets se empaquetan en APK/AAB automáticamente.

### iOS

Assets se incluyen en el bundle de la app.

### Web

Assets se sirven desde carpeta `build/web/assets/`.

## 🔐 Seguridad

### ⚠️ NO incluir en assets:

- API keys o secrets
- Contraseñas
- Certificados privados
- Datos de usuario
- Configuraciones sensibles

### ✅ Seguro incluir:

- Imágenes públicas
- Iconos
- Fuentes
- Datos de ejemplo
- Configuración pública

## 📄 Licencias

Si usas assets de terceros, documenta su licencia:

```
assets/
├── images/
│   └── third-party/
│       ├── icon.png           # De FlatIcon (licencia atribuida)
│       └── ATTRIBUTION.md     # Detalles de licencia
```

## 🤝 Contribuir Assets

Al agregar nuevos assets:

1. Optimiza el tamaño
2. Usa nombres descriptivos
3. Actualiza pubspec.yaml si es necesario
4. Documenta origen y licencia si aplica
5. Agrega referencias en código

Ver [CONTRIBUTING.md](../CONTRIBUTING.md) para más detalles.

---

**Mantenido por**: Tokyo Apps Team  
**Última actualización**: Diciembre 2024  
**Total Assets**: ~6 screenshots (sujeto a cambio)
