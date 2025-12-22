# 📋 Plan Estratégico - Tokyo Predictor Roulette con IA

## 🎯 Visión General

Transformar el Tokyo Predictor Roulette en un simulador educativo de ruleta de clase mundial, impulsado por inteligencia artificial usando Unity ML-Agents y optimizado para dispositivos móviles Android.

## 🚀 Objetivos Estratégicos

### 1. Integración de IA Avanzada
- **Objetivo**: Implementar un asistente predictivo basado en ML-Agents
- **Tecnología**: Unity ML-Agents Toolkit con algoritmo PPO (Proximal Policy Optimization)
- **Resultado Esperado**: Agente entrenado con 500,000 pasos que analiza patrones en últimos 50 giros
- **Métricas de Éxito**: 
  - Modelo ONNX funcional < 10 MB
  - Inferencia en dispositivo < 100ms
  - Precisión de predicción > 25% (base aleatoria: 18%)

### 2. Desarrollo Multi-Plataforma
- **Plataforma Principal**: Android 8.0+ (API 26)
- **Motor**: Unity 2022.3 LTS
- **Complemento**: Mantener versión Flutter existente
- **Arquitectura**: Híbrida Unity + Flutter para máxima flexibilidad

### 3. Cumplimiento Legal y Ético
- **Categorización**: Entretenimiento educativo (NO gambling real)
- **Target**: Usuarios +18 con advertencias claras
- **Compliance**: Google Play Store 2025 policies
- **Disclaimers**: Visibles en splash screen y configuración

## 📅 Roadmap de Implementación

### Fase 1: Infraestructura (Semanas 1-2) ✅
- [x] Configuración de GitHub Codespaces
- [x] Setup de Unity ML-Agents environment
- [x] Integración de Android SDK y build tools
- [x] Documentación de setup y onboarding

### Fase 2: Desarrollo del Agente IA (Semanas 3-6)
- [ ] Implementación de RouletteAgent.cs
- [ ] Diseño de sistema de recompensas
- [ ] Entrenamiento inicial (100k pasos)
- [ ] Evaluación y ajuste de hiperparámetros
- [ ] Entrenamiento final (500k pasos)
- [ ] Exportación a ONNX

### Fase 3: Integración Unity-Sentis (Semanas 7-8)
- [ ] Implementación de AISentisInference.cs
- [ ] Optimización de inferencia para móviles
- [ ] Tests de performance en dispositivos reales
- [ ] Integración con UI de Unity

### Fase 4: UI/UX y Gamificación (Semanas 9-10)
- [ ] Diseño de interfaz de ruleta 3D en Unity
- [ ] Sistema de sugerencias visuales de IA
- [ ] Animaciones de giros y resultados
- [ ] Dashboard de estadísticas y patrones
- [ ] Sistema de desafíos diarios

### Fase 5: Testing y Optimización (Semanas 11-12)
- [ ] Testing funcional completo
- [ ] Optimización de performance (60 FPS target)
- [ ] Testing de cumplimiento legal
- [ ] Beta testing con usuarios reales
- [ ] Ajustes basados en feedback

### Fase 6: Launch (Semana 13)
- [ ] Build final firmado
- [ ] Submission a Google Play Store
- [ ] Documentación de usuario final
- [ ] Plan de marketing y comunicación

## 🏗️ Arquitectura Técnica

### Stack Tecnológico

```
┌─────────────────────────────────────────┐
│         Frontend (Unity)                │
│  - Ruleta 3D con física realista       │
│  - UI Material Design                   │
│  - Animaciones fluidas                  │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│      IA Layer (ML-Agents + Sentis)      │
│  - RouletteAgent (entrenamiento)        │
│  - AISentisInference (inferencia)       │
│  - Modelo ONNX optimizado               │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│       Backend Services (Firebase)       │
│  - Remote Config                        │
│  - Analytics                            │
│  - Cloud Storage (modelos)              │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│        Platform (Android)               │
│  - Minimum SDK 26 (Android 8.0)        │
│  - Target SDK 34 (Android 14)          │
│  - ARM64 + ARMv7                        │
└─────────────────────────────────────────┘
```

### Componentes Clave

