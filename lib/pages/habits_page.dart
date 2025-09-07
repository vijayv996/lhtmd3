import 'package:flutter/material.dart';
import 'package:lhtmd3/components/date_tile.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/models/habit_entry.dart';
import 'package:lhtmd3/models/habit_with_entries.dart';
import 'package:lhtmd3/services/database.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    int maxIcons = ((width - 200) / 45).floor().clamp(1, 100);
    final databaseService = DatabaseService();
    final habitsList = databaseService.getHabitsWithEntries(maxIcons);
    return ListView(
      children: [
        // TODO: send dates list
        DateTile(),
        FutureBuilder<List<HabitWithEntries>>(
          future: habitsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Or some other loading indicator
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
                    habitEntries: habit.entries,
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
  final List<HabitEntry> habitEntries;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitId,
    required this.habitType,
    required this.habitEntries,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}


// claude 
class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // int maxIcons = ((constraints.maxWidth - 200) / 45).floor().clamp(1, 100);
        return ListTile(
          contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
          title: Text(widget.habitName),
          leading: Icon(Icons.incomplete_circle),
          trailing: Wrap(
            children: [
              for(final entry in widget.habitEntries)
                SizedBox(
                  height: 48,
                  width: 48,
                  child: widget.habitType == HabitType.yesNo
                    ? IconButton(onPressed: () async {
                      final databaseService = DatabaseService();
                      final entry = HabitEntry(
                        entryId: entryId, 
                        habitId: habitId, 
                        entryDate: entryDate, 
                        value: value
                      );
                    }, icon: _getIconForEntry(entry.value))
                    : Text('temp'),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget _getIconForEntry(double value) {
  return Icon(
    value == 0 ? Icons.close : value == 1 ? Icons.check : Icons.remove,
  );
}
