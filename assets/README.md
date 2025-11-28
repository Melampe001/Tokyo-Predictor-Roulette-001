# Tokyo Predictor Roulette - Assets

Esta carpeta contiene los assets de la app incluyendo iconos y pantallas de splash.

## Assets Requeridos

### Icono de la App
- `icon.png` - Icono principal de la app (1024x1024 recomendado)
- Los iconos adaptativos generados se colocarán en `android/app/src/main/res/`

### Pantalla de Splash
- `splash.png` - Fondo de la pantalla de splash

## Generación de Iconos

Para generar iconos adaptativos de Android, usa el paquete `flutter_launcher_icons`:

```bash
flutter pub add flutter_launcher_icons --dev
flutter pub run flutter_launcher_icons
```

## Configuración de Assets

Los assets están configurados en `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

## Guías de Marca

- Color Primario: Tokyo Red (#E60012)
- Color Secundario: Dark Blue (#1A237E)
- Fondo: White (#FFFFFF)

## Contacto

Para assets de marca, contacta: tokraagcorp@gmail.com

---
© 2024 TokyoApps/TokRaggcorp
