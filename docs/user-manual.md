# 📖 Manual de Usuario - TokyoIA Roulette Predictor

## Guía Completa para Usar la App

---

## 📱 1. Primeros Pasos

### 1.1 Registro e Inicio de Sesión

1. **Descarga** la app desde Google Play Store
2. **Abre** la app y selecciona "Crear cuenta"
3. **Ingresa** tu email y crea una contraseña segura (mínimo 8 caracteres)
4. **Verifica** tu email haciendo clic en el enlace enviado
5. **Inicia sesión** con tus credenciales

#### Opciones de Login:
- ✅ **Email + Contraseña** (método principal)
- ✅ **Huella digital / Biometría** (dispositivos compatibles)
- ✅ **Google Sign-In** (opcional)

### 1.2 Configuración Inicial

```
Ajustes recomendados:
├── Activar notificaciones → Para ofertas y recordatorios
├── Configurar biometría → Login rápido y seguro
├── Seleccionar idioma → Español / English
└── Elegir tema → Claro / Oscuro / Sistema
```

---

## 🎰 2. La Ruleta

### 2.1 Tipos de Ruleta

| Tipo | Números | Casa Edge | Descripción |
|------|---------|-----------|-------------|
| **Europea** | 0-36 (37 números) | 2.7% | Un solo cero, más favorable |
| **Americana** | 0-36 + 00 (38 números) | 5.26% | Doble cero, mayor ventaja casa |

### 2.2 Pantalla Principal de Ruleta

```
┌─────────────────────────────────────────────┐
│  [Europea ▼]     Velocidad: [Normal ▼]      │
├──────────────────┬──────────────────────────┤
│                  │    📊 ESTADÍSTICAS       │
│   🎡 RULETA      │  ─────────────────────   │
│                  │  Hot: 7, 23, 32          │
│   Último: 17     │  Cold: 0, 5, 34          │
│                  │  Últimos 50: Ver más →   │
├──────────────────┴──────────────────────────┤
│  Spins: [100]   Stake: [$10]   Max: [$500] │
├─────────────────────────────────────────────┤
│  [▶ SIMULAR]  [⏹ PARAR]  [📤 EXPORTAR CSV] │
└─────────────────────────────────────────────┘
```

### 2.3 Parámetros de Simulación

| Parámetro | Descripción | Rango |
|-----------|-------------|-------|
| **Número de spins** | Cuántas vueltas simular | 1 - 10,000 |
| **Stake inicial** | Apuesta base en unidades | $1 - $1,000 |
| **Límite máximo** | Stop-loss para protección | Configurable |
| **Velocidad** | Lento / Normal / Rápido | 3 niveles |

---

## 🧠 3. Estrategias de Apuesta

### 3.1 Martingale (Duplicación)

**Concepto**: Duplicar la apuesta después de cada pérdida.

```
Ejemplo:
Pérdida $10 → Apuesta $20
Pérdida $20 → Apuesta $40
Ganancia $40 → Volver a $10
```

**Parámetros configurables:**
- Apuesta base: $1-$100
- Stop-loss: Límite de pérdidas
- Niveles máximos: 1-10 duplicaciones

⚠️ **Riesgo**: Requiere capital grande, límites de mesa pueden detenerla.

---

### 3.2 Fibonacci (Secuencia Matemática)

**Concepto**: Seguir la secuencia 1, 1, 2, 3, 5, 8, 13, 21...

```
Secuencia: 1 → 1 → 2 → 3 → 5 → 8 → 13 → 21
           ↑                              ↑
        Inicio                    Después de 6 pérdidas
```

**Parámetros configurables:**
- Unidad base
- Secuencia personalizada (opcional)
- Retroceso en ganancia: -1 o -2 posiciones

⚠️ **Riesgo**: Progresión más lenta que Martingale pero aún exponencial.

---

### 3.3 D'Alembert (Progresión Lineal)

**Concepto**: +1 unidad tras pérdida, -1 unidad tras ganancia.

```
Pérdida → Apuesta + 1 unidad
Ganancia → Apuesta - 1 unidad
Mínimo siempre = 1 unidad
```

**Parámetros configurables:**
- Unidad base
- Incremento/decremento personalizado
- Tope máximo

✅ **Ventaja**: Progresión conservadora, menor riesgo.

---

### 3.4 Anti-Martingale / Paroli (Progresión Positiva)

**Concepto**: Aumentar apuesta tras GANANCIA (capitalizar rachas).

```
Ganancia → Duplicar apuesta
Pérdida → Volver a apuesta base
Racha objetivo: 3 ganancias consecutivas
```

**Parámetros configurables:**
- Apuesta base
- Multiplicador (x2, x1.5, etc.)
- Rachas a mantener (1-5)

✅ **Ventaja**: Limita pérdidas, aprovecha rachas ganadoras.

---

### 3.5 Selector de Estrategias (UI)

