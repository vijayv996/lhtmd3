import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/util/date_util.dart';
import 'package:lhtmd3/widgets/heat_map_widget.dart';


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
              child: HeatMapWidget(
                entryMap: entryMap, 
                showText: true, 
                size: 18,
              ),
            ),
          ),
          // TODO: add more stats like graphs, streaks n shii
        ],
      ),
    );
  }
}
