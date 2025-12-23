import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';

/// Number selector widget for roulette predictions
class NumberSelector extends StatelessWidget {
  final int? selectedNumber;
  final ValueChanged<int>? onNumberSelected;
  final bool showColors;
  final double itemHeight;

  const NumberSelector({
    super.key,
    this.selectedNumber,
    this.onNumberSelected,
    this.showColors = true,
    this.itemHeight = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: itemHeight * 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 37,
        itemBuilder: (context, index) {
          final isSelected = selectedNumber == index;
          final color = showColors ? _getNumberColor(index) : null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _NumberSelectorItem(
              number: index,
              isSelected: isSelected,
              color: color,
              onTap: onNumberSelected != null
                  ? () => onNumberSelected!(index)
                  : null,
              height: itemHeight,
            ),
          );
        },
      ),
    );
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

class _NumberSelectorItem extends StatelessWidget {
  final int number;
  final bool isSelected;
  final Color? color;
  final VoidCallback? onTap;
  final double height;

  const _NumberSelectorItem({
    required this.number,
    this.isSelected = false,
    this.color,
    this.onTap,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Semantics(
      label: 'Número $number',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: height,
          height: height,
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: effectiveColor.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: height * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scale(
          duration: const Duration(milliseconds: 200),
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
        );
  }
}

/// Compact number display for history
class CompactNumberDisplay extends StatelessWidget {
  final int number;
  final double size;

  const CompactNumberDisplay({
    super.key,
    required this.number,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getNumberColor(number);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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

/// Scrollable history of numbers
class NumberHistory extends StatelessWidget {
  final List<int> numbers;
  final int? highlightNumber;
  final double itemSize;

  const NumberHistory({
    super.key,
    required this.numbers,
    this.highlightNumber,
    this.itemSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (numbers.isEmpty) {
      return Center(
        child: Text(
          'No hay giros todavía',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      );
    }

    return SizedBox(
      height: itemSize + 16,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: numbers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final reversedIndex = numbers.length - 1 - index;
          final number = numbers[reversedIndex];
          final isHighlighted = highlightNumber == number;

          return AnimatedScale(
            scale: isHighlighted ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: CompactNumberDisplay(
              number: number,
              size: itemSize,
            ),
          )
              .animate(delay: Duration(milliseconds: index * 50))
              .fadeIn(duration: 300.ms)
              .slideX(begin: 0.3, end: 0, duration: 300.ms);
        },
      ),
    );
  }
}

/// Number frequency display for statistics
class NumberFrequency extends StatelessWidget {
  final Map<int, int> frequency;
  final int maxCount;

  const NumberFrequency({
    super.key,
    required this.frequency,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedEntries.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final entry = sortedEntries[index];
        final percentage = (entry.value / maxCount * 100).toStringAsFixed(1);

        return ListTile(
          leading: CompactNumberDisplay(
            number: entry.key,
            size: 32,
          ),
          title: Text('Número ${entry.key}'),
          subtitle: Text('Apariciones: ${entry.value}'),
          trailing: Text(
            '$percentage%',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

/// Prediction display widget
class PredictionDisplay extends StatelessWidget {
  final int predictedNumber;
  final String? description;
  final VoidCallback? onTap;

  const PredictionDisplay({
    super.key,
    required this.predictedNumber,
    this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getNumberColor(predictedNumber);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.colorScheme.tertiary.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 32,
                    color: theme.colorScheme.tertiary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Predicción sugerida',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    predictedNumber.toString(),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 12),
                Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(
          duration: 500.ms,
          curve: Curves.elasticOut,
        );
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
