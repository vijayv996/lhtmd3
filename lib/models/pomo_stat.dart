class PomoStat {
  final int todayPomo;
  final int todayDuration;
  final int yesterdayPomo;
  final int yesterdayDuration;
  final int allPomos;
  final int allDuration;
  final Map<String, double> chartData;
  final Map<DateTime, int> heatmapData;

  PomoStat({
    required this.todayPomo,
    required this.todayDuration,
    required this.yesterdayPomo,
    required this.yesterdayDuration,
    required this.allPomos,
    required this.allDuration,
    required this.chartData,
    required this.heatmapData,
  });
}
