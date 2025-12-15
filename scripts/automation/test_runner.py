#!/usr/bin/env python3
"""
Bot de Testing Automatizado para Tokyo Roulette
Ejecuta tests en paralelo y genera reportes
"""
import subprocess
import sys
import json
import time
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from typing import List, Dict, Optional

@dataclass
class TestResult:
    """Resultado de un test"""
    name: str
    passed: bool
    duration: float
    output: str
    error: Optional[str] = None

class FlutterTestBot:
    """Bot automatizado para ejecutar tests de Flutter"""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.test_dir = project_root / "test"
        self.results: List[TestResult] = []
        
    def discover_tests(self) -> List[Path]:
        """Descubre todos los archivos de test"""
        if not self.test_dir.exists():
            print("⚠️  No se encontró directorio test/")
            return []
        
        test_files = list(self.test_dir.rglob("*_test.dart"))
        print(f"✅ {len(test_files)} archivos de test encontrados")
        return test_files
    
    def run_single_test(self, test_file: Path) -> TestResult:
        """Ejecuta un solo archivo de test"""
        start_time = time.time()
        test_name = test_file.relative_to(self.test_dir)
        
        try:
            print(f"🧪 Ejecutando: {test_name}")
            result = subprocess.run(
                ["flutter", "test", str(test_file)],
                capture_output=True,
                text=True,
                timeout=120,
                cwd=self.project_root
            )
            
            duration = time.time() - start_time
            passed = result.returncode == 0
            
            return TestResult(
                name=str(test_name),
                passed=passed,
                duration=duration,
                output=result.stdout,
                error=result.stderr if not passed else None
            )
            
        except subprocess.TimeoutExpired:
            return TestResult(
                name=str(test_name),
                passed=False,
                duration=120.0,
                output="",
                error="Test timeout (>120s)"
            )
        except Exception as e:
            return TestResult(
                name=str(test_name),
                passed=False,
                duration=time.time() - start_time,
                output="",
                error=str(e)
            )
    
    def run_parallel(self, max_workers: int = 4) -> Dict:
        """Ejecuta todos los tests en paralelo"""
        test_files = self.discover_tests()
        
        if not test_files:
            return {"total": 0, "passed": 0, "failed": 0, "duration": 0}
        
        print(f"\n🚀 Ejecutando {len(test_files)} tests en {max_workers} workers paralelos\n")
        
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            futures = {
                executor.submit(self.run_single_test, test_file): test_file 
                for test_file in test_files
            }
            
            for future in as_completed(futures):
                result = future.result()
                self.results.append(result)
                
                status = "✅" if result.passed else "❌"
                print(f"{status} {result.name} ({result.duration:.2f}s)")
        
        return self.generate_summary()
    
    def generate_summary(self) -> Dict:
        """Genera resumen de resultados"""
        total = len(self.results)
        passed = sum(1 for r in self.results if r.passed)
        failed = total - passed
        total_duration = sum(r.duration for r in self.results)
        
        summary = {
            "total": total,
            "passed": passed,
            "failed": failed,
            "duration": total_duration,
            "success_rate": (passed / total * 100) if total > 0 else 0
        }
        
        return summary
    
    def save_report(self, output_file: Path):
        """Guarda reporte en JSON"""
        report = {
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
            "summary": self.generate_summary(),
            "results": [
                {
                    "name": r.name,
                    "passed": r.passed,
                    "duration": r.duration,
                    "error": r.error
                }
                for r in self.results
            ]
        }
        
        with open(output_file, "w") as f:
            json.dump(report, f, indent=2)
        
        print(f"\n📄 Reporte guardado: {output_file}")
    
    def print_summary(self):
        """Imprime resumen en consola"""
        summary = self.generate_summary()
        
        print("\n" + "="*60)
        print("📊 RESUMEN DE TESTS")
        print("="*60)
        print(f"Total:        {summary['total']}")
        print(f"✅ Pasados:   {summary['passed']}")
        print(f"❌ Fallados:  {summary['failed']}")
        print(f"⏱️  Duración:  {summary['duration']:.2f}s")
        print(f"📈 Éxito:     {summary['success_rate']:.1f}%")
        print("="*60 + "\n")
        
        if summary['failed'] > 0:
            print("❌ Tests fallidos:\n")
            for result in self.results:
                if not result.passed:
                    print(f"  • {result.name}")
                    if result.error:
                        print(f"    Error: {result.error}\n")

def main():
    """Función principal"""
    print("🤖 BOT DE TESTING AUTOMATIZADO - Tokyo Roulette\n")
    
    # Detectar directorio del proyecto
    project_root = Path(__file__).parent.parent.parent
    
    # Verificar que Flutter esté instalado
    try:
        result = subprocess.run(
            ["flutter", "--version"],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode != 0:
            print("❌ Flutter no está instalado o no está en PATH")
            sys.exit(1)
    except FileNotFoundError:
        print("❌ Flutter no encontrado. Instala Flutter: https://flutter.dev/docs/get-started/install")
        sys.exit(1)
    
    # Crear bot y ejecutar tests
    bot = FlutterTestBot(project_root)
    
    # Ejecutar tests en paralelo
    bot.run_parallel(max_workers=4)
    
    # Mostrar resumen
    bot.print_summary()
    
    # Guardar reporte
    report_path = project_root / "test_report.json"
    bot.save_report(report_path)
    
    # Exit code basado en resultados
    summary = bot.generate_summary()
    sys.exit(0 if summary['failed'] == 0 else 1)

if __name__ == "__main__":
    main()
