import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/services/database.dart';
import 'package:lhtmd3/util/date_util.dart';
import 'package:lhtmd3/widgets/heat_map_widget.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HeatmapTile extends StatefulWidget {
  const HeatmapTile({
    super.key,
    required this.entryMap,
    required this.habitName,
    required this.habitType,
    required this.habitId,
  });

  final Map<DateTime, int> entryMap;
  final String habitName;
  final HabitType habitType;
  final int habitId;

  @override
  State<HeatmapTile> createState() => _HeatmapTileState();
}

class _HeatmapTileState extends State<HeatmapTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(Icons.fitness_center),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habitName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          // TODO: user description?
                          Text(
                            'Did you go to gym today?',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Card(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: widget.habitType == HabitType.yesNo
                  ? SizedBox(
                    height: 48,
                    width: 48,
                    child: IconButton(
                      onPressed: () async {
                        final databaseService = DatabaseService();
                        final today = DateUtil.stripTime(DateTime.now());
                        final existingValue = widget.entryMap[today];
                        double newValue;
                        if(existingValue != null) {
                          if(existingValue == 0) {
                            newValue = 1;
                          } else if(existingValue == 1) {
                            newValue = 2;
                          } else {
                            newValue = 0;
                          }
                        } else {
                          newValue = 1;
                        }
                        final newEntry = HabitEntry(
                          habitId: widget.habitId, 
                          entryDate: today, 
                          value: newValue
                        );
                        await databaseService.insertEntry(newEntry);
                        // update()
                      }, // TODO: setstate and update a single entry in entrymap?
                      icon: Icon(Icons.check),
                    ),
                  )
                  : SizedBox(
                    height: 48,
                    width: 48,
                    child: TextButton(
                      onPressed: () {}, 
                      child: Text('')
                    ),
                  )
                )
              ],
            ),
            HeatMapWidget(
              entryMap: widget.entryMap, 
              showText: false, 
              size: 15
            ),
          ],
        ),
      ),
    );
  }
}