#### 1. RouletteAgent (ML-Agents)
- **Observaciones**: 
  - Últimos 10 números (normalizados 0-1)
  - Color del último número (red/black)
  - Velocidad de la bola
  - Velocidad de rotación de la ruleta
  - Frecuencia de números "calientes"

- **Acciones Discretas**:
  - 0: Apostar a Rojo
  - 1: Apostar a Negro
  - 2: Apostar a Par
  - 3: Apostar a Impar
  - 4: Apostar a número "caliente"

- **Sistema de Recompensas**:
  - +1.0: Predicción correcta de número caliente
  - +0.1: Sugerencia de color/par/impar correcta
  - -0.05: Predicción incorrecta
  - +2.0: Bonus por racha de 3+ aciertos

#### 2. AISentisInference (Inferencia Local)
- Carga modelo ONNX exportado desde ML-Agents
- Ejecuta inferencia en GPU móvil (GPUCompute backend)
- Maneja preprocessing de observaciones
- Retorna índice de acción sugerida

#### 3. RouletteController (Game Logic)
- Gestiona estado del juego
- Registra historial de giros
- Calcula estadísticas (números calientes, frecuencias)
- Interfaz con RouletteAgent

## 🔬 Metodología de Entrenamiento

### Configuración PPO (Proximal Policy Optimization)

```yaml
Hiperparámetros:
  batch_size: 64          # Balance entre estabilidad y velocidad
  buffer_size: 1024       # Memoria de experiencias
  learning_rate: 3e-4     # Tasa de aprendizaje moderada
  beta: 5e-3             # Entropía para exploración
  epsilon: 0.2           # Clip range para estabilidad
  
Red Neuronal:
  hidden_units: 128       # Capacidad para patrones complejos
  num_layers: 2          # Arquitectura profunda pero eficiente
  normalize: true        # Normalización de inputs
  
Entrenamiento:
  max_steps: 500,000     # Pasos totales de entrenamiento
  time_horizon: 64       # Ventana temporal
  checkpoint_interval: 50,000  # Guardar cada 50k pasos
```

### Proceso de Entrenamiento

1. **Exploración Inicial (0-100k pasos)**
   - Agente explora aleatoriamente
   - Aprende correlaciones básicas
   - Recompensas pequeñas pero frecuentes

2. **Refinamiento (100k-300k pasos)**
   - Agente identifica patrones
   - Mejora precisión de predicciones
   - Balancea exploración vs explotación

3. **Optimización Final (300k-500k pasos)**
   - Convergencia de política
   - Maximización de recompensas
   - Estabilización de rendimiento

## 📊 KPIs y Métricas

### Performance Técnico
- **FPS**: ≥ 60 FPS en dispositivos mid-range
- **Tiempo de carga**: < 3 segundos
- **Tamaño de APK**: < 100 MB
- **Latencia de inferencia**: < 100 ms
- **Uso de memoria**: < 200 MB RAM

### Calidad de IA
- **Precisión de predicción**: > 25% (baseline: 18%)
- **Convergencia de entrenamiento**: < 400k pasos
- **Tamaño de modelo**: < 10 MB ONNX
- **Tiempo de inferencia móvil**: < 50 ms

### User Experience
- **Claridad de disclaimers**: 100% visible en onboarding
- **Satisfacción de usuario**: > 4.0/5.0 estrellas
- **Tasa de retención D1**: > 40%
- **Tasa de retención D7**: > 20%

### Compliance
- **Tasa de aprobación Play Store**: 100% (first submission)
- **Incidencias legales**: 0
- **Reports de gambling real**: 0

## 🛡️ Gestión de Riesgos

### Riesgo 1: Rechazo en Play Store
- **Probabilidad**: Media
- **Impacto**: Alto
- **Mitigación**: 
  - Compliance checklist exhaustivo
  - Disclaimers prominentes
  - Categorización correcta
  - Beta testing pre-submission

### Riesgo 2: Performance en Dispositivos Low-End
- **Probabilidad**: Media
- **Impacto**: Medio
- **Mitigación**:
  - Perfilado continuo de performance
  - Optimización de modelos ONNX
  - Fallback a CPU inference
  - Configuración de calidad adaptativa

