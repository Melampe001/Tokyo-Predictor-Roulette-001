# Documentación - docs/

Este directorio contiene toda la documentación técnica y de usuario del proyecto Tokyo Roulette.

## 📑 Índice de Documentación

### 🎯 Para Usuarios

| Documento | Descripción |
|-----------|-------------|
| [USER_GUIDE.md](USER_GUIDE.md) | Manual completo de usuario de la aplicación |
| [FAQ.md](FAQ.md) | Preguntas frecuentes y respuestas |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Solución de problemas comunes |

### 🏗️ Para Desarrolladores

| Documento | Descripción |
|-----------|-------------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Diseño técnico y arquitectura del sistema |
| [API.md](API.md) | Documentación de APIs principales |
| [FIREBASE_SETUP.md](FIREBASE_SETUP.md) | Configuración de Firebase paso a paso |

### 🏥 Sistema de Salud del Proyecto

| Documento | Descripción |
|-----------|-------------|
| [HEALTH_AGENT.md](HEALTH_AGENT.md) | Sistema de monitoreo de salud del proyecto |
| [HEALTH_AGENT_IMPLEMENTATION_SUMMARY.md](HEALTH_AGENT_IMPLEMENTATION_SUMMARY.md) | Resumen de implementación |
| [HEALTH_AGENT_QUICK_REFERENCE.md](HEALTH_AGENT_QUICK_REFERENCE.md) | Referencia rápida |

### 🧹 Mantenimiento

| Documento | Descripción |
|-----------|-------------|
| [MAINTENANCE_POLICY.md](MAINTENANCE_POLICY.md) | Política de mantenimiento del repositorio |
| [CLEANUP_SCRIPT.md](CLEANUP_SCRIPT.md) | Documentación de scripts de limpieza |
| [POST_CLEANUP_TRACKING.md](POST_CLEANUP_TRACKING.md) | Seguimiento post-limpieza |

### 🤖 Agentes y Automatización

| Documento | Descripción |
|-----------|-------------|
| [AGENT_ANALYSIS.md](AGENT_ANALYSIS.md) | Análisis de agentes custom |
| [checklist_agents.md](checklist_agents.md) | Checklists para agentes |

## 🚀 Inicio Rápido

### Para Nuevos Usuarios

