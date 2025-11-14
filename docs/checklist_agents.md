# Checklist de Integración y Agentes

Este documento se integra en el checklist del repositorio y añade para cada punto una "Nota importante" indicando qué tipo de agente se requiere y cómo activarlo. Pegue o referencie este archivo desde el checklist principal o el template de PR.

Instrucciones de uso:
- Copiar/pegar las secciones relevantes en el checklist o en el PR template.
- Rellenar los campos <nombre del agente/job> con los nombres reales de jobs, runners o servicios que use el proyecto.
- Añadir owners/teams para cada ítem donde corresponda.

Checklist con notas de agente por punto

1) Build y compilación
- Descripción: Verificar que el proyecto compila correctamente (analizar platforms si aplica).
- Nota importante: Identificar si la compilación requiere runners especiales (macOS para iOS, etc.) o contenedores con versiones concretas del SDK.
- Tipo de agente requerido: CI runner (por ejemplo GitHub Actions: ubuntu-latest, macos-latest).
- Cómo añadir/activar: Añadir job en .github/workflows/build.yml con matrix por SDK/plataforma; nombrar job 'build' y documentar el runner en el README de CI.

2) Tests unitarios y de integración
- Descripción: Ejecutar la suite de tests (unit, widget, integration).
- Nota importante: Algunos tests de integración pueden necesitar emuladores o servicios externos (APIs simuladas).
- Tipo de agente requerido: CI runner + emulador/servicio mock o device farm para tests instrumentados.
- Cómo añadir/activar: Añadir workflow 'test' que ejecute 'flutter test' o 'dart test'; para tests de integración agregar steps que inicien emuladores o conecten a device-farm.

3) Lint y formato
- Descripción: Ejecutar dart analyze y dart format (o flutter format).
- Nota importante: Definir si el CI aplicará correcciones automáticas por bot o fallará el CI para revisión humana.
- Tipo de agente requerido: Bot/Action que ejecute formatter y linter, y revisores humanos para reglas no automáticas.
- Cómo añadir/activar: Añadir job 'lint' en workflows; opcional: action que haga auto-commit de fixes y abra PR.

4) Seguridad y dependencias
- Descripción: Escanear dependencias (pub.dev) y buscar vulnerabilidades o licencias problemáticas.
- Nota importante: Automatizar aviso de dependencias inseguras, pero asignar auditor humano para triage.
- Tipo de agente requerido: Escáner automatizado (Dependabot, Snyk) + revisor humano.
- Cómo añadir/activar: Habilitar Dependabot en repo; añadir job de seguridad que ejecute 'dart pub outdated --mode=null-safety' o herramientas externas.

5) Accesibilidad y localización
- Descripción: Revisar accesibilidad (si aplica) y cobertura de i18n.
- Nota importante: Herramientas automáticas detectan fallos, pero se necesita validación humana UX/AA.
- Tipo de agente requerido: Reviewer humano especializado + linters automáticos.
- Cómo añadir/activar: Incluir checklist de accesibilidad en PR template y asignar reviewer específico.

6) Performance y tamaño
- Descripción: Verificar que no se introduzcan regresiones de rendimiento o aumentos inesperados del tamaño del binario.
- Nota importante: Requiere jobs que ejecuten benchmarks y comparen con la línea base histórica.
- Tipo de agente requerido: Job de benchmarking automatizado + ingeniero de rendimiento humano.
- Cómo añadir/activar: Añadir workflow 'perf' que publique resultados en artefactos o en comentarios del PR; etiquetar PR si detecta regresión.

7) Pruebas en dispositivos reales
- Descripción: Validación en dispositivos físicos (Android/iOS) si aplica.
- Nota importante: Identificar coste y acceso a device farms o equipos físicos.
- Tipo de agente requerido: Device farm (Firebase Test Lab, BrowserStack) o equipo humano con dispositivos.
- Cómo añadir/activar: Configurar integration job que envíe builds a device-farm y publique resultados.

8) Breaking changes y compatibilidad de API
- Descripción: Comprobar que cambios en APIs públicas están documentados y versionados.
- Nota importante: Se requiere aprobación del API owner y, si es biblioteca pública, tests de compatibilidad.
- Tipo de agente requerido: Revisor humano (owner) + detector automatizado de breaking changes si existe.
- Cómo añadir/activar: Añadir paso en PR template para indicar si el cambio rompe compatibilidad; asignar owner.

9) Licencias y cumplimiento legal
- Descripción: Revisar cambios en dependencias y licencias.
- Nota importante: Cualquier dependencia nueva con licencia no compatible necesita revisión legal.
- Tipo de agente requerido: Revisor legal/human + escáner automatizado.
- Cómo añadir/activar: Ejecutar job que inspeccione licenses y levantar issue/label para revisión legal.

10) Documentación y PR template
- Descripción: Actualizar docs cuando el cambio afecta comportamiento o APIs.
- Nota importante: PRs deben incluir pasos para reproducir y indicar agentes que se usaron en las pruebas.
- Tipo de agente requerido: Autor humano y revisor documental humano; CI puede validar links y formato.
- Cómo añadir/activar: Añadir entradas obligatorias en PR template: 'Agentes usados', 'Comandos ejecutados', 'Artefactos adjuntos'.

Plantilla corta para insertar en PR template (copiar EXACTO):

- [ ] Punto del checklist — Responsable: @team/owner
  - Nota importante: Tipo de agente requerido: <humano|CI job|bot|device-farm|scanner> — Especificar: <nombre del agente/job>
  - Cómo añadir/activar: <Instrucción breve para configurar el agente o asignación>

Ejemplo:
- [ ] Ejecutar pruebas de integración en dispositivos Android — Responsable: @android-team
  - Nota importante: Tipo de agente requerido: device-farm (Firebase Test Lab) + revisor humano
  - Cómo añadir/activar: Añadir job 'android-integration' en .github/workflows que publique resultados y cree un artefacto; asignar @android-team.

Notas finales:
- Rellenar <nombre del agente/job> con los valores reales del repo.
- Si quiere, puedo abrir un PR que agregue este archivo y/o insertar la sección en un archivo de checklist existente si me indica la ruta del archivo a modificar.
