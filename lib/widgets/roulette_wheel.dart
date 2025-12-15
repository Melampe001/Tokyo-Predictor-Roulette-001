import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_animations.dart';
import '../utils/helpers.dart';

/// Widget animado de ruleta
class RouletteWheel extends StatefulWidget {
  final int? currentNumber;
  final bool isSpinning;
  final VoidCallback? onSpinComplete;

  const RouletteWheel({
    super.key,
    this.currentNumber,
    this.isSpinning = false,
    this.onSpinComplete,
  });

  @override
  State<RouletteWheel> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.spin,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.spinCurve,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onSpinComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(RouletteWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Resultado',
              style: AppTypography.h5,
            ),
            const SizedBox(height: 16),
            
            // Ruleta animada
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 4 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: widget.currentNumber == null
                      ? Colors.grey.shade300
                      : _getNumberColor(widget.currentNumber!),
                  shape: BoxShape.circle,
                  boxShadow: AppColors.elevatedShadow,
                  gradient: widget.isSpinning
                      ? AppColors.primaryGradient
                      : null,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: AppAnimations.normal,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Text(
                      widget.currentNumber?.toString() ?? '?',
                      key: ValueKey<int?>(widget.currentNumber),
                      style: AppTypography.rouletteNumberLarge,
                    ),
                  ),
                ),
              ),
            ),
            
            // Indicador de giro
            if (widget.isSpinning) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Girando...',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            
            // Información del número
            if (widget.currentNumber != null && !widget.isSpinning) ...[
              const SizedBox(height: 16),
              _NumberInfo(number: widget.currentNumber!),
            ],
          ],
        ),
      ),
    );
  }

  Color _getNumberColor(int number) {
    if (number == 0) return AppColors.rouletteGreen;
    if (Helpers.isRedNumber(number)) return AppColors.rouletteRed;
    return AppColors.rouletteBlack;
  }
}

/// Widget de información del número
class _NumberInfo extends StatelessWidget {
  final int number;

  const _NumberInfo({required this.number});

  @override
  Widget build(BuildContext context) {
    final properties = <String>[];
    
    if (number == 0) {
      properties.add('Verde');
    } else {
      properties.add(Helpers.isRedNumber(number) ? 'Rojo' : 'Negro');
      properties.add(Helpers.isEvenNumber(number) ? 'Par' : 'Impar');
      properties.add(Helpers.isLowNumber(number) ? 'Bajo (1-18)' : 'Alto (19-36)');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: properties.map((prop) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            prop,
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
