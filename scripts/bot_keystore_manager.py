#!/usr/bin/env python3
"""
Bot 5B: KeystoreManager
Genera y gestiona keystores para signing de Android release
"""
import os
import sys
import subprocess
from pathlib import Path

class KeystoreManagerBot:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.android_dir = self.project_root / "android"
        self.app_dir = self.android_dir / "app"
        
    def log(self, message, emoji="🔐"):
        print(f"{emoji} [KeystoreManager] {message}")
        
    def generate_debug_keystore(self):
        """Genera keystore de debug si no existe"""
        debug_keystore = self.app_dir / "debug.keystore"
        
        if debug_keystore.exists():
            self.log(f"✓ Debug keystore ya existe: {debug_keystore}", "✅")
            return True
            
        self.log("Generando debug keystore...")
        
        cmd = [
            "keytool", "-genkey", "-v",
            "-keystore", str(debug_keystore),
            "-storepass", "android",
            "-alias", "androiddebugkey",
            "-keypass", "android",
            "-keyalg", "RSA",
            "-keysize", "2048",
            "-validity", "10000",
            "-dname", "CN=Android Debug,O=Android,C=US"
        ]
        
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            self.log("✓ Debug keystore generado", "✅")
            return True
        except Exception as e:
            self.log(f"✗ Error generando keystore: {e}", "❌")
            return False
            
    def create_key_properties_template(self):
        """Crea template de key.properties para release"""
        key_properties = self.android_dir / "key.properties"
        
        if key_properties.exists():
            self.log("✓ key.properties ya existe", "✅")
            return True
            
        template = """# IMPORTANTE: NO COMMITEAR ESTE ARCHIVO
# Agregar key.properties a .gitignore

# Para generar keystore de release:
# keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

storePassword=YOUR_STORE_PASSWORD_HERE
keyPassword=YOUR_KEY_PASSWORD_HERE
keyAlias=upload
storeFile=upload-keystore.jks
"""
        
        try:
            key_properties.write_text(template)
            self.log("✓ key.properties template creado", "✅")
            self.log("⚠️  EDITAR key.properties con credenciales reales", "⚠️")
            return True
        except Exception as e:
            self.log(f"✗ Error creando template: {e}", "❌")
            return False
            
    def update_gitignore(self):
        """Actualiza .gitignore para excluir keys"""
        gitignore = self.project_root / ".gitignore"
        
        entries_to_add = [
            "# Android signing",
            "**/android/key.properties",
            "**/android/app/upload-keystore.jks",
            "**/android/app/*.jks",
            ""
        ]
        
        try:
            if gitignore.exists():
                content = gitignore.read_text()
                if "key.properties" not in content:
                    with open(gitignore, 'a') as f:
                        f.write("\n" + "\n".join(entries_to_add))
                    self.log("✓ .gitignore actualizado", "✅")
                else:
                    self.log("✓ .gitignore ya contiene entradas de keys", "✅")
            return True
        except Exception as e:
            self.log(f"⚠️  Error actualizando .gitignore: {e}", "⚠️")
            return False
            
    def verify_setup(self):
        """Verifica la configuración de signing"""
        checks = [
            (self.app_dir / "debug.keystore", "Debug keystore"),
            (self.android_dir / "key.properties", "Key properties"),
        ]
        
        all_ok = True
        self.log("Verificando setup de signing...")
        
        for path, name in checks:
            if path.exists():
                self.log(f"✓ {name}: {path}", "✅")
            else:
                self.log(f"✗ {name}: FALTA", "❌")
                all_ok = False
                
        return all_ok
        
    def print_instructions(self):
        """Imprime instrucciones para generar keystore de release"""
        instructions = """
╔══════════════════════════════════════════════════════════╗
║          INSTRUCCIONES: Release Keystore                ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║  1. Generar keystore de release:                        ║
║                                                          ║
║     cd android/app                                       ║
║     keytool -genkey -v -keystore upload-keystore.jks \  ║
║       -keyalg RSA -keysize 2048 \                       ║
║       -validity 10000 -alias upload                     ║
║                                                          ║
║  2. Editar android/key.properties con tus valores       ║
║                                                          ║
║  3. NUNCA commitear el archivo .jks ni key.properties   ║
║                                                          ║
║  4. Guardar backup seguro del keystore                  ║
║                                                          ║
║  5. Build release:                                       ║
║     flutter build apk --release                          ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
"""
        print(instructions)
        
    def run(self):
        """Ejecuta el bot completo"""
        self.log("🚀 INICIANDO BOT 5B: KeystoreManager", "🤖")
        
        steps = [
            ("Generar debug keystore", self.generate_debug_keystore),
            ("Crear key.properties template", self.create_key_properties_template),
            ("Actualizar .gitignore", self.update_gitignore),
            ("Verificar setup", self.verify_setup),
        ]
        
        for step_name, step_func in steps:
            self.log(f"Ejecutando: {step_name}")
            if not step_func():
                self.log(f"⚠️  {step_name} falló, pero continuando...", "⚠️")
                
        self.print_instructions()
        self.log("Bot COMPLETADO", "✅")
        return True

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    bot = KeystoreManagerBot(project_root)
    success = bot.run()
    sys.exit(0 if success else 1)
