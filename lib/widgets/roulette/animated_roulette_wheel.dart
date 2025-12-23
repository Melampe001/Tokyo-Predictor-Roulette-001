import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_constants.dart';

/// Animated roulette wheel with physics-based spinning
class AnimatedRouletteWheel extends StatefulWidget {
  final int? resultNumber;
  final int? predictionNumber;
  final VoidCallback? onSpinComplete;
  final double size;
  final bool isSpinning;

  const AnimatedRouletteWheel({
    super.key,
    this.resultNumber,
    this.predictionNumber,
    this.onSpinComplete,
    this.size = 300,
    this.isSpinning = false,
  });

  @override
  State<AnimatedRouletteWheel> createState() => _AnimatedRouletteWheelState();
}

class _AnimatedRouletteWheelState extends State<AnimatedRouletteWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  double _currentRotation = 0;

  // European roulette wheel number sequence
  static const List<int> wheelSequence = [
    0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10,
    5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
  ];

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    );

    _spinController.addListener(() {
      setState(() {
        _currentRotation = _spinAnimation.value;
      });
    });

    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onSpinComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedRouletteWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning && widget.resultNumber != null) {
      _spin(widget.resultNumber!);
    }
  }

  void _spin(int targetNumber) {
    final targetIndex = wheelSequence.indexOf(targetNumber);
    final targetAngle = (targetIndex / wheelSequence.length) * 2 * math.pi;
    
    // Add multiple rotations for dramatic effect
    final totalRotations = 5 + math.Random().nextDouble() * 2;
    final totalAngle = (totalRotations * 2 * math.pi) + targetAngle;

    _spinController.reset();
    _spinAnimation = Tween<double>(
      begin: _currentRotation,
      end: _currentRotation + totalAngle,
    ).animate(CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCubic,
    ));

    _spinController.forward();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rim
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B4513),
                  const Color(0xFF654321),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // Spinning wheel
          Transform.rotate(
            angle: _currentRotation,
            child: CustomPaint(
              size: Size(widget.size * 0.9, widget.size * 0.9),
              painter: RouletteWheelPainter(
                predictionNumber: widget.predictionNumber,
              ),
            ),
          ),
          // Center circle
          Container(
            width: widget.size * 0.15,
            height: widget.size * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD700),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.casino,
                color: Colors.white,
                size: widget.size * 0.08,
              ),
            ),
          ),
          // Pointer/indicator at top
          Positioned(
            top: widget.size * 0.02,
            child: Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 12,
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    width: 12,
                    color: Colors.transparent,
                  ),
                  bottom: BorderSide(
                    width: 20,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the roulette wheel
class RouletteWheelPainter extends CustomPainter {
  final int? predictionNumber;

  RouletteWheelPainter({this.predictionNumber});

  static const List<int> wheelSequence = [
    0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10,
    5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = 2 * math.pi / wheelSequence.length;

    for (int i = 0; i < wheelSequence.length; i++) {
      final number = wheelSequence[i];
      final startAngle = i * segmentAngle - math.pi / 2;
      final isPrediction = predictionNumber == number;

      // Determine color
      final color = _getNumberColor(number);
      final paint = Paint()
        ..color = isPrediction ? color.withOpacity(0.8) : color
        ..style = PaintingStyle.fill;

      // Draw segment
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          segmentAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawPath(path, borderPaint);

      // Draw prediction highlight
      if (isPrediction) {
        final highlightPaint = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawPath(path, highlightPaint);
      }

      // Draw number
      final middleAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.75;
      final textX = center.dx + textRadius * math.cos(middleAngle);
      final textY = center.dy + textRadius * math.sin(middleAngle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: number.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isPrediction ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          textX - textPainter.width / 2,
          textY - textPainter.height / 2,
        ),
      );
    }
  }

  Color _getNumberColor(int number) {
    if (number == 0) {
      return const Color(0xFF2E7D32); // Green
    } else if (AppConstants.redNumbers.contains(number)) {
      return const Color(0xFFD32F2F); // Red
    } else {
      return const Color(0xFF1A1A1A); // Black
    }
  }

  @override
  bool shouldRepaint(RouletteWheelPainter oldDelegate) {
    return predictionNumber != oldDelegate.predictionNumber;
  }
}

/// Simple roulette result display
class RouletteResultDisplay extends StatelessWidget {
  final int? number;
  final double size;
  final bool animate;

  const RouletteResultDisplay({
    super.key,
    this.number,
    this.size = 120,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (number == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceVariant,
        ),
        child: Center(
          child: Icon(
            Icons.help_outline,
            size: size * 0.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final color = _getNumberColor(number!);
    
    Widget result = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    if (animate) {
      result = result
          .animate()
          .scale(
            duration: 500.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(duration: 300.ms);
    }

    return result;
  }

  Color _getNumberColor(int number) {
    if (number == 0) {
      return const Color(0xFF2E7D32); // Green
    } else if (AppConstants.redNumbers.contains(number)) {
      return const Color(0xFFD32F2F); // Red
    } else {
      return const Color(0xFF1A1A1A); // Black
    }
  }
}

/// Spin button with animation
class SpinButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSpinning;
  final bool isDisabled;

  const SpinButton({
    super.key,
    this.onPressed,
    this.isSpinning = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isDisabled || isSpinning ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
      child: isSpinning
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'GIRAR',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    )
        .animate(target: isSpinning ? 1 : 0)
        .shake(duration: 500.ms, hz: 2);
  }
}
