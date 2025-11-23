# Tokyo Roulette Predicciones

Simulador educativo de ruleta con predicciones, RNG, estrategia Martingale y modelo freemium. Incluye integraciones con Stripe para pagos y Firebase para configuraciones remotas.

## Instalación
1. Clona: `git clone https://github.com/Melampe001/Tokyo-Predictor-Roulette-001.git`
2. `flutter pub get`
3. `flutter run`

## Construir APK

Para una guía completa sobre cómo generar el APK, firma, y automatización, consulta **[BUILD.md](BUILD.md)**.

Para información sobre CI/CD y construcción automática, consulta **[docs/CI-CD-SETUP.md](docs/CI-CD-SETUP.md)**.

### Build Rápido
```bash
# Usando el script automatizado (recomendado)
./build-apk.sh

# O manualmente
flutter build apk --release
```

El APK se generará en `build/app/outputs/flutter-apk/app-release.apk`

**Disclaimer**: Solo simulación. No promueve gambling real.

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