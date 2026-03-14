import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/channel_info.dart';

class ChannelChart extends StatelessWidget {
  final List<ChannelInfo> channels;
  final int? highlightChannel;

  const ChannelChart({
    super.key,
    required this.channels,
    this.highlightChannel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxCount = channels.isEmpty
        ? 1.0
        : channels
            .map((c) => c.networkCount)
            .reduce((a, b) => a > b ? a : b)
            .toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxCount + 1,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= channels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${channels[idx].channel}',
                    style: theme.textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value != value.roundToDouble()) {
                  return const SizedBox.shrink();
                }
                return Text(
                  '${value.toInt()}',
                  style: theme.textTheme.labelSmall,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          horizontalInterval: 1,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(channels.length, (i) {
          final ch = channels[i];
          final isHighlighted = ch.channel == highlightChannel;
          final congestionRatio =
              maxCount > 0 ? ch.networkCount / maxCount : 0.0;

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: ch.networkCount.toDouble(),
                color: isHighlighted
                    ? theme.colorScheme.primary
                    : AppTheme.congestionColor(congestionRatio),
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final ch = channels[groupIndex];
              return BarTooltipItem(
                'CH ${ch.channel}\n${ch.networkCount} APs',
                theme.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
