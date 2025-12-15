import 'package:flutter/material.dart';

/// Dialog de advertencia para la estrategia Martingale
/// Muestra información importante sobre los riesgos de la estrategia
class MartingaleWarningDialog extends StatelessWidget {
  const MartingaleWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.orange,
        size: 48,
      ),
      title: const Text(
        '⚠️ Advertencia Importante',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estrategia Martingale',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'La estrategia Martingale consiste en doblar la apuesta después de cada pérdida. '
              'Aunque matemáticamente puede parecer viable, tiene riesgos significativos:',
            ),
            const SizedBox(height: 12),
            _buildRiskPoint('📉 Puede agotar tu balance rápidamente'),
            _buildRiskPoint('💸 Requiere capital inicial muy alto'),
            _buildRiskPoint('🎰 No elimina la ventaja de la casa'),
            _buildRiskPoint('⚡ Rachas perdedoras pueden ser devastadoras'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: const Text(
                '🚨 IMPORTANTE: Esta es una simulación EDUCATIVA.\n\n'
                'NO uses esta estrategia con dinero real. '
                'El juego puede ser adictivo.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '¿Deseas continuar y activar Martingale?',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text(
            'Entiendo los riesgos',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget _buildRiskPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra el dialog y retorna true si el usuario acepta
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,  // Debe responder explícitamente
      builder: (context) => const MartingaleWarningDialog(),
    );
    return result ?? false;
  }
}
