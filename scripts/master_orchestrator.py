#!/usr/bin/env python3
"""
Master Orchestrator - Control Central de Bots
Coordina la ejecución de todos los agentes y bots
"""
import os
import sys
import subprocess
from pathlib import Path
from datetime import datetime
import time

class MasterOrchestrator:
    def __init__(self, project_root):
        self.project_root = Path(project_root)
        self.scripts_dir = self.project_root / "scripts"
        self.start_time = datetime.now()
        
    def log(self, message, emoji="🎯"):
        timestamp = datetime.now().strftime("%H:%M:%S")
        print(f"{emoji} [{timestamp}] {message}")
        
    def print_banner(self):
        """Imprime banner de inicio"""
        print("\n" + "="*60)
        print("🤖 MASTER ORCHESTRATOR - Tokyo Roulette APK Mission")
        print("="*60)
        print(f"📅 Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"📂 Proyecto: {self.project_root.name}")
        print("="*60 + "\n")
        
    def run_bot(self, bot_name, bot_script):
        """Ejecuta un bot individual"""
        self.log(f"Lanzando {bot_name}...", "🚀")
        
        try:
            result = subprocess.run(
                [sys.executable, str(bot_script), str(self.project_root)],
                capture_output=True,
                text=True,
                timeout=600
            )
            
            print(result.stdout)
            
            if result.returncode == 0:
                self.log(f"{bot_name} COMPLETADO ✓", "✅")
                return True
            else:
                self.log(f"{bot_name} FALLIDO ✗", "❌")
                if result.stderr:
                    print(result.stderr)
                return False
        except subprocess.TimeoutExpired:
            self.log(f"{bot_name} TIMEOUT", "⏱️")
            return False
        except Exception as e:
            self.log(f"{bot_name} ERROR: {str(e)}", "❌")
            return False
            
    def run_agent_1(self):
        """AGENTE 1: Android Config Master"""
        self.log("=" * 60, "🔥")
        self.log("AGENTE 1: Android Config Master", "🔥")
        self.log("=" * 60, "🔥")
        
        bot_script = self.scripts_dir / "bot_gradle_builder.py"
        if not bot_script.exists():
            self.log("Bot script no encontrado", "❌")
            return False
            
        return self.run_bot("Bot 1A: GradleBuilder", bot_script)
        
    def run_agent_2(self):
        """AGENTE 2: Automation Master"""
        self.log("=" * 60, "🤖")
        self.log("AGENTE 2: Automation Master", "🤖")
        self.log("=" * 60, "🤖")
        
        # Bot 2A: TestRunner
        test_bot = self.scripts_dir / "bot_test_runner.py"
        if test_bot.exists():
            if not self.run_bot("Bot 2A: TestRunner", test_bot):
                self.log("TestRunner falló, pero continuando...", "⚠️")
        
        # Bot 2B: APKBuilder
        apk_bot = self.scripts_dir / "bot_apk_builder.py"
        if apk_bot.exists():
            return self.run_bot("Bot 2B: APKBuilder", apk_bot)
        
        return False
        
    def print_summary(self, success):
        """Imprime resumen final"""
        elapsed = (datetime.now() - self.start_time).total_seconds()
        
        print("\n" + "="*60)
        if success:
            print("🎉 MISIÓN COMPLETADA - APK LISTA")
        else:
            print("❌ MISIÓN INCOMPLETA - Revisar logs")
        print("="*60)
        print(f"⏱️  Tiempo total: {elapsed:.1f} segundos")
        print(f"📍 APK ubicación: build/app/outputs/flutter-apk/")
        print("="*60 + "\n")
        
    def run(self):
        """Ejecuta todos los agentes en secuencia"""
        self.print_banner()
        
        agents = [
            ("AGENTE 1: Android Config", self.run_agent_1),
            ("AGENTE 2: Build & Test", self.run_agent_2),
        ]
        
        for agent_name, agent_func in agents:
            self.log(f"\nIniciando {agent_name}...", "🚀")
            if not agent_func():
                self.log(f"{agent_name} falló", "❌")
                self.print_summary(False)
                return False
            time.sleep(1)  # Pequeña pausa entre agentes
            
        self.print_summary(True)
        return True

if __name__ == "__main__":
    project_root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    orchestrator = MasterOrchestrator(project_root)
    success = orchestrator.run()
    sys.exit(0 if success else 1)
