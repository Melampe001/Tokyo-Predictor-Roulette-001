import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Card de predicción con animaciones
class PredictionCard extends StatelessWidget {
  final PredictionModel? prediction;
  final VoidCallback? onTap;

  const PredictionCard({
    super.key,
    this.prediction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (prediction == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      color: AppColors.accent.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.accent.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Icono de bombilla
              const Icon(
                Icons.lightbulb,
                size: 36,
                color: AppColors.accent,
              ),
              const SizedBox(height: 12),
              
              // Título
              Text(
                'Predicción Sugerida',
                style: AppTypography.h6.copyWith(
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              
              // Número predicho con animación
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppColors.elevatedShadow,
                      ),
                      child: Center(
                        child: Text(
                          prediction!.predictedNumber.toString(),
                          style: AppTypography.rouletteNumber.copyWith(
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              
              // Barra de confianza
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Confianza',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(prediction!.confidence * 100).toStringAsFixed(0)}%',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: prediction!.confidence,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getConfidenceColor(prediction!.confidence),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Información adicional
              Text(
                '(basada en historial reciente)',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              // Método de predicción
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  prediction!.method == 'frequency_analysis'
                      ? 'Análisis de frecuencia'
                      : 'Aleatorio',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.7) return AppColors.success;
    if (confidence >= 0.4) return AppColors.warning;
    return AppColors.error;
  }
}
