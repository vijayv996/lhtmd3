import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit_with_entries.dart';
import 'package:lhtmd3/services/database.dart';
import 'package:lhtmd3/util/date_util.dart';
import 'package:lhtmd3/widgets/heatmap_tile.dart';

class HeatmapHabitsPage extends StatefulWidget {
  final VoidCallback toggleHomePage;
  const HeatmapHabitsPage({
    super.key,
    required this.toggleHomePage,
  });

  @override
  State<HeatmapHabitsPage> createState() => _HeatmapHabitsPageState();
}

class _HeatmapHabitsPageState extends State<HeatmapHabitsPage> {
  late Future<List<HabitWithEntries>> _habitsList;
  final databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _habitsList = databaseService.getHabitsWithEntries([DateTime(2024, 1, 1), DateUtil.stripTime(DateTime.now())]); // to get all habits replace with year 2000 maybe
  }

  void loadHabits() {
    _habitsList = databaseService.getHabitsWithEntries([DateTime(2024, 1, 1), DateUtil.stripTime(DateTime.now())]);
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
      body: FutureBuilder<List<HabitWithEntries>>(
        future: _habitsList, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No Habits found.');
          } else {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.map((habit) {
                  final entryMap = {
                    for(var entry in habit.entries) DateUtil.stripTime(entry.entryDate): entry.value.toInt()
                  };
                  return HeatmapTile(
                    entryMap: entryMap,
                    habitName: habit.habit.habitName,
                  );
                }).toList(),
              ),
            );
          }
        }
      ),
    );
  }
}