```
┌─────────────────────────────────────────┐
│         SELECCIONAR ESTRATEGIA          │
├─────────────────────────────────────────┤
│  ○ Martingale        [Configurar ⚙️]    │
│  ○ Fibonacci         [Configurar ⚙️]    │
│  ● D'Alembert        [Configurar ⚙️]    │  ← Seleccionada
│  ○ Anti-Martingale   [Configurar ⚙️]    │
├─────────────────────────────────────────┤
│  [💾 Guardar Preset]  [📂 Cargar Preset]│
└─────────────────────────────────────────┘
```

---

## 📊 4. Estadísticas y Reportes

### 4.1 Panel de Estadísticas

| Métrica | Descripción |
|---------|-------------|
| **Hot Numbers** | Números con mayor frecuencia (últimos N spins) |
| **Cold Numbers** | Números con menor frecuencia |
| **Ventanas móviles** | Análisis en 50, 100, 300 spins |
| **Heatmap** | Visualización de frecuencias |
| **Balance** | Ganancia/pérdida simulada |

### 4.2 Exportar Datos

- **CSV**: Historial completo de sesiones
- **PDF**: Reporte resumido (Premium)
- **Compartir**: Enviar estadísticas por email

---

## 💎 5. Planes de Suscripción

### 5.1 Comparativa de Planes

| Característica | Free | Advanced | Premium |
|----------------|------|----------|---------|
| Simulaciones/día | 100 | Ilimitadas | Ilimitadas |
| Estrategias | 1 (Martingale) | 4 | 4 + Custom |
| Historial | 7 días | 90 días | Ilimitado |
| Exportar CSV | ❌ | ✅ | ✅ |
| Exportar PDF | ❌ | ❌ | ✅ |
| Soporte | Comunidad | Email | Prioritario |
| Precio | Gratis | $X.XX/mes | $XX.XX/mes |

### 5.2 Descuentos

- **6 meses**: 10% descuento
- **12 meses**: 25% descuento
- **Prueba gratuita**: 7 días (Advanced/Premium)

---

## 👥 6. Programa de Referidos

### 6.1 Cómo Funciona

1. **Obtén tu código** único en Ajustes → Referidos
2. **Comparte** el enlace con amigos
3. **Gana créditos** cuando se suscriban

### 6.2 Recompensas

| Acción | Recompensa |
|--------|------------|
| Amigo instala app | 0 créditos (instalación no cuenta) |
| Amigo compra suscripción | 10% del primer pago en créditos |
| Límite mensual | $XX en créditos |
| Caducidad | 6 meses |

> ⚠️ **Importante**: Solo 1 nivel de referidos. No es esquema piramidal.

---

## ⚙️ 7. Ajustes y Configuración

### 7.1 Menú de Ajustes

```
Ajustes
├── 👤 Perfil
│   ├── Cambiar email
│   ├── Cambiar contraseña
│   └── Eliminar cuenta
├── 🔒 Seguridad
│   ├── Activar biometría
│   ├── Sesiones activas
│   └── Verificación en 2 pasos
├── 🔔 Notificaciones
│   ├── Push notifications
│   ├── Email marketing
│   └── Recordatorios
├── 🎨 Apariencia
│   ├── Tema (Claro/Oscuro/Auto)
│   └── Idioma
└── ℹ️ Información
    ├── Manual de uso
    ├── Política de privacidad
    └── Términos de servicio
```

---

## ❓ 8. Preguntas Frecuentes (FAQ)

### ¿Esta app predice resultados de casinos reales?

**NO.** TokyoIA es un simulador educativo. Los casinos reales usan RNG certificados que son independientes y aleatorios. Ninguna estrategia garantiza ganancias.

### ¿Por qué mis simulaciones no coinciden con el casino real?

Cada simulación usa su propio RNG. Los resultados son independientes y no tienen relación con casinos externos.

### ¿Puedo obtener reembolso de mi suscripción?

Los reembolsos se gestionan a través de Google Play según sus políticas estándar.

### ¿Cómo elimino mi cuenta?

Ajustes → Perfil → Eliminar cuenta. Tus datos se eliminarán en 30 días.

---

## 📞 9. Soporte

### Contacto

- **Email**: support@tokyoia-apps.com
- **In-app**: Ajustes → Ayuda → Contactar soporte
- **FAQ**: Ajustes → Ayuda → Preguntas frecuentes

### Reportar Bug

1. Ve a Ajustes → Ayuda → Reportar problema
2. Describe el error detalladamente
3. Adjunta capturas de pantalla si es posible

---

## ⚠️ 10. Disclaimer Legal

> **TokyoIA Roulette Predictor es un simulador educativo.**
> 
> - NO garantiza ganancias en casinos reales
> - NO está afiliado a ningún casino
> - Las estrategias son simulaciones matemáticas
> - El juego puede ser adictivo - juega responsablemente
> - Debes ser mayor de 18 años para usar esta app

**Si tienes problemas con el juego, busca ayuda:**
- Jugadores Anónimos: www.jugadoresanonimos.org
- Línea de ayuda: [número local]

---

*Manual v1.0 - Noviembre 2024*
