import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapWidget extends StatelessWidget {
  const HeatMapWidget({
    super.key,
    required this.entryMap,
    required this.showText,
    required this.size,
  });

  final Map<DateTime, int> entryMap;
  final bool showText;
  final double size;

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      margin: EdgeInsets.all(2),
      scrollable: true,
      showColorTip: false,
      size: size,
      fontSize: 10,
      showText: showText,
      textColor: Theme.of(context).colorScheme.onPrimaryContainer,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.outlineVariant,
      datasets: entryMap,
      colorsets: {
        1: Theme.of(context).colorScheme.primaryContainer,
        2: Theme.of(context).colorScheme.tertiaryContainer,
      },
      onClick: (value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
      },
    );
  }
}