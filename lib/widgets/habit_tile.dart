import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/util/date_util.dart';
import 'package:lhtmd3/pages/stats_page.dart';
import 'package:lhtmd3/services/database.dart';

class HabitTile extends StatefulWidget {
  final String habitName;
  final int habitId;
  final HabitType habitType;
  final List<DateTime> dates;
  final List<HabitEntry> habitEntries;
  final Function() onUpdate;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitId,
    required this.habitType,
    required this.dates,
    required this.habitEntries,
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
              for(final date in widget.dates) ...[
                SizedBox(
                  height: 48,
                  width: 48,
                  child: widget.habitType == HabitType.yesNo
                    ? IconButton(onPressed: () async {
                      final databaseService = DatabaseService();
                      final existingEntry = entriesMap[date];
                      double newValue;
                      if(existingEntry != null) {
                        if(existingEntry.value == 0) {
                          newValue = 1;
                        } else if(existingEntry.value == 1) {
                          newValue = 2;
                        } else {
                          newValue = 1;
                        }
                      } else {
                        newValue = 1;
                      }

                      final newentry = HabitEntry(
                        entryId: entriesMap[date]?.entryId,
                        habitId: widget.habitId, 
                        entryDate: date, 
                        value: newValue
                      );
                      await databaseService.insertEntry(newentry);
                      widget.onUpdate();
                    }, icon: _getIconForEntry(entriesMap[date]?.value))
                    : TextButton(
                      onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter Value: '),
                              content: TextField(),
                              actions: [
                                TextButton(
                                  onPressed: () {}, 
                                  child: Text('CANCEL')
                                ),
                                FilledButton(
                                  onPressed: () {}, 
                                  child: Text('OK')
                                ),
                              ],
                            );
                          },
                        );
                      }, 
                      child: Text('Te')
                    ), // TODO: implement measurable habit entries
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

Widget _getIconForEntry(double? value) {
  IconData icon = Icons.close;
  if(value == 0 || value == null) icon = Icons.close;
  if(value == 1) icon = Icons.check;
  if(value == 2) icon = Icons.remove;
  return Icon(icon);
}
