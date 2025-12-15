#!/usr/bin/env python3
"""
Bot 2A: TestRunner
Ejecuta tests automáticamente y genera reportes
"""
import os
import sys
import subprocess
from pathlib import Path
from datetime import datetime

class TestRunnerBot:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.test_dir = self.project_root / "test"
        self.status = "⏳ INICIANDO"
        
    def log(self, message, emoji="🧪"):
        print(f"{emoji} [TestRunner] {message}")
        
    def run_flutter_tests(self):
        """Ejecuta todos los tests de Flutter"""
        self.log("Ejecutando tests de Flutter...")
        try:
            result = subprocess.run(
                ["flutter", "test", "--reporter", "expanded"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=120
            )
            
            print(result.stdout)
            
            if result.returncode == 0:
                self.log("✓ Todos los tests pasaron", "✅")
                return True
            else:
                self.log("✗ Algunos tests fallaron", "❌")
                print(result.stderr)
                return False
        except subprocess.TimeoutExpired:
            self.log("✗ Timeout en tests", "❌")
            return False
        except Exception as e:
            self.log(f"✗ Excepción: {str(e)}", "❌")
            return False
            
    def run_analysis(self):
        """Ejecuta análisis estático"""
        self.log("Ejecutando análisis estático...")
        try:
            result = subprocess.run(
                ["flutter", "analyze"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=60
            )
            
            if result.returncode == 0:
                self.log("✓ Análisis sin issues", "✅")
                return True
            else:
                self.log(f"⚠ Issues encontrados:\n{result.stdout}", "⚠️")
                return True  # No falla el bot, solo advierte
        except Exception as e:
            self.log(f"✗ Excepción: {str(e)}", "❌")
            return False
            
    def check_test_files(self):
        """Verifica que existan archivos de test"""
        test_files = list(self.test_dir.glob("*_test.dart"))
        if test_files:
            self.log(f"✓ Encontrados {len(test_files)} archivos de test", "✅")
            for test_file in test_files:
                self.log(f"  - {test_file.name}", "📄")
            return True
        else:
            self.log("✗ No se encontraron archivos de test", "❌")
            return False
            
    def run(self):
        """Ejecuta el bot completo"""
        self.log("🚀 INICIANDO BOT 2A: TestRunner", "🤖")
        self.status = "🔄 EN PROGRESO"
        
        steps = [
            ("Verificar archivos de test", self.check_test_files),
            ("Ejecutar análisis estático", self.run_analysis),
            ("Ejecutar tests", self.run_flutter_tests),
        ]
        
        for step_name, step_func in steps:
            self.log(f"Ejecutando: {step_name}")
            if not step_func():
                self.status = "❌ FALLIDO"
                self.log(f"Bot FALLIDO en: {step_name}", "❌")
                return False
                
        self.status = "✅ COMPLETADO"
        self.log("Bot COMPLETADO exitosamente", "✅")
        return True

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    bot = TestRunnerBot(project_root)
    success = bot.run()
    sys.exit(0 if success else 1)
