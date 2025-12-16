import 'package:flutter/material.dart';

/// Dialog de verificación de edad para cumplimiento legal
/// Verifica que el usuario sea mayor de 18 años
class AgeVerificationDialog extends StatelessWidget {
  const AgeVerificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.shield_outlined,
        color: Colors.blue,
        size: 48,
      ),
      title: const Text(
        'Verificación de Edad',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Para usar esta aplicación debes ser mayor de 18 años.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Esta es una aplicación educativa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No involucra dinero real ni promueve juegos de azar. '
                    'Es una herramienta de aprendizaje sobre probabilidades y estrategias.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Eres mayor de 18 años?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sí, soy mayor de 18'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  /// Muestra el dialog y retorna true si el usuario confirma ser mayor de edad
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,  // Debe responder explícitamente
      builder: (context) => const AgeVerificationDialog(),
    );
    return result ?? false;
  }
}

/// Widget que cierra la app si no se cumple verificación de edad
class AgeVerificationWrapper extends StatefulWidget {
  final Widget child;
  
  const AgeVerificationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AgeVerificationWrapper> createState() => _AgeVerificationWrapperState();
}

class _AgeVerificationWrapperState extends State<AgeVerificationWrapper> {
  bool _verified = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkAgeVerification();
  }

  Future<void> _checkAgeVerification() async {
    // Aquí podrías verificar si ya se hizo la verificación
    // Por ejemplo, usando SharedPreferences
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    final verified = await AgeVerificationDialog.show(context);
    
    if (!verified) {
      // Si no es mayor de edad, mostrar mensaje y cerrar
      if (!mounted) return;
      
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Acceso Denegado'),
          content: const Text(
            'Debes ser mayor de 18 años para usar esta aplicación.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Cerrar la app
                // En producción, usar: SystemNavigator.pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } else {
      // Guardar verificación
      // await _saveAgeVerification();
      
      setState(() {
        _verified = true;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_verified) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.block,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Acceso Denegado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Debes ser mayor de 18 años',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
