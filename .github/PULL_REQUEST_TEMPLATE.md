# Pull Request Template

Por favor completa la siguiente plantilla antes de crear el PR. Asegúrate de marcar los puntos relevantes del checklist y de indicar los agentes usados en las pruebas.

## Descripción
- Resumen breve de los cambios:

## Tipo de cambio
- [ ] Bugfix
- [ ] Nueva funcionalidad
- [ ] Documentación
- [ ] Otros (especificar)

## Checklist (obligatorio completar los aplicables)

- [ ] He seguido las guías de estilo y he ejecutado `dart format .`
- [ ] He ejecutado `flutter analyze` y no hay errores
- [ ] He ejecutado `flutter test` y los tests pasan
- [ ] He actualizado la documentación cuando procede
- [ ] Los workflows de CI pasan (verificar en la pestaña Actions)
  - [ ] ✅ CI - Pipeline principal
  - [ ] ✅ Build - Android/iOS/Web builds
  - [ ] ✅ Test - Tests unitarios y de performance
  - [ ] ✅ Lint - Análisis y formato

Plantilla corta para insertar en el checklist (copiar EXACTO):

- [ ] Punto del checklist — Responsable: @team/owner
  - Nota importante: Tipo de agente requerido: <humano|CI job|bot|device-farm|scanner> — Especificar: <nombre del agente/job>
  - Cómo añadir/activar: <Instrucción breve para configurar el agente o asignación>

## Agentes usados en las pruebas
- Agente(s) ejecutado(s): (p.ej. GitHub Action `build`, Firebase Test Lab `android-integration`, etc.)
- Artefactos adjuntos: (enlace a logs, resultados o artefactos)

## Pasos para reproducir
1. 
2. 

## Notas adicionales
