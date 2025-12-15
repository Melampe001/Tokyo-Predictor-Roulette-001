import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/game_provider.dart';
import '../utils/helpers.dart';
import 'game_screen.dart';

/// Pantalla de login simplificada
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    
    // Validar email
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingresa tu email';
      });
      return;
    }
    
    if (!Helpers.isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Por favor ingresa un email válido';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Crear usuario
    final gameProvider = context.read<GameProvider>();
    final user = gameProvider.user.copyWith(
      id: Helpers.generateSimpleId(),
      email: email,
    );
    
    // TODO: Aquí integrar con Firebase Auth cuando esté configurado
    
    if (!mounted) return;
    
    // Navegar a la pantalla principal
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const GameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o título
                const Icon(
                  Icons.casino,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                
                const Text(
                  'Tokyo Roulette',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                const Text(
                  'Simulador Educativo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Campo de email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: const Icon(Icons.email),
                    errorText: _errorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 24),
                
                // Botón de login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Continuar',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.shade200,
                    ),
                  ),
                  child: const Text(
                    '⚠️ Esta es una simulación educativa.\n'
                    'No promueve juegos de azar reales.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
