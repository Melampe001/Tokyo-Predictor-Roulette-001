#!/usr/bin/env python3
"""
Project Structure Health Agent
Version: 1.0.0

Sistema automatizado de auditoría y control de estructura de proyectos.
Verifica integridad, consistencia y salud general del proyecto de software.
"""

import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Optional

try:
    import yaml
except ImportError:
    yaml = None


class HealthAgent:
    """Agente principal de auditoría de salud del proyecto."""

    def __init__(self, root_path: str, config_path: Optional[str] = None):
        self.root_path = Path(root_path).resolve()
        self.config = self._load_config(config_path)
        self.issues = {
            'critical': [],
            'warnings': [],
            'passed': []
        }
        self.metrics = {}
        self.score = 0

    def _load_config(self, config_path: Optional[str]) -> dict:
        """Carga la configuración desde archivo YAML o usa valores por defecto."""
        default_config = {
            'agent': {
                'name': 'Project Structure Health Agent',
                'version': '1.0.0'
            },
            'checks': {
                'enabled': [
                    'file_structure',
                    'dependencies',
                    'git_health',
                    'ci_cd',
                    'security',
                    'documentation'
                ]
            },
            'thresholds': {
                'max_open_prs': 10,
                'max_pr_age_days': 30,
                'max_stale_branches': 5,
                'min_test_coverage': 70,
                'max_outdated_dependencies': 5
            },
            'project_type': 'flutter',
            'critical_files': {
                'flutter': [
                    'pubspec.yaml',
                    'lib/main.dart'
                ]
            },
            'ignore_patterns': [
                'build/',
                '.dart_tool/',
                '*.g.dart'
            ]
        }

        if config_path and Path(config_path).exists():
            try:
                if yaml:
                    with open(config_path, 'r', encoding='utf-8') as f:
                        user_config = yaml.safe_load(f)
                        default_config.update(user_config or {})
            except Exception as e:
                print(f"⚠️  Error loading config: {e}. Using defaults.")

        return default_config

    def run_full_scan(self) -> dict:
        """Ejecuta todos los checks habilitados."""
        print("🏥 Iniciando Project Health Check...")
        print(f"📁 Directorio: {self.root_path}")
        print(f"📅 Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

        enabled_checks = self.config['checks']['enabled']

        if 'file_structure' in enabled_checks:
            self._check_file_structure()

        if 'dependencies' in enabled_checks:
            self._check_dependencies()

        if 'git_health' in enabled_checks:
            self._check_git_health()

        if 'ci_cd' in enabled_checks:
            self._check_ci_cd()

        if 'security' in enabled_checks:
            self._check_security()

        if 'documentation' in enabled_checks:
            self._check_documentation()

        self._calculate_score()

        return {
            'score': self.score,
            'issues': self.issues,
            'metrics': self.metrics
        }

    def _check_file_structure(self):
        """A. Verificación de estructura de archivos."""
        print("📂 Verificando estructura de archivos...")

        project_type = self.config.get('project_type', 'flutter')
        critical_files = self.config['critical_files'].get(project_type, [])

        # Verificar archivos críticos
        for file_path in critical_files:
            full_path = self.root_path / file_path
            if full_path.exists():
                self.issues['passed'].append(f"✅ {file_path} existe")
            else:
                self.issues['critical'].append(f"❌ Falta archivo crítico: {file_path}")

        # Verificar archivos generales importantes
        general_files = ['README.md', 'LICENSE', '.gitignore']
        for file_path in general_files:
            full_path = self.root_path / file_path
            if full_path.exists():
                self.issues['passed'].append(f"✅ {file_path} presente")
            else:
                if file_path == 'README.md':
                    self.issues['critical'].append(f"❌ Falta {file_path}")
                else:
                    self.issues['warnings'].append(f"⚠️  Falta {file_path}")

        # Verificar archivos ejecutables con permisos correctos
        script_dirs = ['scripts']
        for script_dir in script_dirs:
            script_path = self.root_path / script_dir
            if script_path.exists():
                for script in script_path.glob('*.sh'):
                    if os.access(script, os.X_OK):
                        self.issues['passed'].append(f"✅ {script.name} tiene permisos de ejecución")
                    else:
                        self.issues['warnings'].append(f"⚠️  {script.name} no tiene permisos de ejecución")

        print(f"   ✓ Estructura de archivos verificada\n")

    def _check_dependencies(self):
        """B. Verificación de dependencias y configuración."""
        print("📦 Verificando dependencias...")

        pubspec_path = self.root_path / 'pubspec.yaml'
        if not pubspec_path.exists():
            self.issues['warnings'].append("⚠️  No se encontró pubspec.yaml")
            print(f"   ⚠️  No se encontró pubspec.yaml\n")
            return

        try:
            if yaml:
                with open(pubspec_path, 'r', encoding='utf-8') as f:
                    pubspec = yaml.safe_load(f)

                deps = pubspec.get('dependencies', {})
                dev_deps = pubspec.get('dev_dependencies', {})
                total_deps = len(deps) + len(dev_deps)

                self.metrics['total_dependencies'] = total_deps
                self.metrics['production_dependencies'] = len(deps)
                self.metrics['dev_dependencies'] = len(dev_deps)

                self.issues['passed'].append(f"✅ pubspec.yaml válido con {total_deps} dependencias")

                # Verificar dependencias deprecadas conocidas
                deprecated = {
                    'charts_flutter': 'Usar fl_chart como reemplazo'
                }

                for dep in deps:
                    if dep in deprecated:
                        self.issues['warnings'].append(
                            f"⚠️  Dependencia deprecada: {dep} - {deprecated[dep]}"
                        )

            print(f"   ✓ Dependencias verificadas ({self.metrics.get('total_dependencies', 0)} total)\n")
        except Exception as e:
            self.issues['warnings'].append(f"⚠️  Error al analizar pubspec.yaml: {e}")
            print(f"   ⚠️  Error al analizar pubspec.yaml\n")

    def _check_git_health(self):
        """C. Verificación de Git y control de versiones."""
        print("🔀 Verificando salud de Git...")

        if not (self.root_path / '.git').exists():
            self.issues['warnings'].append("⚠️  No es un repositorio Git")
            print(f"   ⚠️  No es un repositorio Git\n")
            return

        try:
            # Verificar estado de Git
            result = subprocess.run(
                ['git', 'status', '--porcelain'],
                cwd=self.root_path,
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                changes = result.stdout.strip()
                if changes:
                    change_count = len(changes.split('\n'))
                    self.issues['warnings'].append(
                        f"⚠️  {change_count} archivos con cambios sin committear"
                    )
                else:
                    self.issues['passed'].append("✅ Working directory limpio")

            # Contar branches
            result = subprocess.run(
                ['git', 'branch', '-a'],
                cwd=self.root_path,
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                branches = [b.strip() for b in result.stdout.split('\n') if b.strip()]
                local_branches = [b for b in branches if not b.startswith('remotes/')]
                self.metrics['total_branches'] = len(local_branches)

                if len(local_branches) > self.config['thresholds']['max_stale_branches']:
                    self.issues['warnings'].append(
                        f"⚠️  {len(local_branches)} branches locales (recomendado: <{self.config['thresholds']['max_stale_branches']})"
                    )
                else:
                    self.issues['passed'].append(f"✅ {len(local_branches)} branches locales")

            # Verificar commits recientes
            result = subprocess.run(
                ['git', 'log', '--oneline', '-n', '10'],
                cwd=self.root_path,
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                commits = result.stdout.strip().split('\n')
                self.metrics['recent_commits'] = len([c for c in commits if c])
                self.issues['passed'].append(
                    f"✅ {self.metrics['recent_commits']} commits recientes encontrados"
                )

            print(f"   ✓ Salud de Git verificada\n")

        except subprocess.TimeoutExpired:
            self.issues['warnings'].append("⚠️  Timeout al verificar Git")
            print(f"   ⚠️  Timeout al verificar Git\n")
        except Exception as e:
            self.issues['warnings'].append(f"⚠️  Error al verificar Git: {e}")
            print(f"   ⚠️  Error al verificar Git\n")

    def _check_ci_cd(self):
        """D. Verificación de CI/CD y Workflows."""
        print("🔄 Verificando CI/CD...")

        workflows_path = self.root_path / '.github' / 'workflows'
        if not workflows_path.exists():
            self.issues['warnings'].append("⚠️  No se encontraron workflows de GitHub Actions")
            print(f"   ⚠️  No se encontraron workflows\n")
            return

        workflows = list(workflows_path.glob('*.yml')) + list(workflows_path.glob('*.yaml'))
        self.metrics['workflow_count'] = len(workflows)

        if len(workflows) == 0:
            self.issues['warnings'].append("⚠️  No hay workflows configurados")
        else:
            self.issues['passed'].append(f"✅ {len(workflows)} workflow(s) configurado(s)")

            # Analizar cada workflow
            for workflow in workflows:
                try:
                    with open(workflow, 'r', encoding='utf-8') as f:
                        content = f.read()

                        # Verificar uso de versiones de actions
                        if 'actions/checkout@v4' in content or 'actions/checkout@v3' in content:
                            self.issues['passed'].append(
                                f"✅ {workflow.name}: Usa versión moderna de checkout"
                            )
                        elif 'actions/checkout@v2' in content or 'actions/checkout@v1' in content:
                            self.issues['warnings'].append(
                                f"⚠️  {workflow.name}: Usa versión antigua de checkout"
                            )

                        # Verificar secretos hardcodeados (búsqueda básica)
                        # Buscar patrones de secretos hardcodeados, excluyendo variables y secrets
                        secret_pattern = r'(?:password|token|api[_-]?key|secret)\s*:\s*["\'](?![\$\{])[^"\']{8,}["\']'
                        if re.search(secret_pattern, content, re.IGNORECASE):
                            # Verificar que no sea una referencia a secrets o variables
                            if not re.search(r'\$\{\{\s*secrets\.|env\.', content):
                                self.issues['critical'].append(
                                    f"❌ {workflow.name}: Posible secreto hardcodeado detectado"
                                )

                except Exception as e:
                    self.issues['warnings'].append(
                        f"⚠️  Error al analizar {workflow.name}: {e}"
                    )

        print(f"   ✓ CI/CD verificado ({self.metrics['workflow_count']} workflows)\n")

    def _check_security(self):
        """E. Verificación de seguridad."""
        print("🔒 Verificando seguridad...")

        security_issues = 0

        # Verificar .gitignore
        gitignore_path = self.root_path / '.gitignore'
        if gitignore_path.exists():
            try:
                with open(gitignore_path, 'r', encoding='utf-8') as f:
                    gitignore_content = f.read()

                    # Verificar patrones de seguridad importantes
                    security_patterns = [
                        '*.key',
                        '*.env',
                        'key.properties',
                        '*.jks',
                        '*.keystore'
                    ]

                    missing_patterns = []
                    for pattern in security_patterns:
                        if pattern not in gitignore_content:
                            missing_patterns.append(pattern)

                    if missing_patterns:
                        self.issues['warnings'].append(
                            f"⚠️  .gitignore no incluye: {', '.join(missing_patterns)}"
                        )
                    else:
                        self.issues['passed'].append("✅ .gitignore incluye patrones de seguridad")

            except Exception as e:
                self.issues['warnings'].append(f"⚠️  Error al leer .gitignore: {e}")

        # Buscar archivos sensibles
        sensitive_files = ['.env', 'key.properties', '*.jks', '*.keystore', '*.pem', '*.key']
        found_sensitive = []

        for pattern in sensitive_files:
            matches = list(self.root_path.rglob(pattern))
            if matches:
                for match in matches:
                    # Ignorar archivos en directorios de build
                    if 'build' not in str(match) and '.git' not in str(match):
                        found_sensitive.append(str(match.relative_to(self.root_path)))

        if found_sensitive:
            self.issues['critical'].append(
                f"❌ Archivos sensibles encontrados: {', '.join(found_sensitive[:5])}"
            )
            security_issues += len(found_sensitive)
        else:
            self.issues['passed'].append("✅ No se encontraron archivos sensibles expuestos")

        # Buscar claves/tokens hardcodeados en archivos Dart
        dart_files = list(self.root_path.glob('lib/**/*.dart'))
        suspicious_patterns = [
            (r'api[_-]?key\s*=\s*["\'][^"\']{20,}["\']', 'API key'),
            (r'token\s*=\s*["\'][^"\']{20,}["\']', 'Token'),
            (r'password\s*=\s*["\'][^"\']+["\']', 'Password'),
            (r'secret\s*=\s*["\'][^"\']{20,}["\']', 'Secret')
        ]

        for dart_file in dart_files[:20]:  # Limitar para performance
            try:
                with open(dart_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    for pattern, name in suspicious_patterns:
                        if re.search(pattern, content, re.IGNORECASE):
                            self.issues['warnings'].append(
                                f"⚠️  Posible {name} hardcodeado en {dart_file.name}"
                            )
                            security_issues += 1
                            break
            except Exception:
                pass

        self.metrics['security_issues'] = security_issues
        print(f"   ✓ Seguridad verificada ({security_issues} issues)\n")

    def _check_documentation(self):
        """F. Verificación de documentación."""
        print("📚 Verificando documentación...")

        docs_score = 0
        total_checks = 0

        # Verificar README.md
        readme_path = self.root_path / 'README.md'
        if readme_path.exists():
            try:
                with open(readme_path, 'r', encoding='utf-8') as f:
                    readme_content = f.read().lower()

                    sections = [
                        ('instalación', 'Sección de instalación'),
                        ('uso', 'Sección de uso'),
                        ('contribu', 'Guía de contribución'),
                        ('licen', 'Información de licencia')
                    ]

                    for keyword, description in sections:
                        total_checks += 1
                        if keyword in readme_content:
                            self.issues['passed'].append(f"✅ README contiene {description}")
                            docs_score += 1
                        else:
                            self.issues['warnings'].append(f"⚠️  README sin {description}")

                    # Verificar badges
                    total_checks += 1
                    if '![' in readme_content or 'badge' in readme_content:
                        self.issues['passed'].append("✅ README contiene badges")
                        docs_score += 1
                    else:
                        self.issues['warnings'].append("⚠️  README sin badges")

            except Exception as e:
                self.issues['warnings'].append(f"⚠️  Error al leer README: {e}")
        else:
            total_checks += 5
            self.issues['critical'].append("❌ README.md no existe")

        # Verificar otros documentos importantes
        doc_files = {
            'CHANGELOG.md': 'Changelog',
            'CONTRIBUTING.md': 'Guía de contribución',
            'LICENSE': 'Licencia',
            'SECURITY.md': 'Política de seguridad'
        }

        for doc_file, description in doc_files.items():
            total_checks += 1
            if (self.root_path / doc_file).exists():
                self.issues['passed'].append(f"✅ {description} presente")
                docs_score += 1
            else:
                self.issues['warnings'].append(f"⚠️  Falta {description}")

        # Verificar carpeta docs
        docs_path = self.root_path / 'docs'
        if docs_path.exists() and docs_path.is_dir():
            doc_count = len(list(docs_path.glob('*.md')))
            if doc_count > 0:
                self.issues['passed'].append(f"✅ {doc_count} documento(s) en /docs")
                docs_score += 1
            total_checks += 1
        else:
            self.issues['warnings'].append("⚠️  No existe carpeta /docs")
            total_checks += 1

        self.metrics['documentation_score'] = docs_score
        self.metrics['documentation_total'] = total_checks
        doc_percentage = int((docs_score / total_checks * 100)) if total_checks > 0 else 0
        self.metrics['documentation_percentage'] = doc_percentage

        print(f"   ✓ Documentación verificada ({doc_percentage}% completa)\n")

    def _calculate_score(self):
        """Calcula la puntuación general de salud del proyecto."""
        # Puntuación por categoría (total 100 puntos)
        scores = {
            'file_structure': 20,
            'dependencies': 15,
            'git_health': 15,
            'ci_cd': 15,
            'security': 15,
            'documentation': 10,
            'test_coverage': 10
        }

        total_score = 0

        # File structure: restar puntos por cada archivo crítico faltante
        critical_missing = len([i for i in self.issues['critical'] if 'Falta archivo crítico' in i])
        file_score = max(0, scores['file_structure'] - (critical_missing * 5))
        total_score += file_score

        # Dependencies: score completo si no hay issues críticos
        dep_critical = len([i for i in self.issues['critical'] if 'dependencia' in i.lower()])
        dep_score = max(0, scores['dependencies'] - (dep_critical * 5))
        total_score += dep_score

        # Git health: score completo si está limpio
        git_warnings = len([i for i in self.issues['warnings'] if 'git' in i.lower() or 'branch' in i.lower()])
        git_score = max(0, scores['git_health'] - (git_warnings * 3))
        total_score += git_score

        # CI/CD: puntos por workflows existentes
        workflow_count = self.metrics.get('workflow_count', 0)
        ci_score = min(scores['ci_cd'], workflow_count * 7)
        total_score += ci_score

        # Security: restar puntos por issues de seguridad
        security_issues = self.metrics.get('security_issues', 0)
        security_critical = len([i for i in self.issues['critical'] if 'sensible' in i.lower() or 'hardcodeado' in i.lower()])
        security_score = max(0, scores['security'] - (security_issues * 2) - (security_critical * 5))
        total_score += security_score

        # Documentation: usar el porcentaje calculado
        doc_percentage = self.metrics.get('documentation_percentage', 0)
        doc_score = int(scores['documentation'] * (doc_percentage / 100))
        total_score += doc_score

        # Test coverage: no implementado aún, dar puntos parciales si hay tests
        test_path = self.root_path / 'test'
        if test_path.exists():
            test_files = list(test_path.glob('**/*_test.dart'))
            if test_files:
                total_score += scores['test_coverage'] // 2
        
        self.score = min(100, int(total_score))

    def generate_report(self, output_dir: str = 'reports') -> str:
        """Genera el reporte de salud en formato Markdown."""
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)

        timestamp = datetime.now().strftime('%Y-%m-%d')
        report_file = output_path / f'project-health-report-{timestamp}.md'

        # Determinar nivel de salud
        if self.score >= 85:
            health_emoji = '🟢'
            health_level = 'Excelente'
        elif self.score >= 70:
            health_emoji = '🟡'
            health_level = 'Bueno'
        elif self.score >= 50:
            health_emoji = '🟠'
            health_level = 'Regular'
        else:
            health_emoji = '🔴'
            health_level = 'Crítico'

        # Generar contenido del reporte
        report_content = f"""# Project Health Report

**Date**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  
**Repository**: {self.root_path.name}  
**Agent Version**: {self.config['agent']['version']}

## {health_emoji} Overall Health Score: {self.score}/100 ({health_level})

---

### Critical Issues (🔴)

"""

        if self.issues['critical']:
            for issue in self.issues['critical']:
                report_content += f"- [ ] {issue}\n"
        else:
            report_content += "✨ ¡Sin problemas críticos!\n"

        report_content += "\n### Warnings (🟡)\n\n"

        if self.issues['warnings']:
            for issue in self.issues['warnings'][:15]:  # Limitar a 15
                report_content += f"- [ ] {issue}\n"
            if len(self.issues['warnings']) > 15:
                report_content += f"\n... y {len(self.issues['warnings']) - 15} advertencias más\n"
        else:
            report_content += "✨ ¡Sin advertencias!\n"

        report_content += "\n### Passed Checks (🟢)\n\n"

        if self.issues['passed']:
            for issue in self.issues['passed'][:20]:  # Limitar a 20
                report_content += f"- [x] {issue}\n"
            if len(self.issues['passed']) > 20:
                report_content += f"\n... y {len(self.issues['passed']) - 20} checks más pasaron\n"
        else:
            report_content += "No hay checks que pasaron.\n"

        report_content += "\n---\n\n### Recommendations\n\n"

        # Generar recomendaciones basadas en issues
        recommendations = []
        if self.issues['critical']:
            recommendations.append(
                f"1. **🔴 Alta Prioridad**: Resolver {len(self.issues['critical'])} problema(s) crítico(s)"
            )
        if len(self.issues['warnings']) > 5:
            recommendations.append(
                f"2. **🟡 Media Prioridad**: Atender {len(self.issues['warnings'])} advertencia(s)"
            )
        if self.metrics.get('documentation_percentage', 0) < 70:
            recommendations.append(
                "3. **📚 Baja Prioridad**: Mejorar documentación del proyecto"
            )

        if recommendations:
            report_content += "\n".join(recommendations) + "\n"
        else:
            report_content += "✨ ¡El proyecto está en excelente estado!\n"

        report_content += "\n---\n\n### Metrics\n\n"

        metrics_items = [
            f"- **Health Score**: {self.score}/100 {health_emoji}",
            f"- **Critical Issues**: {len(self.issues['critical'])}",
            f"- **Warnings**: {len(self.issues['warnings'])}",
            f"- **Passed Checks**: {len(self.issues['passed'])}",
        ]

        if 'total_dependencies' in self.metrics:
            metrics_items.append(
                f"- **Dependencies**: {self.metrics['total_dependencies']} total "
                f"({self.metrics.get('production_dependencies', 0)} prod, "
                f"{self.metrics.get('dev_dependencies', 0)} dev)"
            )

        if 'total_branches' in self.metrics:
            metrics_items.append(f"- **Branches**: {self.metrics['total_branches']} local")

        if 'workflow_count' in self.metrics:
            metrics_items.append(f"- **CI/CD Workflows**: {self.metrics['workflow_count']}")

        if 'documentation_percentage' in self.metrics:
            metrics_items.append(
                f"- **Documentation Coverage**: {self.metrics['documentation_percentage']}%"
            )

        if 'security_issues' in self.metrics:
            metrics_items.append(f"- **Security Issues**: {self.metrics['security_issues']}")

        report_content += "\n".join(metrics_items) + "\n"

        report_content += f"""

---

### Scoring Breakdown

```
File Structure:     {20 if not any('crítico' in i for i in self.issues['critical']) else '15'}/20 puntos
Dependencies:       {15 if not any('depend' in i.lower() for i in self.issues['critical']) else '10'}/15 puntos
Git Health:         {15 if len([i for i in self.issues['warnings'] if 'git' in i.lower()]) == 0 else '12'}/15 puntos
CI/CD:              {min(15, self.metrics.get('workflow_count', 0) * 7)}/15 puntos
Security:           {15 if self.metrics.get('security_issues', 0) == 0 else '10'}/15 puntos
Documentation:      {self.metrics.get('documentation_score', 0)}/10 puntos
-----------------------------------
TOTAL:              {self.score}/100 puntos
```

**Health Levels**:
- 🟢 Excelente: 85-100
- 🟡 Bueno: 70-84
- 🟠 Regular: 50-69
- 🔴 Crítico: <50

---

*Reporte generado por {self.config['agent']['name']} v{self.config['agent']['version']}*
"""

        # Escribir reporte
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report_content)

        print(f"📊 Reporte generado: {report_file}")
        return str(report_file)


def main():
    """Función principal del script."""
    parser = argparse.ArgumentParser(
        description='Project Structure Health Agent - Auditoría de proyectos'
    )
    parser.add_argument(
        '--root',
        default='.',
        help='Directorio raíz del proyecto (default: directorio actual)'
    )
    parser.add_argument(
        '--config',
        default='.project-health.yml',
        help='Archivo de configuración (default: .project-health.yml)'
    )
    parser.add_argument(
        '--output',
        default='reports',
        help='Directorio de salida para reportes (default: reports)'
    )
    parser.add_argument(
        '--full-scan',
        action='store_true',
        help='Ejecutar scan completo con todos los checks'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Modo dry-run (no modifica nada, solo muestra resultados)'
    )
    parser.add_argument(
        '--check',
        help='Ejecutar solo checks específicos (separados por coma)'
    )
    parser.add_argument(
        '--json',
        action='store_true',
        help='Generar salida en formato JSON'
    )

    args = parser.parse_args()

    if args.dry_run:
        print("🔍 Modo DRY-RUN activado (sin modificaciones)\n")

    # Verificar si existe archivo de configuración
    config_path = args.config if Path(args.config).exists() else None

    # Crear agente
    agent = HealthAgent(args.root, config_path)

    # Modificar checks si se especificó --check
    if args.check:
        agent.config['checks']['enabled'] = args.check.split(',')

    # Ejecutar scan
    results = agent.run_full_scan()

    # Generar reporte
    if not args.dry_run:
        report_path = agent.generate_report(args.output)

    # Salida JSON si se solicitó
    if args.json:
        # Use consistent timestamp for both content and filename
        now = datetime.now()
        json_output = {
            'score': results['score'],
            'timestamp': now.isoformat(),
            'issues': results['issues'],
            'metrics': results['metrics']
        }
        json_path = Path(args.output) / f"health-report-{now.strftime('%Y-%m-%d')}.json"
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(json_output, f, indent=2, ensure_ascii=False)
        print(f"📊 Reporte JSON generado: {json_path}")

    # Resumen final
    print("\n" + "=" * 60)
    print(f"🏥 Health Check Completado")
    print(f"📊 Score: {results['score']}/100")
    print(f"🔴 Críticos: {len(results['issues']['critical'])}")
    print(f"🟡 Advertencias: {len(results['issues']['warnings'])}")
    print(f"🟢 Pasados: {len(results['issues']['passed'])}")
    print("=" * 60)

    # Exit code basado en score
    if results['score'] < 50:
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == '__main__':
    main()
