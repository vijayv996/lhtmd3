import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PomoBarChart extends StatelessWidget {
  const PomoBarChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 19 / 9,
        child: Container(
          margin: const EdgeInsets.all(1),
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(toY: 10),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(toY: 5),
                  ],
                  showingTooltipIndicators: [0]
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(toY: 4)
                  ]
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(toY: 6)
                  ]
                ),
                BarChartGroupData(
                  x: 4,
                  barRods: [
                    BarChartRodData(toY: 8)
                  ]
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: Text('hours'),
                  sideTitles: SideTitles(
                    reservedSize: 25,
                    showTitles: true,
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
                      return SideTitleWidget(
                        meta: meta,
                        child: Text('gym'), 
                      );
                    },
                  ),
                ),
              ),
            ),
            duration: Duration(milliseconds: 1000),
            curve: Curves.bounceIn,
          ),
        ),
      ),
    );
  }
}