### Riesgo 3: Expectativas Irreales de Usuarios
- **Probabilidad**: Alta
- **Impacto**: Medio
- **Mitigación**:
  - Educación clara sobre naturaleza aleatoria
  - Disclaimers en cada sesión
  - FAQs sobre limitaciones de IA
  - Moderación de reviews

### Riesgo 4: Complejidad de Setup para Desarrolladores
- **Probabilidad**: Alta
- **Impacto**: Bajo
- **Mitigación**:
  - GitHub Codespaces pre-configurado
  - Scripts de automatización
  - Documentación detallada
  - Video tutoriales

## 💰 Modelo de Negocio (Futuro)

### Versión Gratuita
- 50 giros por día
- Sugerencias básicas de IA
- Ads no intrusivos
- Acceso a desafíos diarios

### Versión Premium ($4.99/mes)
- Giros ilimitados
- Sugerencias avanzadas de IA
- Sin anuncios
- Estadísticas detalladas
- Modelos IA mejorados
- Soporte prioritario

**IMPORTANTE**: Modelo freemium NO basado en compra de fichas o dinero virtual. Solo desbloqueo de funcionalidades educativas.

## 🔐 Consideraciones de Seguridad

### Datos de Usuario
- **NO recolectar**: Información financiera real
- **Minimizar**: Datos personales (solo email opcional)
- **Anonimizar**: Analytics y telemetría
- **Encriptar**: Preferencias locales

### RNG (Random Number Generator)
- **OBLIGATORIO**: Uso de Random.secure() en Dart
- **OBLIGATORIO**: Unity.Mathematics.Random con seed seguro
- **PROHIBIDO**: Algoritmos predecibles
- **AUDITABLE**: Código de RNG open source

### API Keys y Secrets
- **Firebase**: Uso de Remote Config para keys
- **Stripe**: Test mode en development
- **Unity License**: Variables de entorno
- **Android Keystore**: GitHub Secrets

## 📚 Recursos de Aprendizaje

### Para Desarrolladores
- [Unity ML-Agents Documentation](https://github.com/Unity-Technologies/ml-agents/blob/main/docs/Readme.md)
- [Unity Sentis Manual](https://docs.unity3d.com/Packages/com.unity.sentis@latest)
- [PPO Algorithm Explained](https://spinningup.openai.com/en/latest/algorithms/ppo.html)
- [Android Game Optimization](https://developer.android.com/games/optimize)

### Para Usuarios
- Guía de uso de la aplicación
- Tutorial de interpretación de sugerencias IA
- FAQ sobre limitaciones de predicción
- Recursos de juego responsable

## 🤝 Contribuciones y Comunidad

### Cómo Contribuir
1. Fork del repositorio
2. Setup en Codespaces (1-click)
3. Branch feature/nombre-descriptivo
4. Pull Request con tests
5. Code review por maintainers

### Áreas de Contribución Prioritarias
- Mejoras en algoritmo de IA
- Optimizaciones de performance
- Traducciones a otros idiomas
- Tests adicionales
- Documentación

## 📞 Contacto y Soporte

- **Issues**: GitHub Issues para bugs y features
- **Discussions**: GitHub Discussions para preguntas
- **Email**: [Configurar email de contacto]
- **Discord**: [Opcional: Servidor de comunidad]

---

**Versión del Plan**: 1.0.0  
**Fecha de Creación**: Diciembre 2024  
**Última Actualización**: Diciembre 2024  
**Responsables**: Equipo Tokyo Roulette Predictor

## ✅ Criterios de Éxito del Proyecto

El proyecto se considerará exitoso cuando:

1. ✅ GitHub Codespaces configurado y funcional
2. ✅ ML-Agents instalado y ejecutándose sin errores
3. ✅ Modelo IA entrenado y exportado a ONNX
4. ✅ Inferencia funcionando en Android
5. ✅ Build APK generado automáticamente por CI/CD
6. ✅ Compliance legal verificado y documentado
7. ✅ Performance: 60 FPS en dispositivos mid-range
8. ✅ Aprobación en Google Play Store
9. ✅ Documentación completa y actualizada
10. ✅ Tests unitarios y de integración pasando

---

Este plan estratégico es un documento vivo que se actualizará según evolucione el proyecto.
