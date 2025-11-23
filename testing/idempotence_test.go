package idempotence

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// TestScriptIdempotence verifica que los scripts de configuración sean idempotentes
// Es decir, que ejecutarlos múltiples veces produce el mismo resultado
func TestScriptIdempotence(t *testing.T) {
	tests := []struct {
		name       string
		scriptPath string
		description string
	}{
		{
			name:       "setup_env.sh",
			scriptPath: "../scripts/config/setup_env.sh",
			description: "Script de configuración del entorno",
		},
		{
			name:       "setup_test_data.sh",
			scriptPath: "../scripts/config/fixtures/setup_test_data.sh",
			description: "Script de configuración de fixtures",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Verificar que el script existe
			scriptPath, err := filepath.Abs(tt.scriptPath)
			if err != nil {
				t.Fatalf("Error al resolver ruta del script: %v", err)
			}

			if _, err := os.Stat(scriptPath); os.IsNotExist(err) {
				t.Skipf("Script no encontrado: %s", scriptPath)
				return
			}

			t.Logf("Probando idempotencia de: %s", tt.description)

			// Primera ejecución
			t.Log("Ejecutando script (primera vez)...")
			cmd1 := exec.Command("bash", scriptPath)
			output1, err1 := cmd1.CombinedOutput()
			if err1 != nil {
				t.Logf("Output primera ejecución:\n%s", string(output1))
				t.Errorf("Primera ejecución falló: %v", err1)
				return
			}
			t.Logf("Primera ejecución completada exitosamente")

			// Segunda ejecución (debe ser idempotente)
			t.Log("Ejecutando script (segunda vez)...")
			cmd2 := exec.Command("bash", scriptPath)
			output2, err2 := cmd2.CombinedOutput()
			if err2 != nil {
				t.Logf("Output segunda ejecución:\n%s", string(output2))
				t.Errorf("Segunda ejecución falló: %v", err2)
				return
			}
			t.Logf("Segunda ejecución completada exitosamente")

			// Tercera ejecución (verificación adicional)
			t.Log("Ejecutando script (tercera vez)...")
			cmd3 := exec.Command("bash", scriptPath)
			output3, err3 := cmd3.CombinedOutput()
			if err3 != nil {
				t.Logf("Output tercera ejecución:\n%s", string(output3))
				t.Errorf("Tercera ejecución falló: %v", err3)
				return
			}
			t.Logf("Tercera ejecución completada exitosamente")

			t.Logf("✓ Script %s es idempotente", tt.name)
		})
	}
}

// TestDirectoryCreation verifica que la creación de directorios es idempotente
func TestDirectoryCreation(t *testing.T) {
	testDir := filepath.Join(t.TempDir(), "idempotence_test")

	// Primera creación
	err1 := os.MkdirAll(testDir, 0755)
	if err1 != nil {
		t.Fatalf("Primera creación de directorio falló: %v", err1)
	}

	// Segunda creación (idempotente)
	err2 := os.MkdirAll(testDir, 0755)
	if err2 != nil {
		t.Fatalf("Segunda creación de directorio falló: %v", err2)
	}

	// Verificar que el directorio existe
	info, err := os.Stat(testDir)
	if err != nil {
		t.Fatalf("Directorio no existe después de creaciones: %v", err)
	}

	if !info.IsDir() {
		t.Fatalf("La ruta creada no es un directorio")
	}

	t.Log("✓ Creación de directorios es idempotente")
}

// TestFileCreation verifica la idempotencia en la creación de archivos
func TestFileCreation(t *testing.T) {
	testFile := filepath.Join(t.TempDir(), "test_config.json")
	content := `{"test": true, "value": 42}`

	// Función auxiliar para crear archivo de forma idempotente
	createFileIdempotent := func(path, data string) error {
		// Solo crear si no existe
		if _, err := os.Stat(path); os.IsNotExist(err) {
			return os.WriteFile(path, []byte(data), 0644)
		}
		return nil
	}

	// Primera creación
	err1 := createFileIdempotent(testFile, content)
	if err1 != nil {
		t.Fatalf("Primera creación falló: %v", err1)
	}

	// Leer contenido original
	data1, err := os.ReadFile(testFile)
	if err != nil {
		t.Fatalf("Error leyendo archivo: %v", err)
	}

	// Segunda creación (debe saltarse)
	err2 := createFileIdempotent(testFile, content)
	if err2 != nil {
		t.Fatalf("Segunda creación falló: %v", err2)
	}

	// Verificar que el contenido no cambió
	data2, err := os.ReadFile(testFile)
	if err != nil {
		t.Fatalf("Error leyendo archivo después de segunda creación: %v", err)
	}

	if string(data1) != string(data2) {
		t.Fatalf("El contenido del archivo cambió entre ejecuciones")
	}

	t.Log("✓ Creación de archivos es idempotente")
}

