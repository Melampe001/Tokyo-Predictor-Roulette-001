import 'package:flutter/material.dart';
import '../roulette_logic.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RouletteLogic _rouletteLogic = RouletteLogic();
  String result = 'Presiona Girar';
  List<int> history = [];
  double bet = 10.0;

  void spinRoulette() {
    // Usa RouletteLogic con RNG seguro
    final res = _rouletteLogic.generateSpin();
    setState(() {
      result = res.toString();
      history.add(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruleta')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Resultado: $result'),
            Text('Historia: ${history.join(', ')}'),
            ElevatedButton(
              onPressed: spinRoulette,
              child: const Text('Girar Ruleta'),
            ),
            // TODO: Agregar más widgets para Martingale, predicciones, etc.
          ],
        ),
      ),
    );
  }
}
