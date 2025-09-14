import 'package:flutter/material.dart';
import 'package:lhtmd3/widgets/date_tile.dart';
import 'package:lhtmd3/widgets/habit_sheet.dart';
import 'package:lhtmd3/widgets/habit_tile.dart';
import 'package:lhtmd3/models/habit_with_entries.dart';
import 'package:lhtmd3/services/database.dart';
import 'package:lhtmd3/util/date_util.dart';

class Habits extends StatefulWidget {
  final VoidCallback toggleHomePage;
  const Habits({
    super.key,
    required this.toggleHomePage,
  });

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  late Future<List<HabitWithEntries>> _habitsList;
  final databaseService = DatabaseService();
  List<DateTime> _dates = [];
  double? _lastWidth;
  
  @override
  void initState() {
    super.initState();
    // Initialize _habitsList to avoid a LateInitializationError on the first build.
    _habitsList = Future.value([]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    // Reload habits if the width changes to make the date view responsive.
    if (width != _lastWidth) {
      _lastWidth = width;
      loadHabits();
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
        actions: [
          IconButton(
            // TODO: implement sorting
            onPressed: () {}, 
            tooltip: 'Sort',
            icon: Icon(Icons.sort)
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: IconButton(
              // TODO: github heatmap like ui
              onPressed: () {
                widget.toggleHomePage();
              }, 
              tooltip: 'graph view',
              icon: Icon(Icons.view_agenda)
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        children: [
          DateTile(dates: _dates),
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
                      measurementUnits: habit.habit.measurementUnit,
                      onUpdate: loadHabits,
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context, 
            showDragHandle: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return HabitSheet(onHabitAdded: loadHabits);
            },
          );
        },
        label: Text('Add Habit'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
