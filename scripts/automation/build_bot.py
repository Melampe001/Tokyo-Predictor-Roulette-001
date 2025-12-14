#!/usr/bin/env python3
"""
Bot de Build Automatizado
Ejecuta builds de Flutter y verifica integridad
"""
import subprocess
import sys
from pathlib import Path
from datetime import datetime

class FlutterBuildBot:
    """Bot para automatizar builds de Flutter"""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.build_dir = project_root / "build"
        
    def clean(self):
        """Limpia build anterior"""
        print("🧹 Limpiando build anterior...")
        subprocess.run(["flutter", "clean"], cwd=self.project_root)
        
    def pub_get(self):
        """Obtiene dependencias"""
        print("📦 Obteniendo dependencias...")
        result = subprocess.run(
            ["flutter", "pub", "get"],
            cwd=self.project_root,
            capture_output=True
        )
        if result.returncode != 0:
            print("❌ Error obteniendo dependencias")
            sys.exit(1)
        print("✅ Dependencias obtenidas")
        
    def build_apk(self, mode: str = "release"):
        """Build APK"""
        print(f"\n🏗️  Building APK ({mode})...")
        
        cmd = ["flutter", "build", "apk", f"--{mode}"]
        
        start_time = datetime.now()
        result = subprocess.run(cmd, cwd=self.project_root)
        duration = (datetime.now() - start_time).total_seconds()
        
        if result.returncode == 0:
            print(f"✅ APK generada en {duration:.1f}s")
            self.verify_apk()
            return True
        else:
            print(f"❌ Build falló después de {duration:.1f}s")
            return False
    
    def verify_apk(self):
        """Verifica que APK existe y muestra info"""
        apk_path = self.build_dir / "app" / "outputs" / "flutter-apk" / "app-release.apk"
        
        if apk_path.exists():
            size_mb = apk_path.stat().st_size / (1024 * 1024)
            print(f"📱 APK: {apk_path}")
            print(f"📊 Tamaño: {size_mb:.2f} MB")
        else:
            print("⚠️  APK no encontrada en ubicación esperada")
    
    def run_full_pipeline(self):
        """Ejecuta pipeline completo"""
        print("🤖 INICIANDO PIPELINE DE BUILD\n")
        
        self.clean()
        self.pub_get()
        
        if self.build_apk():
            print("\n✅ PIPELINE COMPLETADO")
            return True
        else:
            print("\n❌ PIPELINE FALLÓ")
            return False

def main():
    project_root = Path(__file__).parent.parent.parent
    bot = FlutterBuildBot(project_root)
    
    success = bot.run_full_pipeline()
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
