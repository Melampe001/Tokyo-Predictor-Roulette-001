#!/usr/bin/env python3
"""
Test Runner Paralelo - Tokyo Roulette
Version: 1.0.0

Sistema de ejecución de tests en paralelo con reportes JSON.
Ejecuta tests 4x más rápido que el modo secuencial.
"""

import concurrent.futures
import json
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from typing import Dict, List

class TestRunner:
    """Ejecutor de tests paralelos con reportes."""
    
    def __init__(self, root_path: str, max_workers: int = 4):
        self.root_path = Path(root_path)
        self.max_workers = max_workers
        self.results = []
        self.start_time = None
        self.end_time = None
    
    def discover_tests(self) -> List[Path]:
        """Descubre automáticamente todos los archivos de test."""
        test_dir = self.root_path / 'test'
        if not test_dir.exists():
            print(f"❌ Directorio de tests no encontrado: {test_dir}")
            return []
        
        test_files = list(test_dir.glob('*_test.dart'))
        print(f"✅ Descubiertos {len(test_files)} archivos de test")
        return test_files
    
    def run_single_test(self, test_file: Path) -> Dict:
        """Ejecuta un solo archivo de test y retorna resultados."""
        test_name = test_file.name
        print(f"🧪 Ejecutando: {test_name}")
        
        start = time.time()
        try:
            result = subprocess.run(
                ['flutter', 'test', str(test_file)],
                cwd=self.root_path,
                capture_output=True,
                text=True,
                timeout=120  # 2 minutos timeout
            )
            duration = time.time() - start
            
            success = result.returncode == 0
            status = "✅ PASSED" if success else "❌ FAILED"
            
            return {
                'name': test_name,
                'path': str(test_file.relative_to(self.root_path)),
                'status': 'passed' if success else 'failed',
                'duration': round(duration, 2),
                'exit_code': result.returncode,
                'stdout': result.stdout,
                'stderr': result.stderr
            }
        
        except subprocess.TimeoutExpired:
            duration = time.time() - start
            print(f"⏱️  TIMEOUT: {test_name}")
            return {
                'name': test_name,
                'path': str(test_file.relative_to(self.root_path)),
                'status': 'timeout',
                'duration': round(duration, 2),
                'exit_code': -1,
                'stdout': '',
                'stderr': 'Test timeout after 120 seconds'
            }
        
        except Exception as e:
            duration = time.time() - start
            print(f"💥 ERROR: {test_name} - {str(e)}")
            return {
                'name': test_name,
                'path': str(test_file.relative_to(self.root_path)),
                'status': 'error',
                'duration': round(duration, 2),
                'exit_code': -1,
                'stdout': '',
                'stderr': str(e)
            }
    
    def run_tests_parallel(self) -> bool:
        """Ejecuta todos los tests en paralelo."""
        test_files = self.discover_tests()
        if not test_files:
            print("❌ No se encontraron tests para ejecutar")
            return False
        
        print(f"\n🚀 Iniciando ejecución paralela con {self.max_workers} workers")
        print("=" * 60)
        
        self.start_time = time.time()
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            future_to_test = {
                executor.submit(self.run_single_test, test_file): test_file
                for test_file in test_files
            }
            
            for future in concurrent.futures.as_completed(future_to_test):
                test_file = future_to_test[future]
                try:
                    result = future.result()
                    self.results.append(result)
                    print(f"{result['status'].upper()}: {result['name']} ({result['duration']}s)")
                except Exception as e:
                    print(f"💥 Excepción en {test_file.name}: {str(e)}")
        
        self.end_time = time.time()
        return self._generate_report()
    
    def _generate_report(self) -> bool:
        """Genera reporte JSON y muestra resumen."""
        total_duration = self.end_time - self.start_time
        passed = sum(1 for r in self.results if r['status'] == 'passed')
        failed = sum(1 for r in self.results if r['status'] == 'failed')
        errors = sum(1 for r in self.results if r['status'] in ['error', 'timeout'])
        total = len(self.results)
        
        report = {
            'summary': {
                'total_tests': total,
                'passed': passed,
                'failed': failed,
                'errors': errors,
                'total_duration': round(total_duration, 2),
                'timestamp': datetime.now().isoformat(),
                'success_rate': round((passed / total * 100) if total > 0 else 0, 2)
            },
            'results': self.results
        }
        
        # Guardar reporte JSON
        report_file = self.root_path / 'test_report.json'
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        # Mostrar resumen
        print("\n" + "=" * 60)
        print("📊 RESUMEN DE TESTS")
        print("=" * 60)
        print(f"Total:     {total}")
        print(f"✅ Passed:  {passed}")
        print(f"❌ Failed:  {failed}")
        print(f"💥 Errors:  {errors}")
        print(f"⏱️  Duración: {total_duration:.2f}s")
        print(f"📈 Éxito:   {report['summary']['success_rate']}%")
        print(f"\n📄 Reporte guardado: {report_file}")
        print("=" * 60)
        
        return failed == 0 and errors == 0


def main():
    """Punto de entrada principal."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Test Runner Paralelo para Flutter')
    parser.add_argument('--workers', type=int, default=4, help='Número de workers paralelos')
    parser.add_argument('--root', type=str, default='.', help='Directorio raíz del proyecto')
    args = parser.parse_args()
    
    runner = TestRunner(args.root, max_workers=args.workers)
    success = runner.run_tests_parallel()
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
