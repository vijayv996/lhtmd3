import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/util/date_util.dart';


class Stats extends StatelessWidget {
  final List<HabitEntry> habitEntries;

  const Stats({
    super.key,
    required this.habitEntries,
  });

  @override
  Widget build(BuildContext context) {
    final entryMap = {
      for(var entry in habitEntries) DateUtil.stripTime(entry.entryDate): entry.value.toInt()
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(
        children: [
          Text('Calender',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: HeatMap(
                margin: EdgeInsets.all(2),
                scrollable: true,
                showColorTip: false,
                size: 18.0,
                fontSize: 10,
                showText: true,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}