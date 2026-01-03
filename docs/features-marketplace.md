# Features from Marketplace — TokyoIA Roulette Predictor

**Versión:** 2025-11-27

**Descripción:** Lista ampliada de funcionalidades basadas en las mejores prácticas y en las apps de simulación/entrenamiento de ruleta más exitosas. Usar como checklist de producto e implementación.

---

## 1. Funcionalidades Principales (UX & Core)

### 1.1 Simulador de Ruleta

- [ ] **Ruleta Europea** (1 cero) - 37 números
- [ ] **Ruleta Americana** (00 + 0) - 38 números
- [ ] Modo visual con animaciones (opción 3D o Lottie)
- [ ] Ajuste de velocidad: lento / normal / rápido
- [ ] Autoplay con límite de spins
- [ ] Opción de detener al superar X pérdidas/ganancias

### 1.2 RNG y Reproducibilidad

- [ ] RNG pseudoaleatorio con seed opcional
- [ ] Opción para reproducir sesiones (replay)
- [ ] Seed compartible para verificar resultados

### 1.3 Simulación Masiva

- [ ] Ejecutar 1K spins con reporte
- [ ] Ejecutar 10K spins con reporte
- [ ] Ejecutar 100K spins con reporte resumido
- [ ] Límites para proteger rendimiento del dispositivo

### 1.4 Exportación de Resultados

- [ ] Exportar a CSV
- [ ] Exportar a JSON
- [ ] Contenido: sesión, apuestas, resultados, ROI

### 1.5 Historial

- [ ] Listar sesiones guardadas
- [ ] Filtros por fecha
- [ ] Filtros por estrategia
- [ ] Filtros por resultado (ganancia/pérdida)

### 1.6 Visualizaciones

- [ ] **Heatmap** de números
- [ ] Heatmap de zonas (rojo/negro, pares/impares)
- [ ] Heatmap de docenas y columnas
- [ ] Estadísticas en ventanas: últimos 50 / 100 / 300 spins

### 1.7 Bet Replay

- [ ] Reproducir paso a paso una sesión guardada
- [ ] Controles: play, pause, step forward, step back
- [ ] Velocidad ajustable de replay

---

## 2. Estrategias Incorporadas (Módulos)

### 2.1 Martingale

- [ ] Implementación base
- [ ] Parámetros configurables:
  - [ ] Apuesta base
  - [ ] Tope de niveles
  - [ ] Stop-loss

### 2.2 Anti-Martingale / Paroli

- [ ] Implementación base
- [ ] Parámetros configurables:
  - [ ] Apuesta base
  - [ ] Niveles a crecer
  - [ ] Reset en pérdida

### 2.3 Fibonacci

- [ ] Implementación base
- [ ] Parámetros configurables:
  - [ ] Secuencia inicial
  - [ ] Límites máximos
  - [ ] Retroceso en ganancia (-1 o -2)

### 2.4 D'Alembert

- [ ] Implementación base
- [ ] Parámetros configurables:
  - [ ] Unidad base
  - [ ] Incremento/decremento
  - [ ] Límites

### 2.5 Sistema de Presets

- [ ] Guardar preset personalizado
- [ ] Cargar preset guardado
- [ ] Compartir preset (código/link)
- [ ] Presets populares pre-configurados

### 2.6 Marketplace Interno (Opcional)

- [ ] Presets populares de la comunidad
- [ ] Presets gratuitos
- [ ] Presets de pago (microtransacciones)

---

## 3. Monetización & Retención

### 3.1 Modelo Freemium

| Plan | Características |
|------|-----------------|
| **Free** | Funciones básicas, límites de runs/export |
| **Advanced** | Estadísticas avanzadas, export ilimitado, presets |
| **Premium** | Acceso total, funciones experimentales, soporte prioritario |

### 3.2 In-App Purchases

**Suscripciones:**
- [ ] 1 mes
- [ ] 6 meses (con descuento ~10%)
- [ ] 12 meses (con descuento ~25%)

**Consumables (opcional):**
- [ ] Packs de "créditos"
- [ ] Packs de "spins extra"

### 3.3 Rewarded Ads

- [ ] Ver video para obtener créditos
- [ ] Límite diario de videos
- [ ] Opción de remover ads (suscripción)

### 3.4 Ofertas de Onboarding

- [ ] Trial 7 días gratis
- [ ] Descuento primer mes (50% off)
- [ ] Bundle de lanzamiento

### 3.5 Engagement Diario

- [ ] Daily login rewards
- [ ] Streak bonuses (rachas)
- [ ] Challenges semanales

### 3.6 Programa de Referidos (Ético)

- [ ] 1 nivel de referido únicamente
- [ ] Crédito por primera compra del referido (10%)
- [ ] Límite de créditos mensual
- [ ] Expiración de créditos (6 meses)
- [ ] Sistema anti-abuso:
  - [ ] Detección de cuentas duplicadas
  - [ ] Rate limits
  - [ ] Verificación si hay retiros

---

## 4. Social / Growth

