import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

/// Win animation widget with confetti and celebration effects
class WinAnimation extends StatefulWidget {
  final double amount;
  final VoidCallback? onComplete;

  const WinAnimation({
    super.key,
    required this.amount,
    this.onComplete,
  });

  @override
  State<WinAnimation> createState() => _WinAnimationState();
}

class _WinAnimationState extends State<WinAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        children: [
          // Confetti particles
          ...List.generate(30, (index) {
            return _ConfettiParticle(
              index: index,
              controller: _controller,
            );
          }),
          // Win message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 120,
                  color: theme.colorScheme.tertiary,
                )
                    .animate(controller: _controller)
                    .scale(
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    )
                    .rotate(
                      duration: 500.ms,
                      begin: -0.1,
                      end: 0,
                    ),
                const SizedBox(height: 24),
                Text(
                  '¡GANASTE!',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate(controller: _controller)
                    .fadeIn(delay: 200.ms, duration: 300.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 16),
                Text(
                  '+\$${widget.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate(controller: _controller)
                    .fadeIn(delay: 400.ms, duration: 300.ms)
                    .scale(
                      delay: 400.ms,
                      duration: 300.ms,
                      curve: Curves.elasticOut,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiParticle extends StatelessWidget {
  final int index;
  final AnimationController controller;

  const _ConfettiParticle({
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index);
    final screenSize = MediaQuery.of(context).size;
    
    final startX = screenSize.width * random.nextDouble();
    final endX = startX + (random.nextDouble() - 0.5) * 200;
    final endY = screenSize.height;
    
    final color = _getRandomColor(random);
    final size = 8.0 + random.nextDouble() * 8;
    final delay = random.nextInt(200);

    return Positioned(
      left: startX,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final progress = controller.value;
          final y = progress * endY;
          final x = startX + (endX - startX) * progress;
          final rotation = progress * math.pi * 4;

          return Transform.translate(
            offset: Offset(x - startX, y),
            child: Transform.rotate(
              angle: rotation,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: random.nextBool() ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: random.nextBool()
                      ? BorderRadius.circular(2)
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      const Color(0xFFFFD700), // Gold
    ];
    return colors[random.nextInt(colors.length)];
  }
}

/// Simple celebration overlay
class CelebrationOverlay extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const CelebrationOverlay({
    super.key,
    required this.message,
    this.icon = Icons.celebration,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 100,
                color: effectiveColor,
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shimmer(
                    duration: 1000.ms,
                    color: Colors.white,
                  ),
              const SizedBox(height: 24),
              Text(
                message,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 300.ms)
                  .slideY(begin: 0.3, end: 0, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pulse animation for highlighting important elements
class PulseAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(
          onComplete: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          duration: duration,
          begin: Offset(minScale, minScale),
          end: Offset(maxScale, maxScale),
          curve: Curves.easeInOut,
        );
  }
}

/// Shake animation for errors or warnings
class ShakeAnimation extends StatelessWidget {
  final Widget child;
  final int count;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return child.animate().shake(
          duration: 500.ms,
          hz: 4,
          curve: Curves.easeInOut,
        );
  }
}

/// Bounce animation for buttons and interactive elements
class BounceAnimation extends StatelessWidget {
  final Widget child;

  const BounceAnimation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child.animate().scale(
          duration: 200.ms,
          curve: Curves.easeOut,
        );
  }
}

/// Fade in animation with slide
class FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Offset begin;

  const FadeInSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.begin = const Offset(0, 0.1),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(delay: delay, duration: 300.ms)
        .slideY(delay: delay, begin: begin.dy, end: 0, duration: 300.ms);
  }
}