1. Lee [USER_GUIDE.md](USER_GUIDE.md) para aprender a usar la app
2. Consulta [FAQ.md](FAQ.md) para preguntas comunes
3. Si tienes problemas, revisa [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### Para Nuevos Desarrolladores

1. Comienza con [ARCHITECTURE.md](ARCHITECTURE.md) para entender el diseño
2. Revisa [API.md](API.md) para conocer las APIs disponibles
3. Si vas a usar Firebase, sigue [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
4. Lee [../CONTRIBUTING.md](../CONTRIBUTING.md) para convenciones de código

### Para Maintainers

1. Revisa [HEALTH_AGENT.md](HEALTH_AGENT.md) para monitoreo del proyecto
2. Consulta [MAINTENANCE_POLICY.md](MAINTENANCE_POLICY.md) para políticas
3. Usa [CLEANUP_SCRIPT.md](CLEANUP_SCRIPT.md) para tareas de limpieza

## 📚 Estructura de Documentación

```
docs/
├── USER_GUIDE.md                              # Manual de usuario
├── ARCHITECTURE.md                            # Arquitectura técnica
├── API.md                                     # Documentación de APIs
├── FAQ.md                                     # Preguntas frecuentes
├── TROUBLESHOOTING.md                         # Solución de problemas
├── FIREBASE_SETUP.md                          # Setup de Firebase
├── HEALTH_AGENT.md                            # Sistema de salud
├── HEALTH_AGENT_IMPLEMENTATION_SUMMARY.md     # Implementación
├── HEALTH_AGENT_QUICK_REFERENCE.md            # Referencia rápida
├── MAINTENANCE_POLICY.md                      # Política de mantenimiento
├── CLEANUP_SCRIPT.md                          # Scripts de limpieza
├── POST_CLEANUP_TRACKING.md                   # Tracking
├── AGENT_ANALYSIS.md                          # Análisis de agentes
├── checklist_agents.md                        # Checklists
└── README.md                                  # Este archivo (índice)
```

## 🔍 Encontrar Información

### Por Tema

- **Instalación y Setup**: Ver [../README.md](../README.md#-inicio-rápido)
- **Uso de la App**: [USER_GUIDE.md](USER_GUIDE.md)
- **Desarrollo**: [ARCHITECTURE.md](ARCHITECTURE.md) y [API.md](API.md)
- **Firebase**: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- **Problemas**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md) y [FAQ.md](FAQ.md)
- **Contribuir**: [../CONTRIBUTING.md](../CONTRIBUTING.md)
- **Seguridad**: [../SECURITY.md](../SECURITY.md)

### Por Rol

#### 👤 Usuario Final
1. [USER_GUIDE.md](USER_GUIDE.md)
2. [FAQ.md](FAQ.md)
3. [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

#### 💻 Desarrollador
1. [ARCHITECTURE.md](ARCHITECTURE.md)
2. [API.md](API.md)
3. [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
4. [../CONTRIBUTING.md](../CONTRIBUTING.md)

#### 🔧 Maintainer
1. [HEALTH_AGENT.md](HEALTH_AGENT.md)
2. [MAINTENANCE_POLICY.md](MAINTENANCE_POLICY.md)
3. [CLEANUP_SCRIPT.md](CLEANUP_SCRIPT.md)

#### 🔐 Security Researcher
1. [../SECURITY.md](../SECURITY.md)
2. [ARCHITECTURE.md](ARCHITECTURE.md)

## 📝 Contribuir a la Documentación

### Agregar Nueva Documentación

1. Crea el archivo `.md` en este directorio
2. Usa formato Markdown con estructura clara
3. Agrega entrada en este README.md
4. Linkea desde otros documentos relevantes
5. Sigue el estilo de documentos existentes

### Estilo de Documentación

#### Formato de Títulos

```markdown
# Título Principal (H1)
## Sección Principal (H2)
### Subsección (H3)
#### Detalle (H4)
```

#### Listas y Tablas

```markdown
<!-- Lista ordenada -->
1. Primer paso
2. Segundo paso

<!-- Lista no ordenada -->
- Punto importante
- Otro punto

<!-- Tabla -->
| Columna 1 | Columna 2 |
|-----------|-----------|
| Dato 1    | Dato 2    |
```

#### Code Blocks

````markdown
```dart
// Código Dart
final example = 'Hello World';
```

```bash
# Comandos de terminal
flutter run
```
````

#### Callouts y Alertas

```markdown
> ℹ️ **Nota**: Información adicional

> ⚠️ **Advertencia**: Ten cuidado con esto

> ✅ **Recomendación**: Mejor práctica

> ❌ **Error Común**: Evita esto
```

### Actualizar Documentación Existente

1. Verifica que el contenido esté actualizado
2. Corrige errores o información obsoleta
3. Agrega ejemplos si faltan
4. Mejora claridad si es confuso
5. Actualiza fecha de "Última actualización"

## 🔄 Mantenimiento de Docs

### Revisar Regularmente

- [ ] Después de cada release mayor
- [ ] Cuando se agregan features nuevas
- [ ] Cuando cambia arquitectura
- [ ] Si usuarios reportan confusión

### Checklist de Actualización

- [ ] Información técnica correcta
- [ ] Links funcionando
- [ ] Capturas de pantalla actualizadas
- [ ] Ejemplos de código válidos
- [ ] Versiones de dependencias correctas
- [ ] Fecha de actualización renovada

## 🌐 Idioma

- **Primario**: Español
- **Secundario**: Inglés (para algunas secciones técnicas)
- **Comentarios de código**: Español o Inglés aceptable

## 📊 Métricas de Calidad

### Buena Documentación Debe Ser:

- ✅ **Clara**: Fácil de entender
- ✅ **Completa**: Cubre todos los aspectos
- ✅ **Actualizada**: Información correcta
- ✅ **Navegable**: Bien organizada
- ✅ **Ejemplificada**: Con ejemplos prácticos
- ✅ **Referenciada**: Links a recursos relevantes

## 🛠️ Herramientas Útiles

### Previsualizar Markdown

```bash
# VS Code: Ctrl+Shift+V (Cmd+Shift+V en Mac)
# O instala extensión "Markdown Preview Enhanced"

# GitHub: Solo push y verás preview automático
```

### Validar Links

```bash
# Instalar markdown-link-check
npm install -g markdown-link-check

# Verificar links en documento
markdown-link-check docs/README.md
```

### Generar Índice

```bash
# Instalar doctoc
npm install -g doctoc

# Generar TOC automático
doctoc docs/README.md
```

## 📞 Contacto

¿Preguntas sobre la documentación?

- 📧 Email: Thenewtokyocompany@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/discussions)

## 🙏 Contribuidores de Docs

Agradecimientos a todos los que han mejorado la documentación.

Ver contribuidores en: [GitHub Contributors](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/graphs/contributors)

---

**Última actualización**: Diciembre 2024  
**Mantenido por**: Tokyo Apps Team  
**Feedback**: Siempre bienvenido vía [Issues](https://github.com/Melampe001/Tokyo-Predictor-Roulette-001/issues)
