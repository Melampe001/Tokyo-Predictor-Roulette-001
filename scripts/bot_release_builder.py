#!/usr/bin/env python3
"""
Bot 5A: ReleaseBuilder
Construye APK/AAB de release con signing
"""
import os
import sys
import subprocess
from pathlib import Path

class ReleaseBuilderBot:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.build_dir = self.project_root / "build" / "app" / "outputs"
        
    def log(self, message, emoji="🏗️"):
        print(f"{emoji} [ReleaseBuilder] {message}")
        
    def verify_signing_config(self):
        """Verifica que esté configurado el signing"""
        key_properties = self.project_root / "android" / "key.properties"
        
        if not key_properties.exists():
            self.log("✗ key.properties no encontrado", "❌")
            self.log("⚠️  Ejecuta primero: python3 scripts/bot_keystore_manager.py", "⚠️")
            return False
            
        content = key_properties.read_text()
        if "YOUR_STORE_PASSWORD_HERE" in content:
            self.log("✗ key.properties no está configurado", "❌")
            self.log("⚠️  Edita android/key.properties con tus credenciales", "⚠️")
            return False
            
        self.log("✓ Configuración de signing OK", "✅")
        return True
        
    def build_apk_release(self):
        """Build APK de release"""
        self.log("Construyendo APK release...")
        
        try:
            result = subprocess.run(
                ["flutter", "build", "apk", "--release"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=600
            )
            
            if result.returncode == 0:
                apk_path = self.build_dir / "flutter-apk" / "app-release.apk"
                if apk_path.exists():
                    size_mb = apk_path.stat().st_size / (1024 * 1024)
                    self.log(f"✓ APK release: {apk_path}", "✅")
                    self.log(f"  Tamaño: {size_mb:.2f} MB", "📦")
                    return True
            
            self.log(f"✗ Error en build: {result.stderr}", "❌")
            return False
            
        except Exception as e:
            self.log(f"✗ Excepción: {e}", "❌")
            return False
            
    def build_appbundle_release(self):
        """Build AAB (Android App Bundle) de release"""
        self.log("Construyendo AAB release...")
        
        try:
            result = subprocess.run(
                ["flutter", "build", "appbundle", "--release"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=600
            )
            
            if result.returncode == 0:
                aab_path = self.build_dir / "bundle" / "release" / "app-release.aab"
                if aab_path.exists():
                    size_mb = aab_path.stat().st_size / (1024 * 1024)
                    self.log(f"✓ AAB release: {aab_path}", "✅")
                    self.log(f"  Tamaño: {size_mb:.2f} MB", "📦")
                    return True
            
            self.log(f"⚠️  Error en AAB: {result.stderr}", "⚠️")
            return False
            
        except Exception as e:
            self.log(f"⚠️  AAB no generado: {e}", "⚠️")
            return False
            
    def run(self):
        """Ejecuta el bot completo"""
        self.log("🚀 INICIANDO BOT 5A: ReleaseBuilder", "🤖")
        
        if not self.verify_signing_config():
            return False
            
        success = True
        success = self.build_apk_release() and success
        # AAB es opcional
        self.build_appbundle_release()
        
        if success:
            self.log("Bot COMPLETADO ✓", "✅")
            self.log("APK lista para distribución", "🎉")
        else:
            self.log("Bot FALLIDO ✗", "❌")
            
        return success

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    bot = ReleaseBuilderBot(project_root)
    success = bot.run()
    sys.exit(0 if success else 1)
