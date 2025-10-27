import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PomoBarChart extends StatelessWidget {
  final Map<String, double> chartData;

  const PomoBarChart({
    super.key,
    required this.chartData
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 4 / 2.5,
        child: Container(
          margin: const EdgeInsets.only(bottom: 30, top: 50),
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData(context),
              titlesData: titlesData,
              borderData: FlBorderData(show: false),
              barGroups: barGroups(context),
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> barGroups(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final items = chartData.entries.toList();
    return [
      for (int i = 0; i < items.length; i++) 
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: items[i].value, color: primaryColor, width: 20),
          ],
          showingTooltipIndicators: [0],
        ),
    ];
  }

  FlTitlesData get titlesData => FlTitlesData(
    leftTitles: AxisTitles(
      axisNameWidget: Text('hours'),
      sideTitles: SideTitles(
        showTitles: false,
      )
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      ),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: false,
      )
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 30,
        showTitles: true,
        getTitlesWidget: (double value, TitleMeta meta) {
          final items = chartData.entries.toList();
          return SideTitleWidget(
            meta: meta,
            child: Text(items[value.toInt()].key), 
          );
        },
      ),
    ),
  );

  BarTouchData barTouchData(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.toStringAsFixed(1),
            TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
