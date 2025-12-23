import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/custom_card.dart';
import '../widgets/number_selector.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';

/// Statistics screen showing game analytics
class StatisticsScreen extends StatefulWidget {
  final List<int> history;
  final double totalWins;
  final double totalLosses;
  final int totalGames;

  const StatisticsScreen({
    super.key,
    required this.history,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.totalGames = 0,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriod = 0; // 0: All, 1: Last 50, 2: Last 20

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredHistory = _getFilteredHistory();
    final frequency = _calculateFrequency(filteredHistory);
    final colorStats = _calculateColorStats(filteredHistory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: ResponsiveHelper.responsivePadding(context),
          children: [
            // Period selector
            _PeriodSelector(
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
            ),
            const SizedBox(height: 16),

            // Summary cards
            ResponsiveBuilder(
              mobile: (context) => Column(
                children: [
                  InfoCard(
                    title: 'Total de Giros',
                    value: filteredHistory.length.toString(),
                    icon: Icons.casino,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    title: 'Ganancias',
                    value: '\$${widget.totalWins.toStringAsFixed(2)}',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    title: 'Pérdidas',
                    value: '\$${widget.totalLosses.toStringAsFixed(2)}',
                    icon: Icons.trending_down,
                    color: Colors.red,
                  ),
                ],
              ),
              tablet: (context) => Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      title: 'Total de Giros',
                      value: filteredHistory.length.toString(),
                      icon: Icons.casino,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      title: 'Ganancias',
                      value: '\$${widget.totalWins.toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      title: 'Pérdidas',
                      value: '\$${widget.totalLosses.toStringAsFixed(2)}',
                      icon: Icons.trending_down,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Color distribution chart
            if (filteredHistory.isNotEmpty) ...[
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribución por Color',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: colorStats['red']!.toDouble(),
                              title: '${colorStats['red']}',
                              color: const Color(0xFFD32F2F),
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: colorStats['black']!.toDouble(),
                              title: '${colorStats['black']}',
                              color: const Color(0xFF1A1A1A),
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: colorStats['green']!.toDouble(),
                              title: '${colorStats['green']}',
                              color: const Color(0xFF2E7D32),
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _LegendItem(
                          color: const Color(0xFFD32F2F),
                          label: 'Rojo',
                          value: colorStats['red']!,
                        ),
                        _LegendItem(
                          color: const Color(0xFF1A1A1A),
                          label: 'Negro',
                          value: colorStats['black']!,
                        ),
                        _LegendItem(
                          color: const Color(0xFF2E7D32),
                          label: 'Verde',
                          value: colorStats['green']!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Top 10 most frequent numbers
            if (frequency.isNotEmpty) ...[
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Números Más Frecuentes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FrequencyChart(
                      frequency: frequency,
                      maxCount: filteredHistory.length,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Recent history
            if (filteredHistory.isNotEmpty) ...[
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historial Reciente',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    NumberHistory(
                      numbers: filteredHistory,
                      itemSize: 48,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Empty state
            if (filteredHistory.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 80,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay datos todavía',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza a jugar para ver tus estadísticas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<int> _getFilteredHistory() {
    switch (_selectedPeriod) {
      case 1: // Last 50
        return widget.history.length > 50
            ? widget.history.sublist(widget.history.length - 50)
            : widget.history;
      case 2: // Last 20
        return widget.history.length > 20
            ? widget.history.sublist(widget.history.length - 20)
            : widget.history;
      default: // All
        return widget.history;
    }
  }

  Map<int, int> _calculateFrequency(List<int> history) {
    final freq = <int, int>{};
    for (final num in history) {
      freq[num] = (freq[num] ?? 0) + 1;
    }
    return freq;
  }

  Map<String, int> _calculateColorStats(List<int> history) {
    int red = 0, black = 0, green = 0;
    
    for (final num in history) {
      if (num == 0) {
        green++;
      } else if (AppConstants.redNumbers.contains(num)) {
        red++;
      } else {
        black++;
      }
    }
    
    return {'red': red, 'black': black, 'green': green};
  }
}

class _PeriodSelector extends StatelessWidget {
  final int selectedPeriod;
  final ValueChanged<int> onPeriodChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(
          value: 0,
          label: Text('Todos'),
          icon: Icon(Icons.all_inclusive),
        ),
        ButtonSegment(
          value: 1,
          label: Text('Últimos 50'),
          icon: Icon(Icons.filter_list),
        ),
        ButtonSegment(
          value: 2,
          label: Text('Últimos 20'),
          icon: Icon(Icons.filter_alt),
        ),
      ],
      selected: {selectedPeriod},
      onSelectionChanged: (Set<int> selected) {
        onPeriodChanged(selected.first);
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall,
            ),
            Text(
              value.toString(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FrequencyChart extends StatelessWidget {
  final Map<int, int> frequency;
  final int maxCount;

  const _FrequencyChart({
    required this.frequency,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final top10 = sortedEntries.take(10).toList();

    return Column(
      children: top10.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final percentage = (item.value / maxCount * 100);
        final color = _getNumberColor(item.key);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: CompactNumberDisplay(
                      number: item.key,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Número ${item.key}',
                              style: theme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${item.value} (${percentage.toStringAsFixed(1)}%)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: theme.colorScheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation(color),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
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
