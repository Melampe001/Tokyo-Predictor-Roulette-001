#!/usr/bin/env python3
"""
Bot 1A: GradleBuilder
Configura y verifica archivos Gradle para el build de Android
"""
import os
import sys
import subprocess
from pathlib import Path

class GradleBuilderBot:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.android_dir = self.project_root / "android"
        self.status = "⏳ INICIANDO"
        
    def log(self, message, emoji="🔧"):
        print(f"{emoji} [GradleBuilder] {message}")
        
    def check_file_exists(self, file_path, description):
        """Verifica si un archivo existe"""
        if file_path.exists():
            self.log(f"✓ {description}: {file_path.name}", "✅")
            return True
        else:
            self.log(f"✗ {description}: FALTA {file_path.name}", "❌")
            return False
            
    def verify_gradle_files(self):
        """Verifica archivos Gradle"""
        self.log("Verificando archivos Gradle...")
        
        files_to_check = [
            (self.android_dir / "build.gradle", "Build raíz"),
            (self.android_dir / "settings.gradle", "Settings"),
            (self.android_dir / "gradle.properties", "Properties"),
            (self.android_dir / "gradle" / "wrapper" / "gradle-wrapper.properties", "Wrapper"),
        ]
        
        all_exist = all(self.check_file_exists(f, desc) for f, desc in files_to_check)
        return all_exist
        
    def verify_gradle_wrapper(self):
        """Verifica versión de Gradle wrapper"""
        wrapper_file = self.android_dir / "gradle" / "wrapper" / "gradle-wrapper.properties"
        if wrapper_file.exists():
            content = wrapper_file.read_text()
            if "gradle-8.3" in content:
                self.log("✓ Gradle 8.3 configurado", "✅")
                return True
            else:
                self.log("✗ Versión de Gradle incorrecta", "❌")
                return False
        return False
        
    def test_gradle_build(self):
        """Intenta hacer un build de verificación"""
        self.log("Probando configuración Gradle...")
        try:
            result = subprocess.run(
                ["flutter", "pub", "get"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=60
            )
            if result.returncode == 0:
                self.log("✓ Flutter pub get exitoso", "✅")
                return True
            else:
                self.log(f"✗ Error en pub get: {result.stderr}", "❌")
                return False
        except Exception as e:
            self.log(f"✗ Excepción: {str(e)}", "❌")
            return False
            
    def run(self):
        """Ejecuta el bot completo"""
        self.log("🚀 INICIANDO BOT 1A: GradleBuilder", "🤖")
        self.status = "🔄 EN PROGRESO"
        
        steps = [
            ("Verificar archivos Gradle", self.verify_gradle_files),
            ("Verificar Gradle wrapper", self.verify_gradle_wrapper),
            ("Test de dependencias", self.test_gradle_build),
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
    bot = GradleBuilderBot(project_root)
    success = bot.run()
    sys.exit(0 if success else 1)
