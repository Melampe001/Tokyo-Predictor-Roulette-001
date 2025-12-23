import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';

/// Casino-style betting chip widget
class BetChip extends StatelessWidget {
  final double value;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const BetChip({
    super.key,
    required this.value,
    this.isSelected = false,
    this.onTap,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = _getChipColor(value);

    return Semantics(
      label: 'Ficha de apuesta: ${value.toStringAsFixed(0)} pesos',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: chipColor,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.white,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Outer ring pattern
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                margin: const EdgeInsets.all(4),
              ),
              // Inner pattern
              Center(
                child: Container(
                  width: size * 0.7,
                  height: size * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chipColor.withOpacity(0.8),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '\$${value.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size * 0.25,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scale(
          duration: const Duration(milliseconds: 200),
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
        )
        .rotate(
          duration: const Duration(milliseconds: 200),
          begin: 0,
          end: 0.05,
        );
  }

  Color _getChipColor(double value) {
    if (value <= 10) {
      return const Color(0xFFE53935); // Red
    } else if (value <= 50) {
      return const Color(0xFF1E88E5); // Blue
    } else if (value <= 100) {
      return const Color(0xFF43A047); // Green
    } else if (value <= 500) {
      return const Color(0xFF000000); // Black
    } else {
      return const Color(0xFFFFD700); // Gold
    }
  }
}

/// Chip selector widget with multiple chip values
class BetChipSelector extends StatelessWidget {
  final double selectedValue;
  final ValueChanged<double> onChipSelected;
  final List<double> chipValues;

  const BetChipSelector({
    super.key,
    required this.selectedValue,
    required this.onChipSelected,
    this.chipValues = const [10, 25, 50, 100, 250, 500],
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: chipValues.map((value) {
        return BetChip(
          value: value,
          isSelected: selectedValue == value,
          onTap: () => onChipSelected(value),
          size: 56,
        );
      }).toList(),
    );
  }
}

/// Stack of chips showing current bet
class ChipStack extends StatelessWidget {
  final double amount;
  final int maxChipsToShow;

  const ChipStack({
    super.key,
    required this.amount,
    this.maxChipsToShow = 5,
  });

  @override
  Widget build(BuildContext context) {
    final chipCount = (amount / 10).ceil().clamp(1, maxChipsToShow);

    return SizedBox(
      height: 60 + (chipCount * 4),
      width: 60,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: List.generate(chipCount, (index) {
          return Positioned(
            bottom: index * 4.0,
            child: BetChip(
              value: 10,
              size: 60,
            ).animate(delay: Duration(milliseconds: index * 50)).slideY(
                  begin: -1,
                  end: 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
                ),
          );
        }),
      ),
    );
  }
}

/// Roulette number display chip
class NumberChip extends StatelessWidget {
  final int number;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;

  const NumberChip({
    super.key,
    required this.number,
    this.isSelected = false,
    this.onTap,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getNumberColor(number);

    return Semantics(
      label: 'Número $number',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.white.withOpacity(0.3),
              width: isSelected ? 3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: isSelected ? 6 : 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.4,
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
          end: const Offset(1.15, 1.15),
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

/// Grid of roulette numbers for selection
class RouletteNumberGrid extends StatelessWidget {
  final int? selectedNumber;
  final ValueChanged<int>? onNumberSelected;
  final int columns;

  const RouletteNumberGrid({
    super.key,
    this.selectedNumber,
    this.onNumberSelected,
    this.columns = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 37,
      itemBuilder: (context, index) {
        return NumberChip(
          number: index,
          isSelected: selectedNumber == index,
          onTap: onNumberSelected != null
              ? () => onNumberSelected!(index)
              : null,
        );
      },
    );
  }
}
