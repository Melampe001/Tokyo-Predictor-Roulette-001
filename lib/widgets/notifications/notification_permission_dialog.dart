import 'package:flutter/material.dart';

/// Dialog to request notification permission
class NotificationPermissionDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const NotificationPermissionDialog({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.notifications_active, color: Colors.blue, size: 28),
          SizedBox(width: 12),
          Text('Notificaciones'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Deseas recibir notificaciones?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Te notificaremos sobre:',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _buildBenefit(
            icon: Icons.lightbulb_outline,
            text: 'Predicciones sugeridas',
          ),
          _buildBenefit(
            icon: Icons.celebration,
            text: 'Logros desbloqueados',
          ),
          _buildBenefit(
            icon: Icons.emoji_events,
            text: 'Desafíos diarios',
          ),
          _buildBenefit(
            icon: Icons.notifications,
            text: 'Actualizaciones importantes',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Puedes cambiar esto en cualquier momento desde la configuración.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDecline();
          },
          child: const Text('Ahora no'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAccept();
          },
          child: const Text('Permitir'),
        ),
      ],
    );
  }

  Widget _buildBenefit({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
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

  /// Show notification permission dialog
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onAccept,
    required VoidCallback onDecline,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NotificationPermissionDialog(
        onAccept: onAccept,
        onDecline: onDecline,
      ),
    );
  }
}
