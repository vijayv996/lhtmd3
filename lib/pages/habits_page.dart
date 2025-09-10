import 'package:flutter/material.dart';
import 'package:lhtmd3/components/date_tile.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/models/habit_with_entries.dart';
import 'package:lhtmd3/services/database.dart';
import 'package:lhtmd3/util/date_util.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  late Future<List<HabitWithEntries>> _habitsList;
  final databaseService = DatabaseService();
  List<DateTime> _dates = [];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadHabits();
    });
  }

  void loadHabits() {
    var width = MediaQuery.sizeOf(context).width;
    int maxIcons = ((width - 200) / 45).floor().clamp(1, 100);

    final newDates = <DateTime>[];
    for(int i = 0; i < maxIcons; i++) {
      newDates.add(DateUtil.stripTime(DateTime.now().subtract(Duration(days: maxIcons - 1 - i))));
    }

    setState(() {
      _dates = newDates;
      _habitsList = databaseService.getHabitsWithEntries(_dates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DateTile(dates: _dates),
        ListTile(title: Text('delete database'),
        onTap: databaseService.deleteDatabase,),
        FutureBuilder<List<HabitWithEntries>>(
          future: _habitsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),); 
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No habits found.');
            } else {
              return Column(
                children: snapshot.data!.map((habit) {
                  return HabitTile(
                    habitName: habit.habit.habitName,
                    habitId: habit.habit.habitId!,
                    habitType: habit.habit.habitType,
                    dates: _dates,
                    habitEntries: habit.entries,
                    onUpdate: loadHabits,
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}

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
                        newValue = existingEntry.value == 0 ? 1 : 0;
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
                    : Text('temp'),
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
