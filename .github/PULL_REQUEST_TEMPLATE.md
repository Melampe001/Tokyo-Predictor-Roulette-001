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

- [ ] He seguido las guías de estilo y he ejecutado `make fmt`
- [ ] He ejecutado `make test` y los tests pasan
- [ ] He actualizado la documentación cuando procede

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

## Checklist de Integración y Agentes

- [ ] 1) Build y compilación — Responsable: @team/owner
  - Tipo de agente requerido: CI runner (por ejemplo GitHub Actions: ubuntu-latest, macos-latest)

- [ ] 2) Tests unitarios y de integración — Responsable: @team/owner
  - Tipo de agente requerido: CI runner + emulador/device-farm según el caso

- [ ] 3) Lint y formato — Responsable: @team/owner
  - Tipo de agente requerido: Bot/Action (dart analyze, dart format)

- [ ] 4) Seguridad y dependencias — Responsable: @team/owner
  - Tipo de agente requerido: Dependabot/Snyk + revisor humano

- [ ] 5) Accesibilidad y localización — Responsable: @team/owner
  - Tipo de agente requerido: Revisor humano + linters automáticos

- [ ] 6) Performance y tamaño — Responsable: @team/owner
  - Tipo de agente requerido: Job de benchmarking automatizado + revisor humano

- [ ] 7) Pruebas en dispositivos reales — Responsable: @team/owner
  - Tipo de agente requerido: Device farm o equipo humano con dispositivos

- [ ] 8) Breaking changes y compatibilidad de API — Responsable: @team/owner
  - Tipo de agente requerido: Revisor humano (owner) + detector automatizado

- [ ] 9) Licencias y cumplimiento legal — Responsable: @team/owner
  - Tipo de agente requerido: Revisor legal + escáner automatizado

- [ ] 10) Documentación y PR template — Responsable: @team/owner
  - Tipo de agente requerido: Autor humano y revisor documental

## Notas adicionales
