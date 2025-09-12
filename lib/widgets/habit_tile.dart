import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/util/date_util.dart';
import 'package:lhtmd3/pages/stats_page.dart';
import 'package:lhtmd3/widgets/entry_button.dart';

class HabitTile extends StatefulWidget {
  final String habitName;
  final int habitId;
  final HabitType habitType;
  final List<DateTime> dates;
  final List<HabitEntry> habitEntries;
  final String? measurementUnits;
  final Function() onUpdate;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitId,
    required this.habitType,
    required this.dates,
    required this.habitEntries,
    this.measurementUnits,
    required this.onUpdate,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}


class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    final entriesMap = {
      for(var entry in widget.habitEntries) DateUtil.stripTime(entry.entryDate): entry
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListTile(
          contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
          title: Text(widget.habitName),
          leading: Icon(Icons.incomplete_circle),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => Stats(habitEntries: widget.habitEntries)
              )
            );
          },
          trailing: Wrap(
            children: [
              for(final date in widget.dates)
                EntryButton(
                  habitType: widget.habitType, 
                  habitId: widget.habitId, 
                  measurementUnits: widget.measurementUnits,
                  entriesMap: entriesMap, 
                  date: date
                ),
            ],
          ),
        );
      },
    );
  }
}