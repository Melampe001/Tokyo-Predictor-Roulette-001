# Guía de Usuario - Tokyo Roulette Predicciones

## Introducción

Tokyo Roulette Predicciones es un **simulador educativo** de ruleta europea diseñado para enseñar sobre probabilidades, estrategias de apuestas y gestión de bankroll. Esta aplicación **NO** involucra dinero real y está pensada únicamente con fines educativos.

## Características Principales

### 🎯 Simulador de Ruleta Europea
- Ruleta con números del 0 al 36
- RNG (Random Number Generator) criptográficamente seguro
- Visualización con colores: Rojo, Negro y Verde (0)

### 💡 Sistema de Predicciones
- Analiza el historial reciente de giros
- Sugiere números basándose en frecuencia
- **Importante**: Las predicciones son para fines educativos, en una ruleta real cada giro es independiente

### 📈 Estrategia Martingale
- Sistema de apuestas progresivo
- Duplica la apuesta tras cada pérdida
- Vuelve a la apuesta base tras ganar
- **Advertencia**: Esta estrategia tiene riesgos significativos en juegos reales

### 💰 Simulación de Balance
- Balance inicial: $1000
- Apuesta base: $10
- Simula pérdidas y ganancias en cada giro

## Cómo Usar la Aplicación

### 1. Inicio de Sesión
Al abrir la aplicación:
1. Ingresa un email (no requiere ser real en esta versión)
2. Presiona "Registrar y Continuar"
3. Llegarás a la pantalla principal de la ruleta

### 2. Pantalla Principal

#### Área de Balance
- **Balance actual**: Muestra tu dinero virtual disponible
- **Apuesta actual**: Cantidad que apostarás en el próximo giro
- **Resultado anterior**: Te indica si ganaste o perdiste en el último giro

#### Resultado de la Ruleta
- Círculo grande con el número que salió
- Colores:
  - 🔴 **Rojo**: 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
  - ⚫ **Negro**: 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
  - 🟢 **Verde**: 0

#### Predicción Sugerida
- Aparece después del primer giro
- Muestra el número más frecuente del historial
- Icono de bombilla 💡 para identificarla fácilmente

#### Botón "Girar Ruleta"
- Presiona para hacer un nuevo giro
- Se deshabilitará si tu balance es menor que la apuesta actual
- Cada giro:
  - Genera un número aleatorio
  - Actualiza tu balance
  - Guarda el resultado en el historial
  - Ajusta la apuesta si Martingale está activo

#### Historial Reciente
- Muestra los últimos 20 giros
- Cada número aparece en un círculo con su color correspondiente
- Se actualiza automáticamente tras cada giro
- Los números más recientes aparecen primero

### 3. Menú de Configuración ⚙️

Presiona el icono de engranaje en la parte superior derecha:

#### Estrategia Martingale
- **Activar/Desactivar**: Usa el interruptor
- Cuando está **activa**:
  - La apuesta se duplica automáticamente tras cada pérdida
  - Vuelve a la apuesta base tras ganar
  - Aparece un banner naranja indicando que está activa
- Cuando está **inactiva**:
  - La apuesta se mantiene constante

### 4. Resetear el Juego 🔄

Presiona el icono de reinicio en la parte superior derecha:
- Restaura el balance a $1000
- Limpia el historial
- Reinicia la apuesta a $10
- Resetea la estrategia Martingale

## Lógica de Apuestas

### Sistema Simplificado
En esta versión, la aplicación simula apuestas al **color rojo**:
- Si el número es rojo → Ganas el monto apostado
- Si el número es negro o verde → Pierdes el monto apostado

### Probabilidades
- **Rojo**: 18/37 (48.65%)
- **Negro**: 18/37 (48.65%)
- **Verde (0)**: 1/37 (2.70%)

## Estrategia Martingale Explicada

### ¿Cómo Funciona?
1. Empiezas con una apuesta base (ej: $10)
2. Si ganas → Vuelves a apostar la cantidad base
3. Si pierdes → Duplicas la apuesta ($20, $40, $80...)
4. El objetivo es recuperar pérdidas con una ganancia

### Ejemplo Práctico
```
Giro 1: Apuesta $10 → Pierdes → Balance: $990
Giro 2: Apuesta $20 → Pierdes → Balance: $970
Giro 3: Apuesta $40 → Ganas → Balance: $1010
Giro 4: Apuesta $10 → (vuelve a la base)
```

### ⚠️ Advertencias sobre Martingale
- **Requiere un bankroll grande**: Rachas de pérdidas pueden agotar el balance
- **Límites de mesa**: En casinos reales hay apuestas máximas
- **No garantiza ganancias**: Matemáticamente, la casa siempre tiene ventaja
- **Riesgo exponencial**: La apuesta crece muy rápido

