#!/usr/bin/env python3
"""
Tests para el proyecto
Construido por El Taller de Los Cinco Mandamases
"""

def test_ejemplo():
    """Test de ejemplo"""
    assert True, "Este test siempre pasa"

def test_taller():
    """Test del taller"""
    mandamases = ["Suri", "Bochi", "Analista", "Equilibrador", "Lalo"]
    assert len(mandamases) == 5, "Deben ser 5 mandamases"

if __name__ == '__main__':
    print("Ejecutando tests...")
    test_ejemplo()
    test_taller()
    print("✅ Todos los tests pasaron")
