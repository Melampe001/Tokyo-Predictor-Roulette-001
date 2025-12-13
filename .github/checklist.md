# Checklist principal del repositorio

Este archivo centraliza el checklist de calidad y referencia el detalle de agentes en docs/checklist_agents.md. Incluye los puntos mínimos que deben revisarse en los PRs y los tipos de agentes requeridos.

Referencia completa y notas por agente: docs/checklist_agents.md

Resumen rápido de puntos (marcar los aplicables en el PR):

1) Build y compilación
- Tipo de agente requerido: CI runner (por ejemplo GitHub Actions: ubuntu-latest, macos-latest)

2) Tests unitarios y de integración
- Tipo de agente requerido: CI runner + emulador/device-farm según el caso

3) Lint y formato
- Tipo de agente requerido: Bot/Action (dart analyze, dart format)

4) Seguridad y dependencias
- Tipo de agente requerido: Dependabot/Snyk + revisor humano

5) Accesibilidad y localización
- Tipo de agente requerido: Revisor humano + linters automáticos

6) Performance y tamaño
- Tipo de agente requerido: Job de benchmarking automatizado + revisor humano

7) Pruebas en dispositivos reales
- Tipo de agente requerido: Device farm o equipo humano con dispositivos

8) Breaking changes y compatibilidad de API
- Tipo de agente requerido: Revisor humano (owner) + detector automatizado

9) Licencias y cumplimiento legal
- Tipo de agente requerido: Revisor legal + escáner automatizado

10) Documentación y PR template
- Tipo de agente requerido: Autor humano y revisor documental

Plantilla corta (copiar EXACTO) para uso en PRs:

- [ ] Punto del checklist — Responsable: @team/owner
  - Nota importante: Tipo de agente requerido: <humano|CI job|bot|device-farm|scanner> — Especificar: <nombre del agente/job>
  - Cómo añadir/activar: <Instrucción breve para configurar el agente o asignación>
