#!/usr/bin/env python3
"""
Script de automatización completa del proyecto
Ejecuta todos los pasos necesarios para verificar y construir el proyecto
"""

import subprocess
import sys
import os
from pathlib import Path
from datetime import datetime
import json

class ProjectAutomation:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.results = {
            "timestamp": datetime.now().isoformat(),
            "steps": [],
            "success": True
        }
        
    def log(self, message, emoji="📋", level="INFO"):
        """Log con emoji y timestamp"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        color_codes = {
            "INFO": "\033[94m",
            "SUCCESS": "\033[92m",
            "WARNING": "\033[93m",
            "ERROR": "\033[91m",
            "RESET": "\033[0m"
        }
        color = color_codes.get(level, color_codes["INFO"])
        print(f"{color}{emoji} [{timestamp}] {message}{color_codes['RESET']}")
        
    def run_command(self, command, step_name, timeout=300, check=True):
        """Ejecuta un comando y registra resultado"""
        self.log(f"Ejecutando: {step_name}", "🔧")
        
        step_result = {
            "name": step_name,
            "command": command if isinstance(command, str) else " ".join(command),
            "start_time": datetime.now().isoformat(),
            "success": False,
            "output": "",
            "error": ""
        }
        
        try:
            result = subprocess.run(
                command if isinstance(command, list) else command.split(),
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=timeout,
                check=check
            )
            
            step_result["success"] = result.returncode == 0
            step_result["output"] = result.stdout
            step_result["error"] = result.stderr
            
            if result.returncode == 0:
                self.log(f"{step_name} completado", "✅", "SUCCESS")
            else:
                self.log(f"{step_name} falló", "❌", "ERROR")
                self.results["success"] = False
                
        except subprocess.TimeoutExpired:
            self.log(f"{step_name} timeout", "⏱️", "ERROR")
            step_result["error"] = "Timeout"
            self.results["success"] = False
        except Exception as e:
            self.log(f"{step_name} error: {str(e)}", "❌", "ERROR")
            step_result["error"] = str(e)
            self.results["success"] = False
            
        step_result["end_time"] = datetime.now().isoformat()
        self.results["steps"].append(step_result)
        
        return step_result["success"]
        
    def check_prerequisites(self):
        """Verifica herramientas necesarias"""
        self.log("Verificando prerequisitos...", "🔍")
        
        tools = {
            "flutter": "Flutter SDK",
            "dart": "Dart SDK",
            "git": "Git"
        }
        
        all_ok = True
        for tool, name in tools.items():
            if subprocess.run(["which", tool], capture_output=True).returncode == 0:
                self.log(f"{name} encontrado", "✅", "SUCCESS")
            else:
                self.log(f"{name} NO encontrado", "❌", "ERROR")
                all_ok = False
                
        return all_ok
        
    def run_full_pipeline(self):
        """Ejecuta el pipeline completo"""
        self.log("INICIANDO PIPELINE COMPLETO", "🚀")
        print("=" * 60)
        
        steps = [
            (self.check_prerequisites, "Prerequisitos", True),
            (lambda: self.run_command("flutter clean", "Limpieza"), False),
            (lambda: self.run_command("flutter pub get", "Dependencias"), True),
            (lambda: self.run_command("flutter analyze", "Análisis estático"), False),
            (lambda: self.run_command("flutter test", "Tests unitarios"), False),
            (lambda: self.run_command("flutter build apk --debug", "Build APK Debug", timeout=600), True),
        ]
        
        for step_func, step_name, critical in steps:
            success = step_func()
            if not success and critical:
                self.log(f"Paso crítico falló: {step_name}", "💥", "ERROR")
                break
            elif not success:
                self.log(f"Paso falló pero continuando: {step_name}", "⚠️", "WARNING")
                
        self.generate_report()
        
    def generate_report(self):
        """Genera reporte final"""
        print("\n" + "=" * 60)
        if self.results["success"]:
            self.log("PIPELINE COMPLETADO EXITOSAMENTE", "🎉", "SUCCESS")
        else:
            self.log("PIPELINE COMPLETADO CON ERRORES", "⚠️", "WARNING")
        print("=" * 60)
        
        # Guardar reporte JSON
        report_file = self.project_root / "automation_report.json"
        with open(report_file, 'w') as f:
            json.dump(self.results, f, indent=2)
        self.log(f"Reporte guardado: {report_file}", "📄")
        
        # Resumen
        total = len(self.results["steps"])
        successful = sum(1 for s in self.results["steps"] if s["success"])
        print(f"\n📊 Resumen: {successful}/{total} pasos exitosos")
        
        # Mostrar APK si existe
        apk_path = self.project_root / "build/app/outputs/flutter-apk/app-debug.apk"
        if apk_path.exists():
            size_mb = apk_path.stat().st_size / (1024 * 1024)
            self.log(f"APK: {apk_path} ({size_mb:.2f} MB)", "📦", "SUCCESS")

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    automation = ProjectAutomation(project_root)
    automation.run_full_pipeline()
    sys.exit(0 if automation.results["success"] else 1)
