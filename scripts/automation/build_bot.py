#!/usr/bin/env python3
"""
Tokyo Roulette - Automated Build Bot
Pipeline automatizado para build de APK con verificación.
"""

import os
import sys
import subprocess
import time
from pathlib import Path
import argparse


class Colors:
    """Códigos ANSI para output colorido"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'


class BuildBot:
    """Bot automatizado para builds de Flutter"""
    
    def __init__(self, project_root: str, release: bool = False, verbose: bool = False):
        # Security: Validate and resolve project root path
        self.project_root = Path(project_root).resolve()
        
        # Security: Validate it's a Flutter project
        pubspec_file = self.project_root / 'pubspec.yaml'
        if not pubspec_file.exists():
            raise ValueError(f"Not a valid Flutter project (pubspec.yaml not found): {self.project_root}")
        
        # Security: Prevent path traversal outside allowed directory tree
        try:
            # Ensure project_root is within or at the current working directory tree
            current_dir = Path.cwd().resolve()
            # Allow current dir or subdirectories
            if not (self.project_root == current_dir or current_dir in self.project_root.parents or self.project_root in current_dir.parents):
                raise ValueError(f"Project root must be within current directory tree")
        except ValueError as e:
            raise ValueError(f"Invalid project root path: {e}")
        
        self.release = release
        self.verbose = verbose
        self.build_mode = 'release' if release else 'debug'
        self.apk_path = None
        
    def print_step(self, step: str, message: str):
        """Imprime paso del pipeline"""
        print(f"\n{Colors.BOLD}[{step}]{Colors.END} {message}")
    
    def run_command(self, cmd: list, step_name: str) -> bool:
        """Ejecuta comando y retorna éxito/fallo"""
        self.print_step(step_name, f"Running: {' '.join(cmd)}")
        
        try:
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=not self.verbose,
                text=True,
                check=False
            )
            
            if result.returncode == 0:
                print(f"{Colors.GREEN}✅ Success{Colors.END}")
                return True
            else:
                print(f"{Colors.RED}❌ Failed with exit code {result.returncode}{Colors.END}")
                if not self.verbose and result.stderr:
                    print(f"Error: {result.stderr[:500]}")
                return False
                
        except Exception as e:
            print(f"{Colors.RED}💥 Error: {str(e)}{Colors.END}")
            return False
    
    def step_clean(self) -> bool:
        """Paso 1: Limpia build anterior"""
        return self.run_command(['flutter', 'clean'], 'CLEAN')
    
    def step_pub_get(self) -> bool:
        """Paso 2: Descarga dependencias"""
        return self.run_command(['flutter', 'pub', 'get'], 'DEPENDENCIES')
    
    def step_build_apk(self) -> bool:
        """Paso 3: Construye APK"""
        if self.release:
            cmd = ['flutter', 'build', 'apk', '--release']
        else:
            cmd = ['flutter', 'build', 'apk', '--debug']
        
        return self.run_command(cmd, 'BUILD APK')
    
    def step_verify_apk(self) -> bool:
        """Paso 4: Verifica que APK existe y obtiene métricas"""
        self.print_step('VERIFY', 'Checking APK file...')
        
        # Ruta esperada del APK
        apk_filename = 'app-release.apk' if self.release else 'app-debug.apk'
        apk_path = self.project_root / 'build' / 'app' / 'outputs' / 'flutter-apk' / apk_filename
        
        if not apk_path.exists():
            print(f"{Colors.RED}❌ APK not found at: {apk_path}{Colors.END}")
            return False
        
        # Obtener tamaño
        apk_size_bytes = apk_path.stat().st_size
        apk_size_mb = apk_size_bytes / (1024 * 1024)
        
        self.apk_path = apk_path
        
        print(f"{Colors.GREEN}✅ APK verified{Colors.END}")
        print(f"   Location: {apk_path}")
        print(f"   Size:     {apk_size_mb:.2f} MB ({apk_size_bytes:,} bytes)")
        
        return True
    
    def run_pipeline(self, skip_clean: bool = False, clean_only: bool = False) -> int:
        """Ejecuta pipeline completo de build"""
        print(f"{Colors.BOLD}{'='*60}{Colors.END}")
        print(f"{Colors.BOLD}Tokyo Roulette - Automated Build Bot{Colors.END}")
        print(f"{Colors.BOLD}{'='*60}{Colors.END}")
        print(f"Project:    {self.project_root}")
        print(f"Build Mode: {self.build_mode.upper()}")
        print(f"Skip Clean: {skip_clean}")
        print(f"{'='*60}\n")
        
        start_time = time.time()
        
        # Paso 1: Clean (opcional)
        if not skip_clean:
            if not self.step_clean():
                print(f"\n{Colors.RED}❌ Build failed at CLEAN step{Colors.END}")
                return 1
            
            if clean_only:
                print(f"\n{Colors.GREEN}✅ Clean completed (clean-only mode){Colors.END}")
                return 0
        
        # Paso 2: Pub Get
        if not self.step_pub_get():
            print(f"\n{Colors.RED}❌ Build failed at DEPENDENCIES step{Colors.END}")
            return 1
        
        # Paso 3: Build APK
        if not self.step_build_apk():
            print(f"\n{Colors.RED}❌ Build failed at BUILD APK step{Colors.END}")
            return 1
        
        # Paso 4: Verify APK
        if not self.step_verify_apk():
            print(f"\n{Colors.RED}❌ Build failed at VERIFY step{Colors.END}")
            return 2  # Exit code 2 = verification failed
        
        # Resumen final
        total_time = time.time() - start_time
        
        print(f"\n{Colors.BOLD}{'='*60}{Colors.END}")
        print(f"{Colors.GREEN}{Colors.BOLD}🎉 BUILD SUCCESSFUL!{Colors.END}")
        print(f"{Colors.BOLD}{'='*60}{Colors.END}")
        print(f"Build Mode:    {self.build_mode.upper()}")
        print(f"Total Time:    {total_time:.2f}s ({total_time/60:.1f} minutes)")
        print(f"APK Location:  {self.apk_path}")
        print(f"{'='*60}\n")
        
        # Siguiente paso sugerido
        if self.release:
            print(f"{Colors.BLUE}💡 Next steps:{Colors.END}")
            print(f"   • Test the APK on a device")
            print(f"   • Upload to Google Play Console")
            print(f"   • Share with testers\n")
        else:
            print(f"{Colors.BLUE}💡 Next steps:{Colors.END}")
            print(f"   • Install on device: adb install {self.apk_path}")
            print(f"   • Test the application\n")
        
        return 0  # Exit code 0 = success


def main():
    parser = argparse.ArgumentParser(
        description='Automated build bot for Flutter APK',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Build debug APK with clean
  %(prog)s --release          # Build release APK
  %(prog)s --no-clean         # Build without cleaning first (faster)
  %(prog)s --clean-only       # Only run flutter clean
  %(prog)s --verbose          # Show full build output

Exit codes:
  0 - Build successful
  1 - Build failed
  2 - Verification failed (APK not found)
  3 - Fatal error
        """
    )
    
    parser.add_argument('--release', action='store_true',
                       help='Build release APK (default: debug)')
    parser.add_argument('--no-clean', action='store_true',
                       help='Skip flutter clean step (faster incremental builds)')
    parser.add_argument('--clean-only', action='store_true',
                       help='Only run flutter clean and exit')
    parser.add_argument('--project-root', type=str, default='.',
                       help='Project root directory (default: current dir)')
    parser.add_argument('--verbose', action='store_true',
                       help='Show verbose build output')
    
    args = parser.parse_args()
    
    try:
        bot = BuildBot(
            project_root=args.project_root,
            release=args.release,
            verbose=args.verbose
        )
        
        exit_code = bot.run_pipeline(
            skip_clean=args.no_clean,
            clean_only=args.clean_only
        )
        
        sys.exit(exit_code)
        
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}⚠️  Build interrupted by user{Colors.END}")
        sys.exit(3)
    
    except Exception as e:
        print(f"\n{Colors.RED}💥 Fatal error: {str(e)}{Colors.END}")
        import traceback
        traceback.print_exc()
        sys.exit(3)


if __name__ == '__main__':
    main()