### Cuándo se Detiene
La estrategia se detiene automáticamente si:
- Tu balance es menor que la siguiente apuesta requerida
- Desactivas la estrategia en configuración
- Reseteas el juego

## Sistema de Predicciones

### ¿Cómo Funciona?
El sistema analiza los últimos giros y sugiere el número que ha salido con mayor frecuencia.

### Ejemplo
Si el historial es: `[5, 12, 5, 23, 5, 8]`
- La predicción será: **5** (aparece 3 veces)

### ⚠️ Nota Educativa Importante
- **En una ruleta real**: Cada giro es independiente
- **No existe "memoria"**: El número anterior no afecta al siguiente
- **Falacia del jugador**: Creer que "el rojo debe salir" tras muchos negros es un error común
- **Propósito educativo**: Este sistema existe para ilustrar patrones, no para predecir resultados reales

## Consejos de Uso

### Para Aprendizaje
1. **Experimenta con Martingale**: Actívala y observa cómo crece la apuesta tras pérdidas
2. **Observa las rachas**: ¿Cuántos rojos/negros seguidos pueden salir?
3. **Gestión de bankroll**: Intenta hacer durar tu balance el mayor tiempo posible
4. **Anota patrones**: ¿Qué estrategia te dio mejores resultados?

### Para Diversión
1. **Establece un límite**: Decide cuándo parar (ej: al llegar a $500 o $1500)
2. **Prueba diferentes estrategias**: Alterna entre Martingale y apuestas fijas
3. **Compite con amigos**: ¿Quién puede multiplicar más su balance?

## Problemas Comunes

### "El botón Girar está deshabilitado"
- Tu balance es menor que la apuesta actual
- Solución: Resetea el juego con el botón 🔄

### "La apuesta es muy alta"
- Martingale está activa y has tenido muchas pérdidas consecutivas
- Solución: Desactiva Martingale o resetea el juego

### "No veo la predicción"
- Las predicciones aparecen después del primer giro
- Necesitas al menos un número en el historial

## Aspectos Técnicos

### Seguridad del RNG
- Usa `Random.secure()` de Dart
- Genera números criptográficamente seguros
- No es predecible ni manipulable

### Almacenamiento Local
- El historial se mantiene en memoria durante la sesión
- Se limpia al resetear o cerrar la app
- Máximo de 20 números en historial

### Rendimiento
- Optimizado para dispositivos móviles
- Sin conexión a internet requerida (salvo Firebase opcional)
- Interfaz fluida con animaciones suaves

## Recursos Educativos

### Conceptos que Aprenderás
- **Probabilidad**: Cálculo de probabilidades en juegos de azar
- **Independencia de eventos**: Cada giro es independiente del anterior
- **Valor esperado**: Por qué la casa siempre gana a largo plazo
- **Gestión de riesgo**: Importancia del bankroll management
- **Sesgos cognitivos**: Falacia del jugador y otros errores comunes

### Lecturas Recomendadas
- "The Theory of Gambling and Statistical Logic" - Richard Epstein
- "Beat the Dealer" - Edward Thorp
- "The Mathematics of Gambling" - Edward Thorp

## Limitaciones Conocidas

1. **Simplificación de apuestas**: Solo simula apuestas a rojo/negro
2. **Sin apuestas múltiples**: No permite apostar a varios números simultáneamente
3. **Sin estadísticas avanzadas**: No guarda estadísticas a largo plazo
4. **Sin modo multijugador**: Es una experiencia individual

## Actualizaciones Futuras (Potenciales)

- [ ] Más tipos de apuestas (números directos, docenas, columnas)
- [ ] Gráficos de estadísticas con fl_chart
- [ ] Múltiples estrategias de apuestas
- [ ] Modo tutorial interactivo
- [ ] Desafíos y logros
- [ ] Comparación con otros jugadores (Firebase)

## Soporte y Contacto

Para reportar problemas o sugerencias:
- Abre un issue en GitHub
- Contacta al desarrollador

## Disclaimer Legal

⚠️ **IMPORTANTE**:

Esta aplicación es **SOLO PARA FINES EDUCATIVOS**. 

- NO involucra dinero real
- NO promueve el juego ni las apuestas
- NO debe usarse para tomar decisiones de apuestas reales
- El juego puede crear adicción - juega responsablemente
- Las probabilidades en juegos reales favorecen siempre a la casa

Si tú o alguien que conoces tiene problemas con el juego, busca ayuda:
- España: 900 200 211 (Juego Responsable)
- México: 55 5533 5533 (Consejo Nacional contra las Adicciones)
- Argentina: 0800 222 1002 (Juego Responsable)

---

**Versión**: 1.0.0  
**Última actualización**: Diciembre 2024  
**Desarrollado con**: Flutter 3.0+
