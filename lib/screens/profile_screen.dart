import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';

/// Profile screen showing user information and achievements
class ProfileScreen extends StatelessWidget {
  final String email;
  final double totalWins;
  final double totalLosses;
  final int totalGames;
  final double highScore;

  const ProfileScreen({
    super.key,
    required this.email,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.totalGames = 0,
    this.highScore = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final netProfit = totalWins - totalLosses;
    final winRate = totalGames > 0 ? (totalWins / (totalWins + totalLosses) * 100) : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          CustomIconButton(
            icon: Icons.edit,
            onPressed: () {
              // TODO: Implement profile editing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edición de perfil próximamente'),
                ),
              );
            },
            tooltip: 'Editar perfil',
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: ResponsiveHelper.responsivePadding(context),
          children: [
            // Profile header
            CustomCard(
              color: theme.colorScheme.primaryContainer,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    email,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      _getUserLevel(totalGames),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats grid
            ResponsiveBuilder(
              mobile: (context) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Juegos',
                          value: totalGames.toString(),
                          icon: Icons.casino,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Récord',
                          value: '\$${highScore.toStringAsFixed(0)}',
                          icon: Icons.stars,
                          iconColor: const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Ganado',
                          value: '\$${totalWins.toStringAsFixed(0)}',
                          icon: Icons.trending_up,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Perdido',
                          value: '\$${totalLosses.toStringAsFixed(0)}',
                          icon: Icons.trending_down,
                          iconColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              tablet: (context) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Juegos Totales',
                          value: totalGames.toString(),
                          icon: Icons.casino,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Récord',
                          value: '\$${highScore.toStringAsFixed(0)}',
                          icon: Icons.stars,
                          iconColor: const Color(0xFFFFD700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Tasa de Victoria',
                          value: '${winRate.toStringAsFixed(1)}%',
                          icon: Icons.percent,
                          iconColor: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Total Ganado',
                          value: '\$${totalWins.toStringAsFixed(0)}',
                          icon: Icons.trending_up,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Total Perdido',
                          value: '\$${totalLosses.toStringAsFixed(0)}',
                          icon: Icons.trending_down,
                          iconColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Beneficio Neto',
                          value: '\$${netProfit.toStringAsFixed(0)}',
                          icon: netProfit >= 0 ? Icons.add_circle : Icons.remove_circle,
                          iconColor: netProfit >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievements section
            _SectionHeader(title: 'Logros'),
            const SizedBox(height: 12),
            _AchievementsGrid(
              totalGames: totalGames,
              totalWins: totalWins,
              highScore: highScore,
            ),
            const SizedBox(height: 24),

            // Progress section
            _SectionHeader(title: 'Progreso'),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nivel ${_getUserLevelNumber(totalGames)}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '${totalGames}/${_getNextLevelRequirement(totalGames)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _getLevelProgress(totalGames),
                      minHeight: 12,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Juega ${_getNextLevelRequirement(totalGames) - totalGames} juegos más para alcanzar el siguiente nivel',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getUserLevel(int games) {
    if (games < 10) return 'Novato';
    if (games < 50) return 'Aprendiz';
    if (games < 100) return 'Jugador';
    if (games < 250) return 'Experto';
    if (games < 500) return 'Maestro';
    return 'Leyenda';
  }

  int _getUserLevelNumber(int games) {
    if (games < 10) return 1;
    if (games < 50) return 2;
    if (games < 100) return 3;
    if (games < 250) return 4;
    if (games < 500) return 5;
    return 6;
  }

  int _getNextLevelRequirement(int games) {
    if (games < 10) return 10;
    if (games < 50) return 50;
    if (games < 100) return 100;
    if (games < 250) return 250;
    if (games < 500) return 500;
    return 1000;
  }

  double _getLevelProgress(int games) {
    final currentLevel = _getUserLevelNumber(games);
    final nextRequirement = _getNextLevelRequirement(games);
    
    int previousRequirement = 0;
    if (currentLevel == 2) previousRequirement = 10;
    if (currentLevel == 3) previousRequirement = 50;
    if (currentLevel == 4) previousRequirement = 100;
    if (currentLevel == 5) previousRequirement = 250;
    if (currentLevel == 6) previousRequirement = 500;
    
    final progress = (games - previousRequirement) / (nextRequirement - previousRequirement);
    return progress.clamp(0.0, 1.0);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  final int totalGames;
  final double totalWins;
  final double highScore;

  const _AchievementsGrid({
    required this.totalGames,
    required this.totalWins,
    required this.highScore,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = _getAchievements();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isMobile(context) ? 3 : 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _AchievementBadge(
          icon: achievement['icon'] as IconData,
          label: achievement['label'] as String,
          isUnlocked: achievement['unlocked'] as bool,
          color: achievement['color'] as Color,
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAchievements() {
    return [
      {
        'icon': Icons.play_circle,
        'label': 'Primer Giro',
        'unlocked': totalGames >= 1,
        'color': Colors.blue,
      },
      {
        'icon': Icons.casino,
        'label': '10 Juegos',
        'unlocked': totalGames >= 10,
        'color': Colors.green,
      },
      {
        'icon': Icons.rocket_launch,
        'label': '50 Juegos',
        'unlocked': totalGames >= 50,
        'color': Colors.orange,
      },
      {
        'icon': Icons.emoji_events,
        'label': '100 Juegos',
        'unlocked': totalGames >= 100,
        'color': const Color(0xFFFFD700),
      },
      {
        'icon': Icons.attach_money,
        'label': 'Primera Victoria',
        'unlocked': totalWins > 0,
        'color': Colors.green,
      },
      {
        'icon': Icons.trending_up,
        'label': 'Alto Balance',
        'unlocked': highScore >= 2000,
        'color': Colors.purple,
      },
    ];
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isUnlocked;
  final Color color;

  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.isUnlocked,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.all(12),
      color: isUnlocked 
        ? color.withOpacity(0.1) 
        : theme.colorScheme.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: isUnlocked ? color : theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isUnlocked 
                ? theme.colorScheme.onSurface 
                : theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
