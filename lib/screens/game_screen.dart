import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/balance_display.dart';
import '../widgets/roulette_wheel.dart';
import '../widgets/prediction_card.dart';
import '../widgets/history_card.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// Pantalla principal del juego con Provider
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokyo Roulette'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final lastResult = gameProvider.roulette.currentNumber >= 0
                ? (Helpers.isRedNumber(gameProvider.roulette.currentNumber)
                    ? '¡Ganaste! +${Helpers.formatBalance(gameProvider.user.currentBet)}'
                    : 'Perdiste -${Helpers.formatBalance(gameProvider.user.currentBet)}')
                : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Balance Display
                  BalanceDisplay(
                    balance: gameProvider.user.balance,
                    currentBet: gameProvider.user.currentBet,
                    lastResult: lastResult,
                    won: gameProvider.roulette.currentNumber >= 0 &&
                        Helpers.isRedNumber(gameProvider.roulette.currentNumber),
                  ),
                  const SizedBox(height: 16),

                  // Roulette Wheel
                  RouletteWheel(
                    currentNumber: gameProvider.roulette.currentNumber >= 0
                        ? gameProvider.roulette.currentNumber
                        : null,
                    isSpinning: gameProvider.isSpinning,
                  ),
                  const SizedBox(height: 16),

                  // Prediction Card
                  if (gameProvider.currentPrediction != null)
                    PredictionCard(
                      prediction: gameProvider.currentPrediction,
                    ),
                  const SizedBox(height: 16),

                  // Spin Button
                  ElevatedButton.icon(
                    onPressed: gameProvider.canSpin
                        ? () => gameProvider.spin()
                        : null,
                    icon: const Icon(Icons.play_circle_outline, size: 32),
                    label: const Text(
                      'Girar Ruleta',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // History Card
                  HistoryCard(
                    history: gameProvider.roulette.history,
                  ),
                  const SizedBox(height: 16),

                  // Martingale Info
                  if (gameProvider.useMartingale)
                    Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.show_chart, color: Colors.orange),
                                SizedBox(width: 8),
                                Text(
                                  'Estrategia Martingale Activa',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'La apuesta se duplicará automáticamente después de cada pérdida.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Disclaimer
                  const Card(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        AppConstants.educationalDisclaimer,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Configuración'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Martingale Toggle
            Consumer<GameProvider>(
              builder: (context, provider, child) {
                return SwitchListTile(
                  title: const Text('Estrategia Martingale'),
                  subtitle: const Text('Duplica la apuesta tras perder'),
                  value: provider.useMartingale,
                  onChanged: (value) {
                    provider.toggleMartingale(value);
                  },
                );
              },
            ),

            const Divider(),

            // Bet Amount Slider
            Consumer<GameProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apuesta Base: ${Helpers.formatBalance(provider.user.currentBet)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: provider.user.currentBet,
                      min: 1.0,
                      max: provider.user.balance.clamp(1.0, 100.0),
                      divisions: 99,
                      label: Helpers.formatBalance(provider.user.currentBet),
                      onChanged: (value) {
                        provider.setCurrentBet(value);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reiniciar Juego'),
        content: const Text(
          '¿Estás seguro de que quieres reiniciar? '
          'Se perderán todos los datos y el balance volverá a \$1000.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GameProvider>().resetGame();
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Juego reiniciado correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
