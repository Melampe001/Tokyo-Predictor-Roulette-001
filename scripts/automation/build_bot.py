#!/usr/bin/env python3
"""
Build Bot - Tokyo Roulette
Version: 1.0.0

Automatización completa del proceso de build APK.
Incluye limpieza, verificación y métricas.
"""

import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from typing import Tuple

class BuildBot:
    """Bot automatizado para builds de Flutter."""
    
    def __init__(self, root_path: str):
        self.root_path = Path(root_path)
        self.build_start = None
        self.build_end = None
        self.apk_path = None
    
    def run_command(self, command: list, description: str) -> Tuple[bool, str]:
        """Ejecuta un comando y retorna éxito y output."""
        print(f"\n🔧 {description}")
        print(f"   Comando: {' '.join(command)}")
        
        try:
            result = subprocess.run(
                command,
                cwd=self.root_path,
                capture_output=True,
                text=True,
                timeout=600  # 10 minutos timeout
            )
            
            if result.returncode == 0:
                print(f"   ✅ Éxito")
                return True, result.stdout
            else:
                print(f"   ❌ Falló con código {result.returncode}")
                print(f"   Error: {result.stderr[:200]}")
                return False, result.stderr
        
        except subprocess.TimeoutExpired:
            print(f"   ⏱️  Timeout después de 10 minutos")
            return False, "Timeout"
        except Exception as e:
            print(f"   💥 Excepción: {str(e)}")
            return False, str(e)
    
    def clean_build(self) -> bool:
        """Limpia archivos de build anteriores."""
        success, _ = self.run_command(
            ['flutter', 'clean'],
            'Limpiando archivos de build anteriores'
        )
        return success
    
    def get_dependencies(self) -> bool:
        """Obtiene dependencias de Flutter."""
        success, _ = self.run_command(
            ['flutter', 'pub', 'get'],
            'Obteniendo dependencias'
        )
        return success
    
    def build_apk(self, release: bool = True) -> bool:
        """Construye APK en modo release o debug."""
        mode = 'release' if release else 'debug'
        success, _ = self.run_command(
            ['flutter', 'build', 'apk', f'--{mode}'],
            f'Construyendo APK en modo {mode}'
        )
        
        if success:
            # Verificar que el APK existe
            apk_filename = f'app-{mode}.apk'
            self.apk_path = self.root_path / 'build' / 'app' / 'outputs' / 'flutter-apk' / apk_filename
            
            if self.apk_path.exists():
                print(f"   📦 APK generada: {self.apk_path}")
                return True
            else:
                print(f"   ❌ APK no encontrada en {self.apk_path}")
                return False
        
        return False
    
    def get_apk_metrics(self) -> dict:
        """Obtiene métricas del APK generado."""
        if not self.apk_path or not self.apk_path.exists():
            return {}
        
        size_bytes = self.apk_path.stat().st_size
        size_mb = size_bytes / (1024 * 1024)
        
        return {
            'path': str(self.apk_path),
            'size_bytes': size_bytes,
            'size_mb': round(size_mb, 2),
            'timestamp': datetime.now().isoformat()
        }
    
    def run_full_pipeline(self, release: bool = True) -> bool:
        """Ejecuta el pipeline completo de build."""
        print("\n" + "=" * 60)
        print("🏗️  INICIANDO BUILD PIPELINE")
        print("=" * 60)
        
        self.build_start = time.time()
        
        # Paso 1: Limpiar
        if not self.clean_build():
            print("\n❌ Falló la limpieza")
            return False
        
        # Paso 2: Obtener dependencias
        if not self.get_dependencies():
            print("\n❌ Falló la obtención de dependencias")
            return False
        
        # Paso 3: Build APK
        if not self.build_apk(release=release):
            print("\n❌ Falló el build de APK")
            return False
        
        self.build_end = time.time()
        
        # Métricas
        metrics = self.get_apk_metrics()
        build_duration = self.build_end - self.build_start
        
        print("\n" + "=" * 60)
        print("📊 MÉTRICAS DE BUILD")
        print("=" * 60)
        print(f"⏱️  Duración:  {build_duration:.2f}s ({build_duration/60:.1f} minutos)")
        print(f"📦 APK:       {metrics.get('path', 'N/A')}")
        print(f"💾 Tamaño:    {metrics.get('size_mb', 0)} MB")
        print(f"📅 Timestamp: {metrics.get('timestamp', 'N/A')}")
        print("=" * 60)
        print("✅ BUILD COMPLETADO EXITOSAMENTE")
        print("=" * 60)
        
        return True


def main():
    """Punto de entrada principal."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Build Bot para Flutter APK')
    parser.add_argument('--debug', action='store_true', help='Build en modo debug')
    parser.add_argument('--root', type=str, default='.', help='Directorio raíz del proyecto')
    args = parser.parse_args()
    
    bot = BuildBot(args.root)
    success = bot.run_full_pipeline(release=not args.debug)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
