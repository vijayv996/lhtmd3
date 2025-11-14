import 'package:flutter/material.dart';
import 'package:lhtmd3/services/database.dart';
import 'package:lhtmd3/widgets/heat_map_widget.dart';
import 'package:lhtmd3/widgets/pomo_bar_chart.dart';
import 'package:lhtmd3/widgets/stat_card.dart';

class PomodoroStats extends StatelessWidget {
  const PomodoroStats({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Stats'),
      ),
      body: FutureBuilder(
        future: db.getPomoStats(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if(snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'),);
          } else {
            final pomos = snapshot.data!;
            final todayMinutes = pomos.todayDuration;
            final todayFocusString = '${todayMinutes ~/ 60}h ${todayMinutes % 60}m';
            final allTimeMinutes = pomos.allDuration;
            final allTimeFocusString = '${allTimeMinutes ~/ 60}h ${allTimeMinutes % 60}m';
            final yesterdayPomoDiff = (pomos.todayPomo - pomos.yesterdayPomo).abs();
            final yesterdayDurationDiff = (todayMinutes - pomos.yesterdayDuration).abs();
            final isTodayLower = (pomos.todayPomo - pomos.yesterdayPomo) < 0;

            final screenWidth = MediaQuery.of(context).size.width;
            const barWidth = 20;
            const barSpacing = 45;
            final chartWidth = (pomos.chartData.length * (barWidth + barSpacing)).toDouble();
            final isScrollable = chartWidth > screenWidth;
            Widget chartWidget = isScrollable 
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 300,
                    width: chartWidth,
                    child: PomoBarChart(chartData: pomos.chartData,)
                  ),
                )
              : PomoBarChart(chartData: pomos.chartData,);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Today's Pomo",
                          subTitle: pomos.todayPomo.toString(),
                          fontSize: 32,
                          yesterdayValue: '$yesterdayPomoDiff from yesterday',
                          isTodayLower: isTodayLower,
                        ),
                      ),
                      Expanded(
                        child: StatCard(
                          title: "Today's Focus (h)",
                          subTitle: todayFocusString,
                          fontSize: 32,
                          yesterdayValue:
                              '${yesterdayDurationDiff ~/ 60}h ${yesterdayDurationDiff % 60}m from yesterday',
                          isTodayLower: isTodayLower,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Total Pomos",
                          subTitle: pomos.allPomos.toString(),
                        ),
                      ),
                      Expanded(
                        child: StatCard(
                          title: "Total Focus Duration",
                          subTitle: allTimeFocusString,
                        ),
                      ),
                    ],
                  ),
                  chartWidget,
                  Card(
                    margin: EdgeInsets.all(10),
                    child: HeatMapWidget(
                      entryMap: pomos.heatmapData,
                      showText: false,
                      size: 20
                    ),
                  ),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}
