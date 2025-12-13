# Guía de Contribución

¡Gracias por tu interés en contribuir a Tokyo Roulette Predicciones! Esta guía te ayudará a entender el proceso de contribución y las mejores prácticas del proyecto.

## 📋 Tabla de Contenidos

- [Proceso de Pull Request](#proceso-de-pull-request)
- [Estándares de Código](#estándares-de-código)
- [Workflows de CI/CD](#workflows-de-cicd)
- [Pruebas](#pruebas)
- [Documentación](#documentación)

---

## 🔄 Proceso de Pull Request

### 1. Antes de empezar

1. **Fork el repositorio** y clona tu fork localmente
2. **Crea una rama** desde `main` con un nombre descriptivo:
   ```bash
   git checkout -b feature/nueva-caracteristica
   # o
   git checkout -b fix/correccion-bug
   ```

### 2. Desarrollo local

1. **Instala las dependencias:**
   ```bash
   flutter pub get
   ```

2. **Desarrolla tu cambio** siguiendo los [estándares de código](#estándares-de-código)

3. **Formatea el código:**
   ```bash
   dart format .
   ```

4. **Ejecuta el análisis:**
   ```bash
   flutter analyze
   ```

5. **Ejecuta las pruebas:**
   ```bash
   flutter test
   ```

6. **Compila para verificar (opcional pero recomendado):**
   ```bash
   flutter build apk --release
   ```

### 3. Crear el Pull Request

1. **Haz commit de tus cambios:**
   ```bash
   git add .
   git commit -m "Descripción clara del cambio"
   ```

2. **Push a tu fork:**
   ```bash
   git push origin nombre-de-tu-rama
   ```

3. **Abre un Pull Request** en GitHub hacia la rama `main`

4. **Completa el template del PR** que aparecerá automáticamente:
   - Descripción clara del cambio
   - Tipo de cambio (bug fix, feature, docs, etc.)
   - Pasos para probar
   - Marca todos los checkboxes aplicables

### 4. Durante la revisión

1. **Verifica que los workflows de CI pasen** (verde)
2. **Responde a comentarios** de los revisores
3. **Haz cambios adicionales** si son necesarios
4. **No hagas force push** - añade nuevos commits

### 5. Merge

Una vez aprobado y con todos los checks en verde, un mantenedor hará merge de tu PR.

---

## 💻 Estándares de Código

### Flutter/Dart

Este proyecto sigue las [guías de estilo oficiales de Dart](https://dart.dev/guides/language/effective-dart/style).

#### Formato
- **Siempre** ejecuta `dart format .` antes de commit
- Usa 2 espacios para indentación (configurado automáticamente)
- Líneas máximo 80 caracteres (flexible para strings largos)

#### Nombres
- **Clases:** `PascalCase` (ejemplo: `RouletteLogic`)
- **Funciones y variables:** `camelCase` (ejemplo: `generateSpin`)
- **Constantes:** `lowerCamelCase` (ejemplo: `maxBetAmount`)
- **Archivos:** `snake_case` (ejemplo: `roulette_logic.dart`)

#### Documentación
- Documenta clases y funciones públicas con `///`
- Incluye ejemplos en la documentación cuando sea útil
- Documenta parámetros complejos

```dart
/// Genera un número aleatorio de la ruleta usando RNG seguro.
///
/// Retorna un número entre 0 y 36 (ruleta europea).
/// Cada giro es independiente y no se ve afectado por giros anteriores.
int generateSpin() {
  return wheel[rng.nextInt(wheel.length)];
}
```

#### Estructura de archivos
```
lib/
  main.dart           # Punto de entrada de la app
  roulette_logic.dart # Lógica de negocio
  screens/            # Pantallas de la app (cuando se expanda)
  widgets/            # Widgets reutilizables (cuando se expanda)
  models/             # Modelos de datos (cuando se expanda)
  services/           # Servicios (Firebase, etc.) (cuando se expanda)
```

### Seguridad

⚠️ **IMPORTANTE: NUNCA commits claves API, secrets o datos sensibles**

- NO hardcodear claves en el código
- Usar variables de entorno o `--dart-define`
- El archivo `key.properties` está en `.gitignore` (para keystores Android)
- Revisar que no se expongan datos sensibles en logs

---

## 🤖 Workflows de CI/CD

El proyecto tiene workflows automáticos que se ejecutan en cada PR:

### ✅ Workflows activos

1. **Build APK** (`build-apk.yml`)
   - Compila la APK de Android
   - Sube el artefacto para descarga
   - **Debe pasar** para hacer merge

2. **Lint y Format** (`lint-and-format.yml`)
   - Ejecuta `flutter analyze`
   - Verifica formato con `dart format`
   - **Debe pasar** para hacer merge

3. **Tests** (`test.yml`)
   - Ejecuta `flutter test`
   - Genera reporte de cobertura
   - **Debe pasar** para hacer merge

### ℹ️ Cómo interpretar los checks

- ✅ **Verde:** Todo OK, el cambio pasa los checks
- ❌ **Rojo:** Hay errores que deben corregirse
- 🟡 **Amarillo:** El workflow está en progreso

Si un check falla:
1. Haz clic en "Details" para ver el log
2. Lee el error y corrígelo localmente
3. Haz commit y push del fix
4. El check se ejecutará automáticamente de nuevo

---

## 🧪 Pruebas

### Ejecutar pruebas localmente

```bash
# Todas las pruebas
flutter test

# Con cobertura
flutter test --coverage

# Una prueba específica
flutter test test/widget_test.dart
```

### Tipos de pruebas

1. **Pruebas unitarias:** Prueban lógica de negocio aislada
2. **Pruebas de widgets:** Prueban componentes de UI
3. **Pruebas de integración:** Prueban flujos completos (aún no implementadas)

### Escribir nuevas pruebas

**Siempre agrega pruebas para:**
- Nuevas funcionalidades
- Correcciones de bugs
- Cambios en lógica de negocio

**Ejemplo de prueba unitaria:**
```dart
test('RouletteLogic genera números entre 0 y 36', () {
  final logic = RouletteLogic();
  for (int i = 0; i < 100; i++) {
    final spin = logic.generateSpin();
    expect(spin, greaterThanOrEqualTo(0));
    expect(spin, lessThanOrEqualTo(36));
  }
});
```

---

## 📚 Documentación

### Archivos de documentación

- **README.md** - Información general del proyecto
- **CONTRIBUTING.md** - Esta guía
- **.github/PULL_REQUEST_TEMPLATE.md** - Template de PR
- **.github/checklist.md** - Checklist de verificación
- **.github/workflows/README.md** - Documentación de workflows
- **docs/checklist_agents.md** - Checklist detallado

### Cuándo actualizar documentación

Actualiza la documentación cuando:
- Agregues nuevas funcionalidades públicas
- Cambies el proceso de build o desarrollo
- Agregues nuevas dependencias importantes
- Cambies la estructura del proyecto
- Modifiques comandos de configuración

---

## 🔍 Checklist de Pre-Commit

Antes de hacer commit, verifica:

- [ ] El código está formateado (`dart format .`)
- [ ] No hay errores de análisis (`flutter analyze`)
- [ ] Las pruebas pasan (`flutter test`)
- [ ] No hay TODOs sin resolver críticos
- [ ] No se commitean secrets o claves API
- [ ] La documentación está actualizada (si aplica)
- [ ] Los comentarios están claros y son útiles

---

## 📖 Recursos Útiles

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Dart](https://dart.dev/guides)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Testing](https://docs.flutter.dev/testing)
- [GitHub Actions para Flutter](https://docs.flutter.dev/deployment/cd#github-actions)

---

## ❓ Preguntas

Si tienes preguntas sobre cómo contribuir:

1. Revisa la documentación existente
2. Busca en issues cerrados para ver si alguien ya preguntó
3. Abre un nuevo issue con la etiqueta `question`

---

## 🎉 ¡Gracias!

Tu contribución es valiosa y apreciada. ¡Gracias por hacer este proyecto mejor!
