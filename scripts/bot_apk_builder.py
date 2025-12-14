#!/usr/bin/env python3
"""
Bot 2B: APKBuilder
Construye la APK de release y verifica el resultado
"""
import os
import sys
import subprocess
from pathlib import Path
from datetime import datetime

class APKBuilderBot:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.build_dir = self.project_root / "build" / "app" / "outputs" / "flutter-apk"
        self.status = "⏳ INICIANDO"
        
    def log(self, message, emoji="🏗️"):
        print(f"{emoji} [APKBuilder] {message}")
        
    def clean_build(self):
        """Limpia builds anteriores"""
        self.log("Limpiando builds anteriores...")
        try:
            result = subprocess.run(
                ["flutter", "clean"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=30
            )
            if result.returncode == 0:
                self.log("✓ Build limpio", "✅")
                return True
            return False
        except Exception as e:
            self.log(f"✗ Error limpiando: {str(e)}", "❌")
            return False
            
    def build_apk_debug(self):
        """Construye APK debug"""
        self.log("Construyendo APK debug...")
        try:
            result = subprocess.run(
                ["flutter", "build", "apk", "--debug"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=300
            )
            
            print(result.stdout)
            
            if result.returncode == 0:
                self.log("✓ APK debug construida exitosamente", "✅")
                return True
            else:
                self.log(f"✗ Error construyendo APK: {result.stderr}", "❌")
                return False
        except subprocess.TimeoutExpired:
            self.log("✗ Timeout construyendo APK", "❌")
            return False
        except Exception as e:
            self.log(f"✗ Excepción: {str(e)}", "❌")
            return False
            
    def build_apk_release(self):
        """Construye APK release"""
        self.log("Construyendo APK release...")
        try:
            result = subprocess.run(
                ["flutter", "build", "apk", "--release"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=300
            )
            
            print(result.stdout)
            
            if result.returncode == 0:
                self.log("✓ APK release construida exitosamente", "✅")
                return True
            else:
                self.log(f"✗ Error construyendo APK: {result.stderr}", "❌")
                return False
        except subprocess.TimeoutExpired:
            self.log("✗ Timeout construyendo APK", "❌")
            return False
        except Exception as e:
            self.log(f"✗ Excepción: {str(e)}", "❌")
            return False
            
    def verify_apk(self):
        """Verifica que la APK exista"""
        apk_file = self.build_dir / "app-release.apk"
        if apk_file.exists():
            size_mb = apk_file.stat().st_size / (1024 * 1024)
            self.log(f"✓ APK encontrada: {apk_file.name} ({size_mb:.2f} MB)", "✅")
            self.log(f"  Ubicación: {apk_file}", "📍")
            return True
        else:
            self.log("✗ APK no encontrada", "❌")
            return False
            
    def run(self):
        """Ejecuta el bot completo"""
        self.log("🚀 INICIANDO BOT 2B: APKBuilder", "🤖")
        self.status = "🔄 EN PROGRESO"
        
        steps = [
            ("Limpiar builds", self.clean_build),
            ("Construir APK release", self.build_apk_release),
            ("Verificar APK", self.verify_apk),
        ]
        
        for step_name, step_func in steps:
            self.log(f"Ejecutando: {step_name}")
            if not step_func():
                self.status = "❌ FALLIDO"
                self.log(f"Bot FALLIDO en: {step_name}", "❌")
                return False
                
        self.status = "✅ COMPLETADO"
        self.log("Bot COMPLETADO exitosamente", "✅")
        self.log("="*60, "🎉")
        self.log("APK LISTA PARA DISTRIBUCIÓN", "🎉")
        self.log("="*60, "🎉")
        return True

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    bot = APKBuilderBot(project_root)
    success = bot.run()
    sys.exit(0 if success else 1)