### 4.1 Compartir

- [ ] Compartir resultados en redes sociales
- [ ] Compartir presets con plantillas visuales
- [ ] Templates para Instagram/Twitter

### 4.2 Invitaciones

- [ ] Invitaciones por enlace único
- [ ] Tracking UTM para campañas
- [ ] Deep links para promociones

### 4.3 Gamificación

- [ ] Badges/logros desbloqueables
- [ ] Leaderboard de simulaciones (opcional)
- [ ] Niveles de usuario

---

## 5. Analytics & Experimentación

### 5.1 Eventos Clave (Firebase Analytics)

```
signup              - Usuario se registra
login               - Usuario inicia sesión
simulate_start      - Inicia simulación
simulate_complete   - Completa simulación
strategy_selected   - Selecciona estrategia
export_csv          - Exporta datos
purchase            - Realiza compra
subscription_start  - Inicia suscripción
subscription_cancel - Cancela suscripción
referral_share      - Comparte código de referido
referral_redeem     - Referido usa código
```

### 5.2 A/B Testing

- [ ] Firebase Remote Config configurado
- [ ] Tests de precios
- [ ] Tests de onboarding copy
- [ ] Tests de ofertas de trial

### 5.3 Crash Reporting

- [ ] Crashlytics integrado
- [ ] Alertas configuradas
- [ ] Simbolización de crashes

### 5.4 Dashboard de Métricas

- [ ] DAU / MAU
- [ ] Churn rate
- [ ] LTV por cohorte
- [ ] Conversion funnel

---

## 6. Seguridad & Compliance

### 6.1 Disclaimers

- [ ] Disclaimer en onboarding: "Simulación educativa — no gambling real"
- [ ] Disclaimer visible en pantalla principal
- [ ] Disclaimer en descripción de Play Store

### 6.2 Validación de Compras

- [ ] Server-side validation de recibos
- [ ] Play Integrity API integrada
- [ ] Detección de compras fraudulentas

### 6.3 Privacidad

- [ ] Política de privacidad con URL pública
- [ ] Data safety declaration en Play Console
- [ ] Opción de eliminar cuenta/datos

### 6.4 Seguridad Técnica

- [ ] Cifrado local AES-256 para datos sensibles
- [ ] R8 / ProGuard activado
- [ ] Certificate pinning (opcional)
- [ ] Detección de root/jailbreak (opcional)

### 6.5 Permisos

- [ ] Solo permisos necesarios
- [ ] Justificación documentada para cada permiso
- [ ] No solicitar QUERY_ALL_PACKAGES sin necesidad

---

## 7. Soporte Técnico y Performance

### 7.1 Optimización de Imágenes

- [ ] Carga por demanda (Glide/Picasso/cached_network_image)
- [ ] Formato WebP para assets
- [ ] Compresión de screenshots

### 7.2 Caching

- [ ] Cache de resultados de simulaciones
- [ ] Límites para simulaciones masivas
- [ ] Limpieza automática de cache antiguo

### 7.3 Backend (Opcional)

- [ ] Almacenamiento de sesiones en la nube
- [ ] Validación server-side
- [ ] Sincronización entre dispositivos

---

## 8. Requerimientos Técnicos (Android)

### 8.1 Herramientas

- [ ] Android Studio (versión reciente)
- [ ] Flutter SDK 3.x+
- [ ] Dart 3.x+

### 8.2 SDK Versions

- [ ] SDK target: 34+
- [ ] SDK mínimo: 23 (recomendado 26)
- [ ] Java 17 / Kotlin 2.x

### 8.3 Dependencias Clave

- [ ] Google Play Billing Library v6+
- [ ] BiometricPrompt para huella
- [ ] Firebase (Auth, Analytics, Crashlytics, Remote Config)

---

## 9. Prioridad MVP (Primera Release)

### Must Have (P0)

1. [ ] Simulador básico (Europea + Americana)
2. [ ] Estrategia Martingale funcional
3. [ ] Export CSV básico
4. [ ] Login email + Biometric local
5. [ ] Google Play Billing con 3 planes
6. [ ] Play Store assets (feature graphic + 4 capturas)
7. [ ] Política de privacidad y disclaimer visible

### Should Have (P1)

8. [ ] Estrategias Fibonacci y D'Alembert
9. [ ] Heatmap básico
10. [ ] Historial de sesiones
11. [ ] Push notifications

### Nice to Have (P2)

12. [ ] Anti-Martingale
13. [ ] Simulación masiva (10K+)
14. [ ] Presets compartibles
15. [ ] Rewarded ads

---

## 10. Notas Legales

⚠️ **IMPORTANTE:**

- **NO** implementar ni promocionar esquemas piramidales
- El programa de referidos debe ser **1 nivel únicamente**
- Incluir límites y control anti-abuso
- Documentar claramente que es una **SIMULACIÓN**
- **NO** es una aplicación para apostar dinero real
- Cumplir con todas las políticas de Google Play

---

*Features Marketplace v1.0 - Noviembre 2024*