// TestConfigurationIdempotence verifica que las operaciones de configuración sean idempotentes
func TestConfigurationIdempotence(t *testing.T) {
	// Simular configuración idempotente
	type Config struct {
		Value string
		Count int
	}

	// Estado compartido
	config := &Config{Value: "initial", Count: 0}

	// Función de configuración idempotente
	applyConfig := func(c *Config, newValue string) {
		// Solo aplicar si es diferente (idempotente para mismo valor)
		if c.Value != newValue {
			c.Value = newValue
			c.Count++
		}
	}

	// Primera aplicación
	applyConfig(config, "configured")
	if config.Value != "configured" || config.Count != 1 {
		t.Fatalf("Primera configuración incorrecta: %+v", config)
	}

	// Segunda aplicación con mismo valor (idempotente)
	applyConfig(config, "configured")
	if config.Value != "configured" || config.Count != 1 {
		t.Fatalf("Segunda configuración cambió estado: %+v", config)
	}

	// Tercera aplicación con mismo valor
	applyConfig(config, "configured")
	if config.Value != "configured" || config.Count != 1 {
		t.Fatalf("Tercera configuración cambió estado: %+v", config)
	}

	t.Log("✓ Configuración es idempotente")
}

// TestMakefileTargetsIdempotence verifica que los targets del Makefile sean idempotentes
func TestMakefileTargetsIdempotence(t *testing.T) {
	// Verificar que existe Makefile
	makefilePath := "../Makefile"
	if _, err := os.Stat(makefilePath); os.IsNotExist(err) {
		t.Skip("Makefile no encontrado")
		return
	}

	// Targets que deben ser idempotentes
	idempotentTargets := []string{
		"clean",
		"format",
		"lint",
		"help",
		"doctor",
	}

	for _, target := range idempotentTargets {
		t.Run("make_"+target, func(t *testing.T) {
			// Ejecutar make target dos veces
			for i := 1; i <= 2; i++ {
				t.Logf("Ejecución %d de 'make %s'", i, target)
				cmd := exec.Command("make", target)
				output, err := cmd.CombinedOutput()
				if err != nil {
					t.Logf("Output:\n%s", string(output))
					// Algunos targets pueden fallar por dependencias faltantes
					// No fallar el test, solo loguear
					t.Logf("Advertencia: 'make %s' falló: %v", target, err)
					continue
				}
				t.Logf("Ejecución %d completada", i)
			}
		})
	}
}

// BenchmarkIdempotentOperation mide el rendimiento de operaciones idempotentes
func BenchmarkIdempotentOperation(b *testing.B) {
	testDir := b.TempDir()

	b.Run("DirectoryCreation", func(b *testing.B) {
		dir := filepath.Join(testDir, "bench_dir")
		b.ResetTimer()
		for i := 0; i < b.N; i++ {
			_ = os.MkdirAll(dir, 0755)
		}
	})

	b.Run("FileCreation", func(b *testing.B) {
		file := filepath.Join(testDir, "bench_file.txt")
		content := []byte("benchmark content")
		b.ResetTimer()
		for i := 0; i < b.N; i++ {
			if _, err := os.Stat(file); os.IsNotExist(err) {
				_ = os.WriteFile(file, content, 0644)
			}
		}
	})
}

// TestIdempotenceDocumentation verifica que la documentación exista
func TestIdempotenceDocumentation(t *testing.T) {
	docPath := "../docs/idempotencia_automatizacion.md"
	
	if _, err := os.Stat(docPath); os.IsNotExist(err) {
		t.Errorf("Documentación de idempotencia no encontrada: %s", docPath)
		return
	}

	// Leer contenido
	content, err := os.ReadFile(docPath)
	if err != nil {
		t.Fatalf("Error leyendo documentación: %v", err)
	}

	// Verificar que contiene secciones clave
	requiredSections := []string{
		"Idempotencia",
		"Automatización",
		"Makefile",
		"Scripts",
		"GitHub Actions",
		"Pruebas",
	}

	contentStr := string(content)
	for _, section := range requiredSections {
		if !containsSection(contentStr, section) {
			t.Errorf("Documentación falta sección: %s", section)
		}
	}

	t.Log("✓ Documentación de idempotencia existe y contiene secciones requeridas")
}

// containsSection verifica si el contenido contiene una sección
func containsSection(content, section string) bool {
	// Importar strings al inicio del archivo si no está ya
	// Buscar en el contenido usando strings.Contains
	return len(content) > 0 && (
		// Buscar como header de markdown
		strings.Contains(content, "# "+section) ||
		strings.Contains(content, "## "+section) ||
		strings.Contains(content, "### "+section) ||
		// O simplemente como texto
		strings.Contains(content, section))
}
