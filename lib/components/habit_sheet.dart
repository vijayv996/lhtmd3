import 'package:flutter/material.dart';
import 'package:lhtmd3/models/habit.dart';
import 'package:lhtmd3/services/database.dart';

class HabitSheet extends StatefulWidget {
  const HabitSheet({
    super.key,
  });

  @override
  State<HabitSheet> createState() => _HabitSheetState();
}

class _HabitSheetState extends State<HabitSheet> {
  HabitType _habitType = HabitType.yesNo;
  final _nameController = TextEditingController();
  final _unitsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Habit Name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            Text(
              'Habit Type:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            RadioGroup<HabitType>(
              groupValue: _habitType,
              onChanged: (HabitType? value) {
                if(value != null) {
                  setState(() {
                    _habitType = value;
                  });
                }
              },
              child: Column(
                children: [
                  RadioListTile(
                    title: Text('Yes or No'),
                    value: HabitType.yesNo,
                  ),
                  RadioListTile(
                    title: Text('Measurable'),
                    value: HabitType.measurable,
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.vertical,
                    child: child,
                  ),
                );
              },
              child: _habitType == HabitType.measurable? TextField(
                controller: _unitsController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Units',
                ),
              ) : SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    final databaseService = DatabaseService();
                    final habit = Habit(
                      userId: 1, 
                      habitId: null,
                      habitName: _nameController.text,
                      habitType: _habitType,
                      measurementUnit: _unitsController.text,
                    );
                    Navigator.pop(context);
                    await databaseService.insertHabit(habit);
                    setState(() {
                      // TODO: reload HabitTiles in habits_page
                    });
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
