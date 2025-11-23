# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK

### Manualmente
```bash
flutter build apk --release
```

### Automático (CI/CD)
El proyecto incluye un workflow de GitHub Actions que compila automáticamente la APK en cada push o pull request a las ramas `main` o `master`.

**Ubicación del workflow**: `.github/workflows/build-apk.yml`

**Cómo descargar la APK compilada automáticamente**:
1. Ve a la pestaña [Actions](../../actions) en GitHub
2. Selecciona la ejecución del workflow "Build Android APK"
3. Descarga el artefacto `app-release-apk`
4. El artefacto estará disponible por 30 días

**Características del workflow**:
- ✅ Compilación automática con Flutter estable
- ✅ Caché de dependencias para builds más rápidos
- ✅ Análisis de código con `flutter analyze`
- ✅ Artefactos comprimidos y listos para instalar

**Disclaimer**: Solo simulación. No promueve gambling real.

---

## CI/CD

El proyecto cuenta con integración continua a través de GitHub Actions:

### Workflow de Build APK
- **Archivo**: `.github/workflows/build-apk.yml`
- **Trigger**: Push o PR a ramas `main`/`master`
- **Output**: APK firmada disponible como artefacto por 30 días
- **Características**: 
  - Flutter estable con caché
  - Análisis estático del código
  - Verificación automática del build

---

## Fases del Proyecto

### 1. Definición y planificación
- [ ] Redactar objetivo y alcance del proyecto
- [ ] Identificar requerimientos y entregables principales
- [ ] Crear roadmap con hitos y fechas estimadas
- [ ] Asignar responsables a cada tarea

### 2. Diseño técnico y documentación inicial
- [ ] Crear documentación técnica básica (arquitectura, flujo, APIs)
- [ ] Revisar dependencias y recursos necesarios
- [ ] Validar diseño y recibir feedback

### 3. Desarrollo incremental
- [ ] Implementar funcionalidades según el roadmap
- [ ] Realizar revisiones de código y PR siguiendo checklist
- [ ] Actualizar documentación según cambios realizados

### 4. Pruebas
- [ ] Ejecutar pruebas unitarias y funcionales
- [ ] Validar requisitos y criterios de aceptación
- [ ] Corregir errores detectados

### 5. Despliegue y cierre de fase
- [ ] Preparar ambiente de release
- [ ] Documentar lecciones aprendidas
- [ ] Presentar entregables y cerrar fase