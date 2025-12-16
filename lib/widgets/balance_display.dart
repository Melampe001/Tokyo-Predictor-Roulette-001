import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/helpers.dart';

/// Widget de visualización de balance con animaciones
class BalanceDisplay extends StatelessWidget {
  final double balance;
  final double currentBet;
  final String? lastResult;
  final bool won;

  const BalanceDisplay({
    super.key,
    required this.balance,
    required this.currentBet,
    this.lastResult,
    this.won = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardBackgroundDark
          : AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Balance principal
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 32,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: balance),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Text(
                      Helpers.formatBalance(value),
                      style: AppTypography.balance.copyWith(
                        color: balance > 1000
                            ? AppColors.success
                            : balance > 500
                                ? AppColors.warning
                                : AppColors.error,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Label
            Text(
              'Balance Actual',
              style: AppTypography.caption.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
            
            const Divider(height: 24),
            
            // Apuesta actual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apuesta Actual:',
                  style: AppTypography.body2,
                ),
                Text(
                  Helpers.formatBalance(currentBet),
                  style: AppTypography.bet.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            
            // Último resultado
            if (lastResult != null) ...[
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: won
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: won ? AppColors.success : AppColors.error,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      won ? Icons.trending_up : Icons.trending_down,
                      color: won ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lastResult!,
                      style: AppTypography.body2.copyWith(
                        color: won ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
