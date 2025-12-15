#!/usr/bin/env python3
"""
Tokyo Roulette - Parallel Test Runner
Ejecuta tests de Flutter en paralelo para mayor velocidad.
"""

import os
import sys
import subprocess
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import List, Dict, Tuple
import argparse


class Colors:
    """Códigos ANSI para output colorido"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'


class TestRunner:
    """Ejecutor de tests paralelo con reporte JSON"""
    
    def __init__(self, project_root: str, workers: int = 4, timeout: int = 120, verbose: bool = False):
        self.project_root = Path(project_root).resolve()
        self.test_dir = self.project_root / 'test'
        self.workers = workers
        self.timeout = timeout
        self.verbose = verbose
        self.results = []
        
    def discover_tests(self) -> List[Path]:
        """Descubre todos los archivos *_test.dart"""
        if not self.test_dir.exists():
            print(f"{Colors.RED}❌ Test directory not found: {self.test_dir}{Colors.END}")
            return []
        
        test_files = list(self.test_dir.rglob('*_test.dart'))
        print(f"{Colors.BLUE}🔍 Discovered {len(test_files)} test files{Colors.END}")
        
        if self.verbose:
            for test_file in test_files:
                print(f"  • {test_file.relative_to(self.project_root)}")
        
        return test_files
    
    def run_single_test(self, test_file: Path) -> Dict:
        """Ejecuta un solo test y retorna resultado"""
        test_name = test_file.relative_to(self.project_root)
        start_time = time.time()
        
        if self.verbose:
            print(f"{Colors.YELLOW}⏳ Running: {test_name}{Colors.END}")
        
        try:
            result = subprocess.run(
                ['flutter', 'test', str(test_file)],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=self.timeout
            )
            
            duration = time.time() - start_time
            success = result.returncode == 0
            
            test_result = {
                'test_file': str(test_name),
                'status': 'passed' if success else 'failed',
                'duration': round(duration, 2),
                'exit_code': result.returncode,
                'stdout': result.stdout if self.verbose else '',
                'stderr': result.stderr if not success else ''
            }
            
            # Output en consola
            if success:
                print(f"{Colors.GREEN}✅ PASSED{Colors.END} {test_name} ({duration:.2f}s)")
            else:
                print(f"{Colors.RED}❌ FAILED{Colors.END} {test_name} ({duration:.2f}s)")
                if result.stderr:
                    print(f"   Error: {result.stderr[:200]}")
            
            return test_result
            
        except subprocess.TimeoutExpired:
            duration = time.time() - start_time
            print(f"{Colors.RED}⏱️  TIMEOUT{Colors.END} {test_name} (>{self.timeout}s)")
            return {
                'test_file': str(test_name),
                'status': 'timeout',
                'duration': round(duration, 2),
                'exit_code': -1,
                'error': f'Test exceeded timeout of {self.timeout}s'
            }
        
        except Exception as e:
            duration = time.time() - start_time
            print(f"{Colors.RED}💥 ERROR{Colors.END} {test_name}: {str(e)}")
            return {
                'test_file': str(test_name),
                'status': 'error',
                'duration': round(duration, 2),
                'exit_code': -1,
                'error': str(e)
            }
    
    def run_tests_parallel(self, test_files: List[Path]) -> List[Dict]:
        """Ejecuta tests en paralelo usando ThreadPoolExecutor"""
        if not test_files:
            return []
        
        print(f"\n{Colors.BOLD}🚀 Running {len(test_files)} tests with {self.workers} workers...{Colors.END}\n")
        
        with ThreadPoolExecutor(max_workers=self.workers) as executor:
            futures = {executor.submit(self.run_single_test, test): test for test in test_files}
            
            for future in as_completed(futures):
                result = future.result()
                self.results.append(result)
        
        return self.results
    
    def generate_report(self) -> Dict:
        """Genera reporte JSON con estadísticas"""
        if not self.results:
            return {
                'summary': {
                    'total': 0,
                    'passed': 0,
                    'failed': 0,
                    'timeout': 0,
                    'error': 0,
                    'duration': 0.0
                },
                'tests': []
            }
        
        passed = sum(1 for r in self.results if r['status'] == 'passed')
        failed = sum(1 for r in self.results if r['status'] == 'failed')
        timeout = sum(1 for r in self.results if r['status'] == 'timeout')
        error = sum(1 for r in self.results if r['status'] == 'error')
        total_duration = sum(r['duration'] for r in self.results)
        
        report = {
            'summary': {
                'total': len(self.results),
                'passed': passed,
                'failed': failed,
                'timeout': timeout,
                'error': error,
                'duration': round(total_duration, 2),
                'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
            },
            'tests': self.results
        }
        
        return report
    
    def print_summary(self, report: Dict):
        """Imprime resumen en consola"""
        summary = report['summary']
        
        print(f"\n{'='*60}")
        print(f"{Colors.BOLD}📊 TEST SUMMARY{Colors.END}")
        print(f"{'='*60}")
        print(f"Total:    {summary['total']}")
        print(f"{Colors.GREEN}Passed:   {summary['passed']}{Colors.END}")
        
        if summary['failed'] > 0:
            print(f"{Colors.RED}Failed:   {summary['failed']}{Colors.END}")
        if summary['timeout'] > 0:
            print(f"{Colors.YELLOW}Timeout:  {summary['timeout']}{Colors.END}")
        if summary['error'] > 0:
            print(f"{Colors.RED}Error:    {summary['error']}{Colors.END}")
        
        print(f"Duration: {summary['duration']:.2f}s")
        print(f"{'='*60}\n")
    
    def save_report(self, report: Dict, output_file: str = 'test_report.json'):
        """Guarda reporte en archivo JSON"""
        report_path = self.project_root / output_file
        with open(report_path, 'w') as f:
            json.dump(report, f, indent=2)
        
        print(f"{Colors.BLUE}💾 Report saved to: {report_path}{Colors.END}")
    
    def run(self, save_report: bool = True) -> int:
        """Ejecuta pipeline completo de tests"""
        print(f"{Colors.BOLD}Tokyo Roulette - Parallel Test Runner{Colors.END}")
        print(f"Project: {self.project_root}")
        print(f"Workers: {self.workers}")
        print(f"Timeout: {self.timeout}s\n")
        
        # Descubrir tests
        test_files = self.discover_tests()
        
        if not test_files:
            print(f"{Colors.YELLOW}⚠️  No test files found{Colors.END}")
            return 2  # Exit code 2 = no tests
        
        # Ejecutar tests
        start_time = time.time()
        self.run_tests_parallel(test_files)
        total_time = time.time() - start_time
        
        # Generar reporte
        report = self.generate_report()
        report['summary']['total_time'] = round(total_time, 2)
        
        # Output
        self.print_summary(report)
        
        if save_report:
            self.save_report(report)
        
        # Exit code basado en resultados
        summary = report['summary']
        if summary['failed'] > 0 or summary['timeout'] > 0 or summary['error'] > 0:
            return 1  # Exit code 1 = tests failed
        
        return 0  # Exit code 0 = all tests passed


def main():
    parser = argparse.ArgumentParser(
        description='Parallel test runner for Flutter projects',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                          # Run all tests with default settings
  %(prog)s --workers 8              # Use 8 parallel workers
  %(prog)s --timeout 180            # Set timeout to 180s
  %(prog)s --verbose                # Show detailed output
  %(prog)s --no-report              # Don't save JSON report

Exit codes:
  0 - All tests passed
  1 - One or more tests failed
  2 - No tests found
  3 - Error running tests
        """
    )
    
    parser.add_argument('--workers', type=int, default=4,
                       help='Number of parallel workers (default: 4)')
    parser.add_argument('--timeout', type=int, default=120,
                       help='Timeout per test in seconds (default: 120)')
    parser.add_argument('--project-root', type=str, default='.',
                       help='Project root directory (default: current dir)')
    parser.add_argument('--verbose', action='store_true',
                       help='Show verbose output')
    parser.add_argument('--no-report', action='store_true',
                       help='Don\'t save JSON report file')
    
    args = parser.parse_args()
    
    try:
        runner = TestRunner(
            project_root=args.project_root,
            workers=args.workers,
            timeout=args.timeout,
            verbose=args.verbose
        )
        
        exit_code = runner.run(save_report=not args.no_report)
        sys.exit(exit_code)
        
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}⚠️  Test run interrupted by user{Colors.END}")
        sys.exit(3)
    
    except Exception as e:
        print(f"\n{Colors.RED}💥 Fatal error: {str(e)}{Colors.END}")
        sys.exit(3)


if __name__ == '__main__':
    main()
