import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/helpers.dart';

/// Card de historial con visualización de números
class HistoryCard extends StatelessWidget {
  final List<int> history;
  final int maxNumbers;

  const HistoryCard({
    super.key,
    required this.history,
    this.maxNumbers = 20,
  });

  @override
  Widget build(BuildContext context) {
    final displayHistory = history.length > maxNumbers
        ? history.sublist(history.length - maxNumbers)
        : history;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historial Reciente',
                  style: AppTypography.h6,
                ),
                if (history.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${history.length} giros',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (displayHistory.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.casino_outlined,
                        size: 48,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No hay giros todavía',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: displayHistory.reversed.map((number) {
                  return _NumberChip(number: number);
                }).toList(),
              ),
            
            // Estadísticas rápidas
            if (history.length >= 5) ...[
              const Divider(height: 24),
              _QuickStats(history: history),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chip individual para mostrar un número
class _NumberChip extends StatelessWidget {
  final int number;

  const _NumberChip({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _getNumberColor(number),
        shape: BoxShape.circle,
        boxShadow: AppColors.cardShadow,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: AppTypography.rouletteNumber.copyWith(
            fontSize: 18,
          ),
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

/// Widget de estadísticas rápidas
class _QuickStats extends StatelessWidget {
  final List<int> history;

  const _QuickStats({required this.history});

  @override
  Widget build(BuildContext context) {
    final redCount = history.where(Helpers.isRedNumber).length;
    final blackCount = history.where(Helpers.isBlackNumber).length;
    final greenCount = history.where((n) => n == 0).length;
    
    final total = history.length;
    final redPercent = total > 0 ? (redCount / total) : 0.0;
    final blackPercent = total > 0 ? (blackCount / total) : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          label: 'Rojos',
          count: redCount,
          percent: redPercent,
          color: AppColors.rouletteRed,
        ),
        _StatItem(
          label: 'Negros',
          count: blackCount,
          percent: blackPercent,
          color: AppColors.rouletteBlack,
        ),
        _StatItem(
          label: 'Verdes',
          count: greenCount,
          percent: total > 0 ? (greenCount / total) : 0.0,
          color: AppColors.rouletteGreen,
        ),
      ],
    );
  }
}

/// Item individual de estadística
class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final double percent;
  final Color color;

  const _StatItem({
    required this.label,
    required this.count,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption,
        ),
        Text(
          '$count',
          style: AppTypography.body2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          Helpers.formatPercentage(percent),
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
