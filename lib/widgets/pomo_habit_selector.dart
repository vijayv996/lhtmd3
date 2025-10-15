import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/services/database.dart';

class PomoHabitSelector extends StatefulWidget {
  final Function(String, int?) onHabitSelected;

  const PomoHabitSelector({
    super.key,
    required this.onHabitSelected,
  });

  @override
  State<PomoHabitSelector> createState() => _PomoHabitSelectorState();
}

class _PomoHabitSelectorState extends State<PomoHabitSelector> {
  late Future<List<Habit>> _habitsFuture;
  String? pomoName;

  @override
  void initState() {
    super.initState();
    _habitsFuture = DatabaseService().getHabits(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Habit to focus: ',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16,),
          Expanded(
            child: FutureBuilder(
              future: _habitsFuture, 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if(snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'),);
                } else if(!snapshot.hasData) {
                  return const Center(child: Text('no habits avaliable'),);
                } else {
                  final habits = snapshot.data!;
                  return ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.mediation_sharp),
                        title: Text('focus'),
                        onTap: () {
                          Navigator.pop(context);
                          widget.onHabitSelected('focus', null);
                        },
                      ),
                      for(final habit in habits)
                        ListTile(
                          leading: Icon(Icons.fitness_center), // TODO: make this user selected Icon of the habit
                          title: Text(habit.habitName),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onHabitSelected(habit.habitName, habit.habitId);
                          },
                        )
                    ],
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
